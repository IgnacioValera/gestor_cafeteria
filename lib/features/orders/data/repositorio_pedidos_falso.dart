import '../domain/pedido.dart';

/// Repositorio de prueba que simula la API de pedidos.
///
/// Tarda [espera] en responder y la primera llamada falla, para poder
/// probar a mano el estado de error y el botón Reintentar.
class RepositorioPedidosFalso {
  RepositorioPedidosFalso({this.espera = const Duration(seconds: 2)});

  final Duration espera;
  int _llamadas = 0;

  Future<List<Pedido>> obtener() async {
    await Future.delayed(espera);
    _llamadas++;
    if (_llamadas == 1) throw Exception('Sin conexión'); // falla la 1a vez
    return const [
      Pedido(
        folio: 101,
        descripcion: '1 café americano y 1 pan dulce',
        total: 57,
        estado: EstadoPedido.entregado,
      ),
      Pedido(
        folio: 102,
        descripcion: '1 latte',
        total: 48,
        notas: 'Sin azúcar',
      ),
      Pedido(
        folio: 103,
        descripcion: '1 café americano y 1 latte',
        total: 83,
        estado: EstadoPedido.preparando,
      ),
      Pedido(
        folio: 104,
        descripcion: '2 capuchinos',
        total: 104,
        notas: 'Con leche de almendra',
      ),
      Pedido(
        folio: 105,
        descripcion: '1 té chai y 2 galletas',
        total: 70,
        estado: EstadoPedido.preparando,
      ),
      Pedido(
        folio: 106,
        descripcion: '1 chocolate caliente',
        total: 45,
        estado: EstadoPedido.entregado,
      ),
    ];
  }
}
