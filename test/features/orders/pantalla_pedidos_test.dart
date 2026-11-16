import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_cafeteria/features/orders/data/repositorio_pedidos_falso.dart';
import 'package:gestor_cafeteria/features/orders/ui/pantalla_pedidos.dart';

void main() {
  Future<void> abrir(WidgetTester tester) => tester.pumpWidget(
        MaterialApp(
          home: PantallaPedidos(repositorio: RepositorioPedidosFalso()),
        ),
      );

  testWidgets('cargando, error y reintento hasta la lista', (tester) async {
    await abrir(tester);

    // 1. Cargando
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // 2. Error (la primera llamada falla), sin texto de la excepción
    await tester.pump(const Duration(seconds: 2));
    expect(find.textContaining('No pudimos cargar'), findsOneWidget);
    expect(find.textContaining('Exception'), findsNothing);
    expect(find.text('Reintentar'), findsOneWidget);

    // 3. Reintentar vuelve a Cargando y luego muestra la lista
    await tester.tap(find.text('Reintentar'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Pedido #101'), findsOneWidget);
    expect(find.text('\$57.00'), findsOneWidget);
    expect(find.byType(Card), findsWidgets);
  });

  testWidgets('cerrar la pantalla mientras carga no lanza excepción',
      (tester) async {
    await abrir(tester);
    await tester.pumpWidget(const SizedBox()); // se desmonta durante el await
    await tester.pump(const Duration(seconds: 2)); // mounted evita setState
    expect(tester.takeException(), isNull);
  });
}
