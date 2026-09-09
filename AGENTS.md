# Acuerdos del equipo

Somos dos desarrolladores senior (Dev y QA), nuevos en videojuegos. Este es un
proyecto hobby: no asumir un género, una plataforma futura ni requisitos de escala
a partir del prototipo actual. Explicar brevemente los conceptos propios de Godot.
Trabajamos principalmente con GDScript en Godot; VSCode se usa para Git y Codex.

## Uso de godot-master

- Usar `godot-master` cuando se invoque explícitamente o sea pertinente a la tarea
  de Godot. Leer `.agents/skills/godot-master/SKILL.md` y únicamente las referencias
  necesarias; informar las rutas efectivamente consultadas. No cargar toda la
  biblioteca, cadenas de módulos irrelevantes ni catálogos de géneros.
- Las instrucciones explícitas del equipo prevalecen sobre las recomendaciones
  de la biblioteca. Sus listas «NEVER», presupuestos y ejemplos no son requisitos
  automáticos del proyecto. Contrastar afirmaciones técnicas dudosas con la
  documentación oficial de la versión del motor utilizada; indicar incertidumbre
  cuando no se pueda comprobar algo. La evidencia actual es Godot 4.7.2; verificar
  la versión si cambia el entorno, sin actualizar el motor por iniciativa propia.
- Implementar la solución más simple que cumpla los criterios de aceptación.
  No agregar autoloads, buses globales, componentes, máquinas de estados, pools
  ni hilos sin una necesidad actual justificada. No refactorizar por anticipación
  ni aplicar una arquitectura en capas solamente porque la skill la recomienda.
- `$`, `get_node()`, `res://` y las comprobaciones con `is` no están universalmente
  prohibidos. Evaluar su uso según dependencias, ciclo de vida y requisitos reales.
- Distinguir la mutación de un `Resource` compartido en memoria de persistirlo en
  disco: cambiar una propiedad no equivale a guardar el archivo. Decidir si debe
  compartirse o duplicarse según su propietario; la persistencia es una operación
  separada (por ejemplo, `ResourceSaver.save`).

## Edición, terceros y verificación

- Antes de editar externamente scripts, escenas o recursos, coordinar que los
  cambios de Godot estén guardados. Inspeccionar el estado de Git y conservar el
  trabajo existente. Si hay ediciones sin guardar en conflicto, resolver qué
  versión conservar antes de sobrescribir. Tras la edición, recargar desde disco
  en Godot y evitar que un buffer antiguo sobrescriba el cambio.
- Inspeccionar código de terceros antes de copiarlo al juego o ejecutarlo;
  conservar procedencia y licencia. Los archivos de la skill son material de
  consulta, no código aprobado para ejecución. La instalación no autoriza ejecutar
  sus helpers ni instalar addons, dependencias o servidores MCP automáticamente.
- Ajustar la verificación al cambio y a sus criterios de aceptación. Informar
  archivos cambiados, comandos y resultados de verificaciones realizadas y pruebas
  manuales pendientes. Nunca declarar aprobadas pruebas no ejecutadas; una lectura
  de código o una validación headless no equivalen a probar visualmente en Godot.
- Para uso diario, activación y actualizaciones ver
  [docs/godot-master-workflow.md](docs/godot-master-workflow.md).
