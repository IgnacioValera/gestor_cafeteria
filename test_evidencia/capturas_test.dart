// Genera las capturas de evidencia de los tres estados en docs/evidencia/.
//
//   flutter test test_evidencia/capturas_test.dart --update-goldens
//
// Carga Roboto y Material Icons del SDK de Flutter para que el texto se vea
// real (en las pruebas normales se dibuja como cajas).
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_cafeteria/main.dart';

Directory _fuentesDelSdk() {
  var dir = File(Platform.resolvedExecutable).parent;
  while (true) {
    final candidato = Directory('${dir.path}/artifacts/material_fonts');
    if (candidato.existsSync()) return candidato;
    if (dir.parent.path == dir.path) {
      throw StateError('No encontré material_fonts en el SDK de Flutter');
    }
    dir = dir.parent;
  }
}

Future<void> _cargarFuente(String familia, List<String> archivos) async {
  final fuentes = _fuentesDelSdk();
  final loader = FontLoader(familia);
  for (final a in archivos) {
    final bytes = File('${fuentes.path}/$a').readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}

void main() {
  setUpAll(() async {
    await _cargarFuente('Roboto', ['roboto-regular.ttf', 'roboto-medium.ttf']);
    await _cargarFuente('MaterialIcons', ['materialicons-regular.otf']);
  });

  testWidgets('capturas de los tres estados', (tester) async {
    tester.view.physicalSize = const Size(1080, 2280);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    // En pruebas las sombras se dibujan como borde negro; se activan las reales.
    debugDisableShadows = false;

    await tester.pumpWidget(const MainApp());
    await tester.pump(const Duration(milliseconds: 300));
    await expectLater(find.byType(MainApp),
        matchesGoldenFile('../docs/evidencia/1-cargando.png'));

    await tester.pump(const Duration(seconds: 2));
    await expectLater(find.byType(MainApp),
        matchesGoldenFile('../docs/evidencia/2-error.png'));

    await tester.tap(find.text('Reintentar'));
    await tester.pump(const Duration(milliseconds: 300));
    await expectLater(find.byType(MainApp),
        matchesGoldenFile('../docs/evidencia/3-reintentando.png'));

    await tester.pump(const Duration(seconds: 2));
    await expectLater(find.byType(MainApp),
        matchesGoldenFile('../docs/evidencia/4-lista.png'));

    // Se restaura antes de que el framework revise sus invariantes.
    debugDisableShadows = true;
  });
}
