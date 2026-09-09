# Plan de pruebas — primer sprint

## Smoke test antes de cada pull request

1. El proyecto abre sin errores en Godot 4.
2. Una partida nueva permite mover al personaje con WASD y flechas.
3. El personaje no sale del área de juego.
4. Tomar las cinco señales muestra la victoria.
5. Tocar un rastreador muestra la derrota.
6. `R` reinicia correctamente después de ambos estados.

## Ciclo de partida y dificultad

- Antes de empezar, jugador, enemigos y reloj permanecen detenidos.
- Enter/espacio inicia; Esc pausa; Esc/Enter continúa sin saltos de posición.
- Cambiar a otra ventana pausa la partida.
- Cada recogida suena una vez y aumenta la velocidad enemiga hasta el límite.
- Si coinciden contacto enemigo y última señal, se pierde sin recogerla.
- El informe muestra señales, tiempo y victorias/intentos de la sesión.
- Reiniciar restaura posiciones, señales, reloj y velocidad inicial.
- Comprobar inicio, pausa, victoria y derrota a 960×540 y con ventana redimensionada.

Ejecutar `godot --headless --path . --script res://tests/run_smoke.gd`
para las 17 comprobaciones de reglas. La revisión manual anterior cubre además
entrada real, audio y apariencia, que esta prueba de estado no verifica.

## Cómo informar un bug

Incluye build/commit, pasos exactos, resultado esperado, resultado observado, frecuencia y una captura o video cuando sea posible. Un bug no está “listo para arreglar” sin pasos para reproducirlo.

## Severidad

- **P0:** impide jugar o daña datos.
- **P1:** bloquea una función clave o deja la partida en un estado imposible.
- **P2:** comportamiento incorrecto con alternativa disponible.
- **P3:** defecto visual, texto o mejora menor.
