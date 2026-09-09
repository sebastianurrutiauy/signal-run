# Signal Run — starter para Godot 4

Prototipo 2D top-down listo para iterar entre desarrollo y QA. El objetivo es recolectar cinco señales sin tocar a los rastreadores.

## Ejecutarlo

1. Instalen **Godot 4.7.2** (versión comprobada).
2. Clonen este repositorio y ábranlo desde el Project Manager de Godot.
3. Presionen `F6` o `F5` para ejecutar.

Controles: `Enter` o espacio para empezar; `WASD` o flechas para moverse;
`Esc` para pausar/continuar; `R` o `Enter` para reiniciar tras ganar o perder.
Al perder el foco, la partida se pausa automáticamente.

Cada señal acelera a los rastreadores (92 → 110 → 128 → 146 → 164 px/s).
El informe final muestra tiempo y victorias/intentos de esta sesión.
El contacto con un rastreador tiene prioridad sobre recoger una señal.

## Configuración y comprobaciones

- `features/run/level_config.gd`: posiciones, radios y curva de dificultad.
- `features/run/run_state.gd`: reglas y estado independientes del dibujo.
- `features/run/run_view.gd`: representación del mundo y mensajes.
- `scripts/main.gd`: entrada, audio y conexión de las partes. Permite asignar
  un recurso `level` desde el Inspector; sin él usa la configuración por defecto.

Validación reproducible, sin dependencias de pruebas externas:

```text
godot --headless --path . --script res://tests/run_smoke.gd
```

Devuelve un código distinto de cero si falla alguna comprobación.

## Primer sprint

El objetivo del primer sprint es que el juego sea probado de punta a punta, no agregar muchas funciones.

- [ ] Movimiento y colisiones manuales (incluido)
- [ ] Cinco objetivos y estados de victoria/derrota (incluido)
- [x] Pantalla de inicio
- [x] Sonido de recogida y pausa
- [ ] Exportar una build para que QA la pruebe

Las historias, la definición de “terminado” y los casos de prueba están en [docs](docs/).

## Flujo de GitHub

`main` debe permanecer jugable. Cada cambio va en una rama corta y entra mediante pull request:

```text
feature/player-animation
fix/restart-after-loss
docs/qa-smoke-checklist
```

El autor revisa que el juego arranque; la otra persona prueba el cambio usando la plantilla de PR y aprueba o deja hallazgos. No mezclen una característica nueva con arreglos no relacionados.
