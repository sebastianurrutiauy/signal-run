# Diseño de juego — Signal Run

## Fantasía

Eres una exploradora recuperando señales perdidas mientras rastreadores autónomos cierran el perímetro.

## Bucle central

Moverse → leer las rutas de los enemigos → tomar una señal → aumentar la presión → conseguir todas las señales o perder.

## Alcance del vertical slice

Una pantalla, movimiento, tres enemigos, cinco objetivos, victoria, derrota y reinicio. Todo lo demás es posterior al slice jugable.

## Decisiones pendientes

- Los enemigos persiguen al jugador. Velocidad inicial: 92 px/s; incremento
  por señal: 18 px/s; límite: 164 px/s. Valores ajustables en LevelConfig.
- ¿Cuánto debe durar una partida objetivo? (Recomendación: 60–120 segundos.)
- ¿Qué acción distintiva tendrá el jugador: dash, sigilo, señuelo o disparo?

## Reglas de partida

Inicio → jugando ↔ pausa → victoria/derrota → nuevo intento.
El contacto enemigo tiene prioridad si coincide con recoger la última señal.
La pausa congela el tiempo y la simulación; perder el foco activa pausa.
El informe registra duración y victorias/intentos durante la sesión. La curva
inicial requiere pruebas con jugadores para validar duración y dificultad.
