# Plan de pruebas — primer sprint

## Smoke test antes de cada pull request

1. El proyecto abre sin errores en Godot 4.7.2. Recargar desde disco cualquier
   script cambiado externamente antes de ejecutar.
2. Una partida nueva permite mover al personaje con WASD y flechas.
3. El personaje no sale del área de juego.
4. Tomar las cinco señales muestra la victoria.
5. Tocar un rastreador muestra la derrota.
6. `R` reinicia correctamente después de ambos estados.

## Regresión de la partida

Pruebas de lógica sin dependencias adicionales (desde la raíz; sustituir `godot`
por la ruta de Godot 4.7.2 si no está en PATH):

```powershell
godot --headless --path . --script res://tests/regression.gd
```

Resultado esperado: `REGRESSION: 20 checks, 0 failures` y código de salida 0.
El script comprueba posiciones iniciales, aislamiento entre instancias, velocidad,
límites, recolección, prioridad de colisión y reinicios. No simula una partida
completa con teclado: la comprobación de R y las teclas físicas sigue siendo manual.

- Ejecutar `scenes/main.tscn` con F6 y el proyecto con F5: ambos deben iniciar
  con tres rastreadores, cinco señales y el contador `00 / 05`.
- Probar WASD y flechas, incluidas diagonales; la velocidad diagonal no debe
  superar la horizontal. Recorrer los cuatro bordes sin salir del recinto.
- Recoger señales: cada una desaparece una sola vez y suma uno al contador.
- Al perder o ganar, verificar que el movimiento queda detenido y que el informe
  muestra el total correcto. En un contacto simultáneo con un enemigo y la última
  señal, la derrota tiene prioridad (comportamiento actual).
- Pulsar R después de cada resultado y repetir varias veces: deben restaurarse
  todas las posiciones, señales y contador, sin saltos de interpolación.
- Durante una partida, R no debe reiniciar. Revisar el panel Depurador para
  detectar errores y advertencias nuevos.

La validación headless comprueba lógica y carga de scripts; estos pasos en el
editor comprueban además controles reales, apariencia y sensación de movimiento.

Feedback: al recoger una señal, el mensaje y la placa del contador se destacan
durante 0,7 segundos. Al quedar una sola, aparece la indicación del último
transmisor y su brillo aumenta. Reiniciar limpia el feedback anterior.

## Cómo informar un bug

Incluye build/commit, pasos exactos, resultado esperado, resultado observado, frecuencia y una captura o video cuando sea posible. Un bug no está “listo para arreglar” sin pasos para reproducirlo.

## Severidad

- **P0:** impide jugar o daña datos.
- **P1:** bloquea una función clave o deja la partida en un estado imposible.
- **P2:** comportamiento incorrecto con alternativa disponible.
- **P3:** defecto visual, texto o mejora menor.
