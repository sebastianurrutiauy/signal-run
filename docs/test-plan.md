# Plan de pruebas — primer sprint

## Smoke test antes de cada pull request

1. El proyecto abre sin errores en Godot 4.
2. Una partida nueva permite mover al personaje con WASD y flechas.
3. El personaje no sale del área de juego.
4. Tomar las cinco señales muestra la victoria.
5. Tocar un rastreador muestra la derrota.
6. `R` reinicia correctamente después de ambos estados.

## Cómo informar un bug

Incluye build/commit, pasos exactos, resultado esperado, resultado observado, frecuencia y una captura o video cuando sea posible. Un bug no está “listo para arreglar” sin pasos para reproducirlo.

## Severidad

- **P0:** impide jugar o daña datos.
- **P1:** bloquea una función clave o deja la partida en un estado imposible.
- **P2:** comportamiento incorrecto con alternativa disponible.
- **P3:** defecto visual, texto o mejora menor.
