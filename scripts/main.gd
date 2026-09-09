extends Node2D

const ARENA := Rect2(48, 92, 864, 388)
const PLAYER_RADIUS := 16.0
const ENEMY_RADIUS := 18.0
const PLAYER_SPEED := 280.0
const ENEMY_SPEED := 92.0
const GOAL_RADIUS := 13.0
const PICKUP_FEEDBACK_DURATION := 0.7
const INITIAL_ENEMIES: Array[Vector2] = [
	Vector2(170, 165), Vector2(750, 170), Vector2(210, 395),
]
const INITIAL_GOALS: Array[Vector2] = [
	Vector2(145, 280), Vector2(330, 150), Vector2(520, 390),
	Vector2(720, 285), Vector2(830, 420),
]

var player := ARENA.get_center()
# Copy the arrays so each scene instance owns its mutable match state.
var enemies: Array[Vector2] = INITIAL_ENEMIES.duplicate()
var goals: Array[Vector2] = INITIAL_GOALS.duplicate()
var collected := 0
var state := "playing"

var _previous_player := player
var _previous_enemies: Array[Vector2] = enemies.duplicate()
var _background: Node2D
var _pickup_feedback_left := 0.0
var _mission_hint := "Recuperá las cinco señales. Evitá los rastreadores."
var _hint_color := Color("a8b4a8")
var _counter_color := Color("28332c")

func _ready() -> void:
	# Godot retains these drawing commands until this canvas is invalidated.
	_background = Node2D.new()
	_background.show_behind_parent = true
	add_child(_background)
	_background.draw.connect(_draw_background)
	_background.queue_redraw()
	queue_redraw()

func _process(delta: float) -> void:
	if state == "playing":
		if _pickup_feedback_left > 0.0:
			_pickup_feedback_left = maxf(0.0, _pickup_feedback_left - delta)
			if _pickup_feedback_left == 0.0:
				_update_mission_feedback()
		queue_redraw()

func _physics_process(delta: float) -> void:
	if state != "playing":
		if Input.is_action_just_pressed("restart"):
			restart()
		return

	_previous_player = player
	_previous_enemies.assign(enemies)
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
		if goals[index].distance_to(player) <= PLAYER_RADIUS + GOAL_RADIUS:
			goals.remove_at(index)
			collected += 1
			_pickup_feedback_left = PICKUP_FEEDBACK_DURATION
			_update_mission_feedback()
			if collected == INITIAL_GOALS.size():
				state = "won"
	queue_redraw()

func restart() -> void:
	player = ARENA.get_center()
	enemies = INITIAL_ENEMIES.duplicate()
	goals = INITIAL_GOALS.duplicate()
	collected = 0
	state = "playing"
	_pickup_feedback_left = 0.0
	_update_mission_feedback()
	_previous_player = player
	_previous_enemies.assign(enemies)
	queue_redraw()

func _update_mission_feedback() -> void:
	# Cache display values when feedback changes, rather than on every draw.
	var active := _pickup_feedback_left > 0.0
	_mission_hint = "Recuperá las cinco señales. Evitá los rastreadores."
	if active:
		_mission_hint = "Señal recuperada. ¡Seguí moviéndote!"
	elif goals.size() == 1:
		_mission_hint = "¡Una señal más! Buscá el último transmisor."
	_hint_color = Color("ffe3a0") if active else Color("a8b4a8")
	_counter_color = Color("655637") if active else Color("28332c")

