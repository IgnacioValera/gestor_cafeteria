import 'package:flutter/material.dart';

import 'features/orders/data/repositorio_pedidos_falso.dart';
import 'features/orders/ui/pantalla_pedidos.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestor de cafetería',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
      ),
      home: PantallaPedidos(repositorio: RepositorioPedidosFalso()),
    );
  }
}
