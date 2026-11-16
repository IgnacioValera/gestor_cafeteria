import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_cafeteria/core/failure.dart';
import 'package:gestor_cafeteria/core/http_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// Crea un ApiClient que usa un MockClient en lugar de la red.
ApiClient clienteFalso(
  Future<http.Response> Function(http.Request request) manejador, {
  Duration timeout = const Duration(seconds: 10),
}) {
  return ApiClient(
    client: MockClient(manejador),
    baseUrl: 'http://prueba',
    timeout: timeout,
  );
}

/// Respuesta JSON con el Content-Type correcto.
http.Response respuestaJson(Object cuerpo, int codigo) => http.Response(
  jsonEncode(cuerpo),
  codigo,
  headers: {'content-type': 'application/json'},
);

void main() {
  group('ApiClient', () {
    test('1. éxito: un 200 devuelve el JSON decodificado', () async {
      final api = clienteFalso((request) async {
        return respuestaJson([
          {'id': 1, 'customer': 'Ana'},
        ], 200);
      });

      final resultado = await api.get('/orders');

      expect(resultado, isA<List>());
      expect(resultado, [
        {'id': 1, 'customer': 'Ana'},
      ]);
    });

    test('2. no encontrado: un 404 lanza NotFoundFailure con el mensaje de detail', () {
      final api = clienteFalso((request) async {
        return respuestaJson({'detail': 'Order 9 not found'}, 404);
      });

      expect(
        api.get('/orders/9'),
        throwsA(
          isA<NotFoundFailure>().having(
            (f) => f.message,
            'message',
            'Order 9 not found',
          ),
        ),
      );
    });

    test('3. conflicto: un 409 lanza ConflictFailure con el mensaje de detail', () {
      final api = clienteFalso((request) async {
        return respuestaJson({
          'detail': 'Cannot change status from pending to delivered',
        }, 409);
      });

      expect(
        api.patch('/orders/1', {'status': 'delivered'}),
        throwsA(
          isA<ConflictFailure>().having(
            (f) => f.message,
            'message',
            'Cannot change status from pending to delivered',
          ),
        ),
      );
    });

    test('4. validación: un 422 lanza ValidationFailure con el mapa de campos', () {
      final api = clienteFalso((request) async {
        return respuestaJson({
          'detail': [
            {
              'loc': ['body', 'customer'],
              'msg': 'Must be 1-50 characters',
            },
          ],
        }, 422);
      });

      expect(
        api.post('/orders', {'customer': '', 'drink': 'latte', 'size': 'M'}),
        throwsA(
          isA<ValidationFailure>().having((f) => f.fields, 'fields', {
            'customer': 'Must be 1-50 characters',
          }),
        ),
      );
    });

    test('5. servidor: un 503 lanza ServerFailure con statusCode 503', () {
      final api = clienteFalso((request) async {
        return respuestaJson({'detail': 'Simulated failure'}, 503);
      });

      expect(
        api.get('/orders'),
        throwsA(
          isA<ServerFailure>().having((f) => f.statusCode, 'statusCode', 503),
        ),
      );
    });

    test('6a. sin conexión: una ClientException lanza NetworkFailure', () {
      final api = clienteFalso((request) async {
        throw http.ClientException('sin red');
      });

      expect(api.get('/orders'), throwsA(isA<NetworkFailure>()));
    });

    test('6b. tiempo agotado: si tarda más que el timeout lanza NetworkFailure', () {
      final api = clienteFalso((request) async {
        await Future<void>.delayed(const Duration(milliseconds: 200));
        return respuestaJson([], 200);
      }, timeout: const Duration(milliseconds: 50));

      expect(api.get('/orders'), throwsA(isA<NetworkFailure>()));
    });
  });
}