func _draw_background() -> void:
	_background.draw_rect(Rect2(0, 0, 960, 540), Color("111819"))
	_background.draw_rect(Rect2(34, 80, 892, 416), Color("080d0e"))
	_background.draw_rect(Rect2(40, 84, 880, 404), Color("67706a"))
	var rng := RandomNumberGenerator.new()
	rng.seed = 4815
	# Weathered concrete slabs with fixed grain and recessed seams.
	for row in range(4):
		for column in range(9):
			var tile := Rect2(48 + column * 96, 92 + row * 97, 96, 97)
			var shade := rng.randf_range(0.20, 0.27)
			_background.draw_rect(tile, Color(shade, shade + 0.025, shade + 0.02))
			_background.draw_line(tile.position, tile.position + Vector2(96, 0), Color("60665d"))
			_background.draw_line(tile.position, tile.position + Vector2(0, 97), Color("222b29"), 2.0)
			_background.draw_line(tile.position + Vector2(0, 96), tile.end, Color("202825"), 2.0)
	for i in range(1800):
		var point := Vector2(rng.randf_range(50, 910), rng.randf_range(94, 478))
		var shade := rng.randf_range(0.1, 0.8)
		_background.draw_circle(point, rng.randf_range(0.4, 1.2), Color(shade, shade, shade, 0.15))
	for i in range(24):
		var point := Vector2(rng.randf_range(85, 875), rng.randf_range(120, 450))
		_background.draw_set_transform(point, 0, Vector2(1, 0.4))
		_background.draw_circle(Vector2.ZERO, rng.randf_range(10, 34), Color(0.03, 0.04, 0.03, 0.13))
		_background.draw_set_transform(Vector2.ZERO)
	for x in range(78, 888, 36):
		_background.draw_line(Vector2(x, 107), Vector2(x + 16, 107), Color("9a9170"), 2)
		_background.draw_line(Vector2(x, 465), Vector2(x + 16, 465), Color("9a9170"), 2)
	_background.draw_rect(Rect2(57, 121, 10, 328), Color("171f1d"))
	for y in range(124, 449, 7):
		_background.draw_line(Vector2(58, y), Vector2(65, y), Color("5c665f"), 2)
	for i in range(14):
		var alpha := 0.15 * (1.0 - float(i) / 14)
		_background.draw_line(Vector2(48 + i, 92), Vector2(48 + i, 480), Color(0, 0, 0, alpha))
		_background.draw_line(Vector2(48, 92 + i), Vector2(912, 92 + i), Color(0, 0, 0, alpha))
		_background.draw_line(Vector2(912 - i, 92), Vector2(912 - i, 480), Color(0, 0, 0, alpha))
	for x in [240, 672]:
		_glow(Vector2(x, 100), 85, Color(0.76, 0.83, 0.62, 0.018), _background)
		_background.draw_rect(Rect2(x - 30, 85, 60, 9), Color("18201e"))
		_background.draw_rect(Rect2(x - 26, 87, 52, 3), Color("e1e5c6"))
	_background.draw_string(ThemeDB.fallback_font, Vector2(369, 289), "RESTRICTED AREA", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color(0.76, 0.75, 0.57, 0.19))
	_background.draw_string(ThemeDB.fallback_font, Vector2(421, 314), "S E C T O R   0 7", HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color(0.76, 0.75, 0.57, 0.22))

