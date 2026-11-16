enum EstadoPedido {
  pendiente('Pendiente'),
  preparando('Preparando'),
  entregado('Entregado');

  const EstadoPedido(this.etiqueta);
  final String etiqueta;
}

/// Pedido de la cafetería (entidad de la T1, sin lista de productos para
/// mantener la pantalla simple).
class Pedido {
  const Pedido({
    required this.folio,
    required this.descripcion,
    required this.total,
    this.estado = EstadoPedido.pendiente,
    this.notas,
  });

  final int folio;

  /// Resumen de lo que se pidió, por ejemplo "2 lattes y 1 pan dulce".
  final String descripcion;
  final double total;

  // Opcional con valor por defecto: todo pedido nace pendiente.
  final EstadoPedido estado;

  // Opcional nullable: el cliente puede o no dejar indicaciones.
  final String? notas;
}
