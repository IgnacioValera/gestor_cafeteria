# Declaración de uso de IA · T3 Lista con tres estados

| Herramienta | Prompt | Para qué se usó |
|---|---|---|
| Claude (Claude Code) | Le pasé el .docx de la tarea y le pedí resolverla en el repositorio `gestor_cafeteria`, en la rama `feat/lista-tres-estados` | Generó `Resultado`, la entidad `Pedido`, el repositorio falso, la pantalla con tres estados, las pruebas de widget y las capturas de `docs/evidencia/`. Los commits llevan la línea `Co-Authored-By: Claude`. |

## Cómo se verificó

- `flutter analyze`: sin problemas.
- `flutter test`: pasan las pruebas de la pantalla (cargando → error → reintentar → lista, y cerrar la pantalla durante la carga sin excepción gracias a `mounted`).
- Capturas: `flutter test test_evidencia/capturas_test.dart --update-goldens` genera `docs/evidencia/1-cargando.png`, `2-error.png`, `3-reintentando.png` y `4-lista.png`.