func _draw() -> void:
	# Smooth visuals between fixed physics ticks; collisions use real positions.
	var blend := Engine.get_physics_interpolation_fraction() if state == "playing" else 1.0
	var render_player := _previous_player.lerp(player, blend)
	var pulse := 0.8 + sin(Time.get_ticks_msec() * 0.004) * 0.2
	var last_signal := goals.size() == 1
	for goal in goals:
		_shadow(goal, 15)
		_glow(goal, 28, Color(0.96, 0.70, 0.24, (0.05 if last_signal else 0.025) * pulse))
		draw_rect(Rect2(goal + Vector2(-11, -12), Vector2(22, 26)), Color("111916"))
		draw_rect(Rect2(goal + Vector2(-10, -13), Vector2(20, 23)), Color("8b8873"))
		draw_rect(Rect2(goal + Vector2(-8, -11), Vector2(16, 19)), Color("35423c"))
		draw_rect(Rect2(goal + Vector2(-6, -8), Vector2(12, 7)), Color("d4b568"))
		draw_line(goal + Vector2(-4, -4), goal + Vector2(3, -4), Color("fff1be"))
		for offset in [-4, 0, 4]:
			draw_line(goal + Vector2(offset, 3), goal + Vector2(offset, 6), Color("a1aa96"))
		draw_line(goal + Vector2(7, -11), goal + Vector2(7, -21), Color("a8b3ac"), 2)
		draw_circle(goal + Vector2(7, -21), 2, Color("ffe3a0"))
	for index in enemies.size():
		var enemy := _previous_enemies[index].lerp(enemies[index], blend)
		_shadow(enemy, 22)
		draw_set_transform(enemy, (render_player - enemy).angle() + PI / 2)
		for side in [-1, 1]:
			draw_rect(Rect2(side * 14 - 4, -12, 8, 26), Color("101816"))
			for y in range(-10, 14, 5):
				draw_line(Vector2(side * 14 - 3, y), Vector2(side * 14 + 3, y), Color("697266"), 2)
		draw_circle(Vector2(0, 2), 15, Color("17201b"))
		draw_circle(Vector2.ZERO, 14, Color("8a907e"))
		draw_circle(Vector2(1, 2), 11, Color("525e51"))
		draw_arc(Vector2.ZERO, 13, PI, TAU, 18, Color("c1c5aa"), 1.5, true)
		draw_rect(Rect2(-10, -7, 20, 6), Color("18211d"))
		draw_line(Vector2(-6, -4), Vector2(6, -4), Color("f18257"), 2)
		draw_rect(Rect2(-5, 5, 10, 4), Color("2b362c"))
		draw_set_transform(Vector2.ZERO)
	# Operative seen from above: boots, fabric, vest, helmet and visor.
	_shadow(render_player, 18)
	for side in [-1, 1]:
		draw_line(render_player + Vector2(side * 6, 4), render_player + Vector2(side * 7, 14), Color("161d22"), 7, true)
		draw_circle(render_player + Vector2(side * 12, 0), 6, Color("443e53"))
		draw_circle(render_player + Vector2(side * 12 - 1, -2), 4, Color("8b789c"))
	draw_rect(Rect2(render_player + Vector2(-9, -5), Vector2(18, 18)), Color("292e36"))
	draw_rect(Rect2(render_player + Vector2(-7, -5), Vector2(14, 13)), Color("6f5f81"))
	draw_line(render_player + Vector2(-5, -3), render_player + Vector2(-5, 8), Color("b0a5ac"), 2)
	draw_line(render_player + Vector2(5, -3), render_player + Vector2(5, 8), Color("342f3e"), 2)
	draw_circle(render_player + Vector2(0, -6), 9, Color("242b2d"))
	draw_circle(render_player + Vector2(0, -8), 8, Color("9d8aa8"))
	draw_circle(render_player + Vector2(-2, -10), 5, Color("c1afc6"))
	draw_line(render_player + Vector2(-5, -13), render_player + Vector2(5, -13), Color("293f42"), 3, true)
	draw_line(render_player + Vector2(-3, -14), render_player + Vector2(3, -14), Color("94c0bd"), 1, true)
	# Mission display is kept separate from the world lighting.
	draw_rect(Rect2(0, 0, 960, 72), Color("151e1d"))
	draw_line(Vector2(32, 71), Vector2(928, 71), Color("465249"))
	draw_rect(Rect2(32, 23, 3, 28), Color("c5b784"))
	draw_string(ThemeDB.fallback_font, Vector2(48, 43), "SIGNAL RUN", HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color("e2e4dc"))
	draw_string(ThemeDB.fallback_font, Vector2(260, 32), "OPERACIÓN / SECTOR 07", HORIZONTAL_ALIGNMENT_LEFT, -1, 11, Color("b6aa84"))
	draw_string(ThemeDB.fallback_font, Vector2(260, 51), _mission_hint, HORIZONTAL_ALIGNMENT_LEFT, -1, 13, _hint_color)
	draw_rect(Rect2(754, 17, 174, 40), _counter_color)
	draw_string(ThemeDB.fallback_font, Vector2(770, 44), "%02d / %02d" % [collected, INITIAL_GOALS.size()], HORIZONTAL_ALIGNMENT_LEFT, -1, 21, Color("e0d4ac"))
	draw_string(ThemeDB.fallback_font, Vector2(852, 41), "SEÑALES", HORIZONTAL_ALIGNMENT_LEFT, -1, 11, Color("afbaab"))
	draw_string(ThemeDB.fallback_font, Vector2(48, 520), "WASD / FLECHAS   Mover", HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color("a5b0aa"))
	draw_string(ThemeDB.fallback_font, Vector2(701, 520), "R   Reiniciar al terminar", HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color("a5b0aa"))
	if state != "playing":
		draw_rect(Rect2(0, 0, 960, 540), Color(0.025, 0.04, 0.03, 0.75))
		draw_rect(Rect2(224, 181, 512, 180), Color("202b25"))
		draw_rect(Rect2(224, 181, 512, 180), Color("697567"), false, 1)
		var accent := Color("c9d5aa") if state == "won" else Color("df9274")
		draw_rect(Rect2(224, 181, 4, 180), accent)
		draw_string(ThemeDB.fallback_font, Vector2(256, 216), "INFORME DE OPERACIÓN", HORIZONTAL_ALIGNMENT_LEFT, -1, 11, Color("a2aba3"))
		draw_string(ThemeDB.fallback_font, Vector2(256, 260), "SEÑAL ASEGURADA" if state == "won" else "TE DETECTARON", HORIZONTAL_ALIGNMENT_LEFT, -1, 28, accent)
		draw_string(ThemeDB.fallback_font, Vector2(256, 298), "Señales recuperadas: %d / %d" % [collected, INITIAL_GOALS.size()], HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color("c1c9bf"))
		draw_string(ThemeDB.fallback_font, Vector2(256, 333), "Pulsá R para volver a intentarlo", HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("a2aba3"))

func _shadow(center: Vector2, radius: float) -> void:
	draw_set_transform(center + Vector2(5, 8), 0, Vector2(1, 0.65))
	for layer in range(4, 0, -1):
		draw_circle(Vector2.ZERO, radius + layer * 2, Color(0.015, 0.025, 0.02, 0.10))
	draw_set_transform(Vector2.ZERO)

func _glow(center: Vector2, radius: float, color: Color, canvas: CanvasItem = self) -> void:
	for layer in range(8, 0, -1):
		canvas.draw_circle(center, radius * float(layer) / 8, color)
