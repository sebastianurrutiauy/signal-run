# Signal Run — starter para Godot 4

Prototipo 2D top-down listo para iterar entre desarrollo y QA. El objetivo es recolectar cinco señales sin tocar a los rastreadores.

## Ejecutarlo

1. Usen **Godot 4.7.2**, la versión verificada por el equipo.
2. Clonen este repositorio y ábranlo desde el Project Manager de Godot.
3. Presionen `F6` o `F5` para ejecutar.

Controles: `WASD` o flechas para moverse; `R` para reiniciar tras ganar o perder.

## Estructura actual

- `scenes/main.tscn`: escena principal, con un nodo `Node2D` y su script.
- `scripts/main.gd`: estado de la partida, movimiento, colisiones y dibujo.
  `_physics_process` actualiza la simulación a intervalos fijos; `_draw` dibuja
  posiciones interpoladas entre esos pasos para suavizar el movimiento.
- `project.godot`: escena de inicio, controles, ventana y renderizador Compatibility.
- `docs/test-plan.md`: comprobaciones de regresión para Dev y QA.

Antes de editar externamente, guarden los cambios en Godot. Al volver al editor,
recarguen desde disco los archivos modificados. Versionen los `.uid` y los archivos
`.import` junto a sus assets; `.godot/` contiene caché local y queda fuera de Git.

La configuración actual habilita la integración local `addons/godot_ai`, cuya
carpeta está ignorada en Git. Una copia nueva sin ese addon debe quitar
`_mcp_game_helper` de **Proyecto > Ajustes del proyecto > Globales > Autoload** y
desactivar la entrada del plugin en **Plugins**. El juego no depende de esa
integración; no hace falta instalarla para jugar.

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
