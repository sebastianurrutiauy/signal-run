# Godot Master: flujo diario

Instalación compartida en `.agents/skills/godot-master/`, por copia para Codex.
No necesita Godot Tools, un addon ni MCP. El proyecto contiene `project.godot`,
`scenes/main.tscn` y `scripts/main.gd`; mantenemos esa estructura mientras sirva.
Motor comprobado: **4.7.2**. El README aún menciona un mínimo de 4.3: no tomarlo
como prueba de compatibilidad de los ejemplos de esta biblioteca, dirigida a 4.7+.

## Invocación y prueba de activación

Abrí este repositorio en VSCode y una conversación nueva de Codex. Escribí `$` y
buscá `godot-master` en el selector de skills, si tu cliente lo muestra. Enviá:

```text
$godot-master No edites ni ejecutes archivos. Confirmá si la skill fue descubierta
por Codex o si solo podés abrirla por ruta. Leé su SKILL.md, indicá la ruta exacta
y resumí cómo aplicás las reglas de AGENTS.md a este proyecto hobby. No leas
referencias adicionales para esta comprobación.
```

El selector o catálogo de skills prueba descubrimiento; ver una lectura del archivo
`.agents/skills/godot-master/SKILL.md` en la actividad de herramientas prueba lectura
efectiva. Una respuesta que solo diga «activada» no alcanza. Abrir el archivo por
ruta demuestra acceso manual, no descubrimiento automático.

Codex documenta detección automática de cambios. Si no aparece, reiniciá Codex;
en VSCode podés usar **Developer: Reload Window** y abrir otra conversación.
La sesión de instalación verificó lectura manual y registro en el CLI; queda
pendiente comprobar el descubrimiento automático en tu próxima conversación.

Desde la raíz, para comprobar el registro local (requiere Node/npm):

```powershell
npx.cmd --yes skills@1.5.18 list --agent codex --json
```

Debe aparecer solo `godot-master`, `scope: project` y agente `Codex`.

## Rutina Dev / QA

1. Guardar scripts, escenas y recursos en Godot antes de sincronizar o editar
   externamente. Revisar `git status`; preservar cambios locales. Con la rama
   preparada, sincronizar con `git fetch` y `git pull --ff-only` si tiene upstream.
   Si diverge o hay conflictos, resolverlos sin descartar trabajo.
2. Definir una tarea pequeña con comportamiento esperado y criterios observables.
   No deducir el género futuro del nombre ni del prototipo.
3. Pedir a Codex una implementación mínima. Leer el `SKILL.md` y elegir inicialmente
   cero, una o dos referencias relevantes; ampliar solo si hay una duda concreta,
   explicando el motivo. Informar cuáles se leyeron. No ejecutar helpers por defecto.
4. Recargar los archivos modificados desde disco en Godot, sin sobrescribirlos con
   buffers viejos. Ejecutar F5; usar F6 cuando la escena sea ejecutable por sí sola.
   Revisar errores y probar criterios de aceptación. Para rendimiento, medir con
   el profiler antes de proponer cambios estructurales.
5. Revisar `git diff` y `git diff --check`. QA reproduce los casos relevantes de
   `docs/test-plan.md` y los de la tarea. Separar resultados observados de pendientes.
   El commit/PR lo decide el equipo; esta instalación no creó ninguno.

## Prompts listos

**Orientación sin edición**

```text
$godot-master Solo orientación: no edites archivos ni ejecutes scripts. Queremos
[objetivo]. Explicá el concepto de Godot, proponé la opción más simple y sus límites.
Seguí AGENTS.md e indicá las referencias consultadas. No presupongas un género.
```

**Implementación**

```text
$godot-master Ya guardé los archivos en Godot. Implementá [funcionalidad pequeña].
Criterios de aceptación: [lista]. Preservá cambios existentes, seguí AGENTS.md y
evitá abstracciones sin necesidad actual. Indicá referencias leídas, verificaciones
ejecutadas y pasos manuales pendientes para QA.
```

**Diagnóstico**

```text
$godot-master Diagnosticá [error y mensaje completo]. Pasos: [reproducción].
Esperado: [resultado]. Observado: [resultado]. Primero reuní evidencia y distinguí
hechos de hipótesis. Consultá solo referencias pertinentes y documentación oficial
de nuestra versión. No cambies código hasta identificar una causa sustentada.
```

**Revisión QA**

```text
$godot-master Actuá como QA. Revisá el diff de [rama/commit o cambios locales] sin
editar archivos ni ejecutar helpers de terceros. Criterios: [lista]. Informá bugs
con archivo, impacto y reproducción; separá defectos de preferencias de estilo.
No exijas patrones por dogma. Listá las pruebas realizadas y las pendientes.
```

## Compartir y actualizar

Ambos deben versionar y obtener mediante Git **toda** `.agents/skills/godot-master/`,
`skills-lock.json`, `AGENTS.md`, esta guía, el registro de procedencia y la licencia
en `docs/third-party/`. No hace falta reinstalar al clonar: son archivos normales,
sin enlaces simbólicos ni rutas de la máquina del otro desarrollador. No agregar
la caché `.godot/`. No instalar micro-skills adicionales solapadas por defecto.

Para actualizar deliberadamente, partir de un estado guardado y revisable en una
rama. Inspeccionar primero cambios de origen, licencia y compatibilidad; comprobar
la ayuda del CLI si cambia su versión. Repetir la instalación dirigida fuerza el
mismo alcance y método de copia:

```powershell
npx.cmd --yes skills@1.5.18 add thedivergentai/gd-agentic-skills --agent codex --skill godot-master --copy --yes
npx.cmd --yes skills@1.5.18 list --agent codex --json
git diff -- .agents/skills/godot-master skills-lock.json docs/third-party
git diff --check
```

No usar `--all`, `--global` ni actualizaciones indiscriminadas. Revisar también
archivos nuevos con `git status`. Conservar el lock generado, actualizar licencia
y procedencia desde la revisión comprobada, y verificar enlaces locales y cambios
en scripts sin ejecutarlos. El hash del lock no es un SHA de commit; registrar el
commit por separado y comprobar que los archivos corresponden a él. No editar la
biblioteca para adaptar sus dogmas: mantener los acuerdos locales en `AGENTS.md`.

Fuentes verificadas el 2026-09-08:
[biblioteca](https://github.com/thedivergentai/gd-agentic-skills),
[CLI skills](https://github.com/vercel-labs/skills),
[skills de Codex](https://learn.chatgpt.com/docs/build-skills).
