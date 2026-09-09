extends RefCounted

signal collected_signal(count: int)
signal state_changed(state: StringName)

const LevelConfig = preload("res://features/run/level_config.gd")
var config: LevelConfig
var player: Vector2
var previous_player: Vector2
var enemies: Array[Vector2] = []
var previous_enemies: Array[Vector2] = []
var goals: Array[Vector2] = []
var collected := 0
var elapsed := 0.0
var attempts := 0
var wins := 0
var state: StringName = &"ready"

func _init(level: LevelConfig = null) -> void:
	config = level if level != null else LevelConfig.new()
	_reset()

func _reset() -> void:
	player = config.arena.get_center()
	previous_player = player
	enemies.assign(config.enemy_spawns)
	previous_enemies.assign(enemies)
	goals.assign(config.goal_spawns)
	collected = 0
	elapsed = 0.0

func start() -> void:
	_reset()
	attempts += 1
	_set_state(&"playing")
	if goals.is_empty():
		_finish(&"won")

func toggle_pause() -> void:
	if state == &"playing":
		_set_state(&"paused")
	elif state == &"paused":
		previous_player = player
		previous_enemies.assign(enemies)
		_set_state(&"playing")

func enemy_speed() -> float:
	return minf(config.enemy_base_speed + collected * config.enemy_speed_per_signal, config.enemy_max_speed)

func step(direction: Vector2, delta: float) -> void:
	if state != &"playing":
		return
	elapsed += delta
	previous_player = player
	previous_enemies.assign(enemies)
	player += direction.limit_length() * config.player_speed * delta
	player = player.clamp(config.arena.position + Vector2.ONE * config.player_radius, config.arena.end - Vector2.ONE * config.player_radius)
	var hit := false
	for index in enemies.size():
		enemies[index] = enemies[index].move_toward(player, enemy_speed() * delta)
		hit = hit or enemies[index].distance_to(player) <= config.player_radius + config.enemy_radius
	# Contact takes precedence over collection, including the final signal.
	if hit:
		_finish(&"lost")
		return
	for index in range(goals.size() - 1, -1, -1):
		if goals[index].distance_to(player) <= config.player_radius + config.goal_radius:
			goals.remove_at(index)
			collected += 1
			collected_signal.emit(collected)
	if goals.is_empty():
		_finish(&"won")

func _finish(result: StringName) -> void:
	if result == &"won":
		wins += 1
	_set_state(result)

func _set_state(value: StringName) -> void:
	state = value
	state_changed.emit(state)
