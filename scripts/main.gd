extends Node2D

const ARENA := Rect2(48, 92, 864, 388)
const PLAYER_RADIUS := 16.0
const ENEMY_RADIUS := 18.0
const PLAYER_SPEED := 280.0
const ENEMY_SPEED := 92.0
const GOAL_COUNT := 5

var player := Vector2(ARENA.get_center())
var enemies: Array[Vector2] = [Vector2(170, 165), Vector2(750, 170), Vector2(210, 395)]
var goals: Array[Vector2] = [Vector2(145, 280), Vector2(330, 150), Vector2(520, 390), Vector2(720, 285), Vector2(830, 420)]
var collected := 0
var state := "playing"

func _ready() -> void:
	queue_redraw()

func _physics_process(delta: float) -> void:
	if state != "playing":
		if Input.is_action_just_pressed("restart"):
			restart()
		return

	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	player += direction * PLAYER_SPEED * delta
	player.x = clampf(player.x, ARENA.position.x + PLAYER_RADIUS, ARENA.end.x - PLAYER_RADIUS)
	player.y = clampf(player.y, ARENA.position.y + PLAYER_RADIUS, ARENA.end.y - PLAYER_RADIUS)

	for index in enemies.size():
		enemies[index] = enemies[index].move_toward(player, ENEMY_SPEED * delta)
		if enemies[index].distance_to(player) <= PLAYER_RADIUS + ENEMY_RADIUS:
			state = "lost"
			queue_redraw()
			return

	for index in range(goals.size() - 1, -1, -1):
		if goals[index].distance_to(player) <= PLAYER_RADIUS + 13.0:
			goals.remove_at(index)
			collected += 1
			if collected == GOAL_COUNT:
				state = "won"
	queue_redraw()

func restart() -> void:
	player = ARENA.get_center()
	enemies = [Vector2(170, 165), Vector2(750, 170), Vector2(210, 395)]
	goals = [Vector2(145, 280), Vector2(330, 150), Vector2(520, 390), Vector2(720, 285), Vector2(830, 420)]
	collected = 0
	state = "playing"
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(960, 540)), Color("101827"))
	draw_string(ThemeDB.fallback_font, Vector2(48, 42), "SIGNAL RUN", HORIZONTAL_ALIGNMENT_LEFT, -1, 28, Color("f8fafc"))
	draw_string(ThemeDB.fallback_font, Vector2(48, 68), "Recolecta las 5 señales. Evita a los rastreadores.", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("a8b5ca"))
	draw_string(ThemeDB.fallback_font, Vector2(760, 58), "%d / %d" % [collected, GOAL_COUNT], HORIZONTAL_ALIGNMENT_RIGHT, 150, 22, Color("72e5c5"))
	draw_string(ThemeDB.fallback_font, Vector2(48, 515), "Mover: WASD / flechas · Reiniciar al terminar: R", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("a8b5ca"))
	draw_rect(ARENA, Color("17243a"), true)
	draw_rect(ARENA, Color("3e5a7e"), false, 2.0)

	for goal in goals:
		draw_circle(goal, 13.0, Color("f9d65c"))
		draw_circle(goal, 6.0, Color("fff6bd"))
	for enemy in enemies:
		draw_circle(enemy, ENEMY_RADIUS, Color("f26478"))
		draw_circle(enemy + Vector2(-5, -3), 3.0, Color("2a1020"))
		draw_circle(enemy + Vector2(5, -3), 3.0, Color("2a1020"))
	draw_circle(player, PLAYER_RADIUS, Color("64b5f6"))
	draw_circle(player, 7.0, Color("e3f2fd"))

	if state != "playing":
		draw_rect(Rect2(Vector2(190, 190), Vector2(580, 160)), Color(0.04, 0.08, 0.14, 0.94), true)
		draw_rect(Rect2(Vector2(190, 190), Vector2(580, 160)), Color("77a6d9"), false, 2.0)
		var title := "¡SEÑAL ASEGURADA!" if state == "won" else "TE DETECTARON"
		var color := Color("72e5c5") if state == "won" else Color("ff9bad")
		draw_string(ThemeDB.fallback_font, Vector2(230, 250), title, HORIZONTAL_ALIGNMENT_CENTER, 500, 28, color)
		draw_string(ThemeDB.fallback_font, Vector2(230, 295), "Pulsa R para volver a intentarlo", HORIZONTAL_ALIGNMENT_CENTER, 500, 18, Color("d4ddeb"))
