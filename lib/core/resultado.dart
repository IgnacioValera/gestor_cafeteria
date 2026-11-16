/// Estado de una carga asíncrona: cargando, con datos o con error.
///
/// Es `sealed`, así que todos sus subtipos están en este archivo y el
/// compilador puede comprobar que un `switch` los cubre todos (sin `default`).
sealed class Resultado<T> {
  const Resultado();
}

class Cargando<T> extends Resultado<T> {
  const Cargando();
}

class Exito<T> extends Resultado<T> {
  const Exito(this.datos);
  final T datos;
}

/// Nota: este nombre tapa a `Error` de dart:core dentro de los archivos que
/// lo importan. Se conserva para coincidir con la T1 y los decks.
class Error<T> extends Resultado<T> {
  const Error(this.mensaje);
  final String mensaje;
}
