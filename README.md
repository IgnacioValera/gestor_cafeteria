# gestor_cafeteria

Cliente Flutter para gestionar los pedidos de una cafetería. Consume la API REST de
[mini_backend](https://github.com/DMI-2026/mini_backend) mediante `ApiClient`, que traduce cada
respuesta HTTP a un `Failure` tipado (`NotFoundFailure`, `ConflictFailure`, `ValidationFailure`,
`ServerFailure`, `UnexpectedFailure` o `NetworkFailure`) para que la app distinga cada tipo de error.

## Requisitos

- Flutter (estable) con Dart 3
- Node.js **22.13 o superior** (`node --version`) para levantar el servidor
- Chrome, un emulador de Android o un celular para ejecutar la app

## Servidor: mini_backend

El servidor es **otro repositorio** y no se incluye aquí:
<https://github.com/DMI-2026/mini_backend> (rama `master`).
Este proyecto se probó con mini_backend en el commit `94d2533`.

```bash
git clone https://github.com/DMI-2026/mini_backend.git
cd mini_backend
node server.js          # no hace falta npm install
```

Debe mostrar `Listening on ...:8000`. Comprueba en el navegador `http://localhost:8000/health`;
responde `{"status":"ok"}`.

## Ejecutar la app

```bash
flutter pub get
flutter run -d chrome                     # usa http://localhost:8000
flutter run                               # emulador de Android: usa http://10.0.2.2:8000
flutter run --dart-define=API_URL=http://<IP-de-tu-computadora>:8000   # celular físico
```

`API_URL` cambia la dirección del servidor. Sin ella se usa `localhost` en web y `10.0.2.2`
en Android. Para el celular, la computadora y el teléfono deben estar en la misma red.

## Pruebas

```bash
flutter test       # pruebas de Failure y de ApiClient (con MockClient, sin red)
flutter analyze    # análisis estático
```

Las pruebas de `ApiClient` no necesitan el servidor: usan `MockClient` de `package:http/testing.dart`.

## Estructura

```
lib/
  core/
    failure.dart        # jerarquía sellada de errores (Failure)
    http_client.dart    # ApiClient: peticiones HTTP y mapeo de códigos a Failure
  main.dart             # pantalla de prueba que lista los pedidos
test/
  core/
    failure_test.dart       # pruebas de la jerarquía de Failure
    http_client_test.dart   # pruebas de ApiClient con MockClient
```
