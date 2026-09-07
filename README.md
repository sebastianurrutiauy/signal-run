# Signal Run — starter para Godot 4

Prototipo 2D top-down listo para iterar entre desarrollo y QA. El objetivo es recolectar cinco señales sin tocar a los rastreadores.

## Ejecutarlo

1. Instalen **Godot 4.3 o posterior**.
2. Clonen este repositorio y ábranlo desde el Project Manager de Godot.
3. Presionen `F6` o `F5` para ejecutar.

Controles: `WASD` o flechas para moverse; `R` para reiniciar tras ganar o perder.

## Primer sprint

El objetivo del primer sprint es que el juego sea probado de punta a punta, no agregar muchas funciones.

- [ ] Movimiento y colisiones manuales (incluido)
- [ ] Cinco objetivos y estados de victoria/derrota (incluido)
- [ ] Pantalla de inicio
- [ ] Sonido y pausa
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
