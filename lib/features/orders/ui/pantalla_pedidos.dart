import 'package:flutter/material.dart';

import '../../../core/resultado.dart';
import '../data/repositorio_pedidos_falso.dart';
import '../domain/pedido.dart';

/// Lista de pedidos con tres estados: cargando, lista y error con reintento.
class PantallaPedidos extends StatefulWidget {
  const PantallaPedidos({super.key, required this.repositorio});

  final RepositorioPedidosFalso repositorio;

  @override
  State<PantallaPedidos> createState() => _PantallaPedidosState();
}

class _PantallaPedidosState extends State<PantallaPedidos> {
  Resultado<List<Pedido>> _estado = const Cargando();

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() => _estado = const Cargando());
    try {
      final pedidos = await widget.repositorio.obtener();
      // Durante el await la pantalla pudo cerrarse; llamar setState en un
      // State que ya no está montado lanza una excepción.
      if (!mounted) return;
      setState(() => _estado = Exito(pedidos));
    } catch (_) {
      if (!mounted) return;
      // Mensaje para el usuario: nunca mostramos el texto de la excepción.
      setState(() => _estado = const Error(
            'No pudimos cargar los pedidos. Revisa tu conexión e '
            'inténtalo de nuevo.',
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos')),
      // Switch exhaustivo: Resultado es sealed, no hace falta default.
      body: switch (_estado) {
        Cargando() => const Center(child: CircularProgressIndicator()),
        Exito(datos: final pedidos) => _ListaPedidos(pedidos: pedidos),
        Error(mensaje: final mensaje) =>
          _VistaError(mensaje: mensaje, alReintentar: _cargar),
      },
    );
  }
}

class _ListaPedidos extends StatelessWidget {
  const _ListaPedidos({required this.pedidos});

  final List<Pedido> pedidos;

  @override
  Widget build(BuildContext context) {
    if (pedidos.isEmpty) {
      return const Center(child: Text('Todavía no hay pedidos.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: pedidos.length,
      itemBuilder: (context, i) => _TarjetaPedido(pedido: pedidos[i]),
    );
  }
}

class _TarjetaPedido extends StatelessWidget {
  const _TarjetaPedido({required this.pedido});

  final Pedido pedido;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final notas = pedido.notas;
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('${pedido.folio % 100}')),
        title: Text('Pedido #${pedido.folio}'),
        subtitle: Text(
          notas == null ? pedido.descripcion : '${pedido.descripcion}\n$notas',
        ),
        isThreeLine: notas != null,
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${pedido.total.toStringAsFixed(2)}',
              style: tema.textTheme.titleMedium,
            ),
            Text(pedido.estado.etiqueta, style: tema.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _VistaError extends StatelessWidget {
  const _VistaError({required this.mensaje, required this.alReintentar});

  final String mensaje;
  final VoidCallback alReintentar;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(mensaje, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: alReintentar,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
