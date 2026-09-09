# Procedencia y verificación de godot-master

Fecha: 2026-09-08. Instalación local de proyecto para Codex; archivos copiados,
sin symlinks. No es una certificación técnica de los ejemplos de la biblioteca.

## Origen

- Repositorio: https://github.com/thedivergentai/gd-agentic-skills
- Revisión inspeccionada: `6a36f189d9c9b53b8c6769fb5c2cce8bfa5ad35c` (rama `main`).
- Subdirectorio: `skills/godot-master`.
- Git tree de ese subdirectorio: `d91f4edf0a912160c8f6eae22ac7af84f4a15684`.
- CLI: `skills` **1.5.18**, ejecutado con `npx.cmd` en Windows.
- Destino: `.agents/skills/godot-master/`.
- Licencia de origen: GNU LGPL versión 3, copiada íntegra desde `LICENSE` a
  [gd-agentic-skills-LICENSE.txt](gd-agentic-skills-LICENSE.txt).
- SHA-256 de la copia de licencia:
  `7d3a95e5e06978064ed3f8e2b7c8f845e7fd8a405294727cc708f94cb83b8059`.

Comando ejecutado desde `C:\Users\Usuario\signal-run`:

```powershell
npx.cmd --yes skills@1.5.18 add thedivergentai/gd-agentic-skills --agent codex --skill godot-master --copy --yes
```

Se fijó la versión comprobada del CLI. La fuente del comando es mutable; para
atribuir el resultado a la revisión anterior se compararon individualmente los
SHA-256 de **todos los archivos instalados** con el checkout de esa revisión.
No hubo diferencias ni archivos faltantes o extra.

`skills-lock.json` se conserva tal como lo generó el CLI. Su `computedHash` es
`d980c69e01d272deb52f25ca0e3eaa317e240f288548db07c53763f9c6b12b35`;
no confundirlo con el commit ni con el SHA-256 del `SKILL.md` instalado:
`fbba47e728bddcd67e1f1a9bc742f8c0dca0bc9203a145becececcde17b32407`.

## Inspección del proyecto

- Raíz: `C:\Users\Usuario\signal-run`; rama: `Integracion-Godot-master`.
- Estado inicial: únicamente `project.godot` marcado `M`; diff textual vacío
  al inspeccionarlo. Se conservó byte por byte, sin normalizarlo.
- Estructura: `scripts/`, `scenes/`, `docs/`, `.github/`, `addons/` y caché `.godot/`.
  El addon `addons/godot_ai/` y su autoload ya existían; no se tocaron.
- `project.godot` declara 4.7. El ejecutable local
  `C:\Users\Usuario\Desktop\Godot_v4.7.2-stable_win64.exe --version` devolvió
  `4.7.2.stable.official.ed1daf0bf`. No se inició el editor ni el juego.
- No se encontraron `AGENTS.md` preexistentes en el proyecto ni en sus directorios
  padres revisados; se creó el de la raíz. Se revisó también la ubicación personal
  de instrucciones de Codex.
- Antes de instalar, el CLI listó `[]` tanto para el alcance de proyecto como para
  el global de Codex. La carpeta personal `.codex/skills` contenía `.system`;
  `.agents/skills` personal no existía. No se encontraron micro-skills de Godot
  solapadas en esas ubicaciones ni entre las skills expuestas en esta sesión.

## Comprobaciones

- `skills --help` confirmó `--agent`, `--skill`, `--copy`, `--yes` y alcance de
  proyecto por defecto. Se contrastó con el README actual del CLI y la ubicación
  de descubrimiento documentada por Codex.
- `npx.cmd --yes skills@1.5.18 list --agent codex --json` informó una sola skill:
  `godot-master`, `scope: project`, agente `Codex`, en el destino esperado.
- Se conservan **1.728 archivos** de origen: `SKILL.md`, **456** archivos en
  `references/` y **1.271** en `scripts/`. La licencia raíz se conserva aparte.
- Los **106 destinos únicos de enlaces Markdown locales del SKILL.md** existen.
  Un recorrido estático de enlaces Markdown de todos los `.md` instalados tampoco
  encontró destinos locales faltantes. No se validaron anclas, URLs externas ni
  dependencias de ejecución; no se interpretaron ejemplos de comandos como enlaces.
- Se leyó manualmente el `SKILL.md` instalado y se comprobó su igualdad con el
  inspeccionado. No se cargaron referencias temáticas completas para aplicar
  arquitectura ni gameplay. El escaneo de enlaces solo comprobó rutas.
- El CLI mostró «Socket: 1 alert», sin detalle, además de otras evaluaciones.
  Es una señal del servicio, no un resultado de una auditoría propia. No se ejecutó
  ningún script de la biblioteca ni se añadieron addons, MCP o dependencias suyas.
- La inspección detectó recomendaciones absolutas y afirmaciones que requieren
  contraste (por ejemplo, la confusión entre mutar Resources y guardar en disco).
  La copia de origen permanece intacta; `AGENTS.md` fija el criterio del equipo.

## Límites y archivos preservados

La lectura manual y el registro del CLI no prueban descubrimiento automático en
el cliente. Queda pendiente la prueba con `$godot-master` en una conversación nueva,
descrita en [la guía](../godot-master-workflow.md). No se realizaron pruebas de
gameplay ni validación de todos los ejemplos; esta tarea solo instala documentación
y material de consulta. No se hicieron commits, pushes ni cambios de configuración
global o del motor.

SHA-256 de los archivos del juego antes y después de la instalación:

| Archivo | SHA-256 |
| --- | --- |
| `project.godot` | `b3003147764e4105939d62210052732f06a10d1843a0f0aeff4522f8d254e96a` |
| `scripts/main.gd` | `b8cf970f4bf924286e91961fc45446fe8811f58a7cef220e57bb07ef4883e8fb` |
| `scenes/main.tscn` | `d96661e595ded0e539396b89a2776414da44610b672c12d04a11fbc84c997f44` |

Se descargó un checkout de inspección en `.godot/gd-skills-inspection/`, ignorado
por Git y fuera de las ubicaciones de skills. No constituye otra instalación.

Fuentes:
[biblioteca en la revisión comprobada](https://github.com/thedivergentai/gd-agentic-skills/tree/6a36f189d9c9b53b8c6769fb5c2cce8bfa5ad35c),
[CLI](https://github.com/vercel-labs/skills),
[descubrimiento en Codex](https://learn.chatgpt.com/docs/build-skills).
