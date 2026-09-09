extends SceneTree

const RunState = preload("res://features/run/run_state.gd")
const LevelConfig = preload("res://features/run/level_config.gd")
var failures := 0
var checks := 0

func check(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error(message)

func _initialize() -> void:
	var game := RunState.new()
	game.step(Vector2.ONE, 1.0)
	check(game.state == &"ready" and game.elapsed == 0.0, "Start screen freezes simulation")
	game.start()
	game.enemies.clear()
	game.step(Vector2(100, 100), 0.1)
	check(is_equal_approx(game.player.distance_to(game.config.arena.get_center()), 28.0), "Diagonal speed is normalized")
	game.step(Vector2(-1, -1), 10.0)
	check(game.player == game.config.arena.position + Vector2.ONE * 16.0, "Top and left limits")
	game.step(Vector2.ONE, 10.0)
	check(game.player == game.config.arena.end - Vector2.ONE * 16.0, "Bottom and right limits")
	game.toggle_pause()
	var paused_player := game.player
	var paused_time := game.elapsed
	game.step(Vector2.LEFT, 5.0)
	check(game.player == paused_player and game.elapsed == paused_time, "Pause freezes position and time")
	game.toggle_pause()
	check(game.state == &"playing", "Resume")
	game.start()
	game.enemies.clear()
	var base_speed := game.enemy_speed()
	game.player = game.goals[0]
	game.step(Vector2.ZERO, 0.0)
	check(game.collected == 1 and game.enemy_speed() > base_speed, "Collection raises difficulty")
	game.step(Vector2.ZERO, 0.0)
	check(game.collected == 1, "A signal cannot be collected twice")
	while not game.goals.is_empty():
		game.player = game.goals[0]
		game.step(Vector2.ZERO, 0.0)
	check(game.state == &"won" and game.wins == 1, "Collect all signals wins")
	check(game.enemy_speed() <= game.config.enemy_max_speed, "Difficulty cap")
	game.step(Vector2.RIGHT, 1.0)
	check(game.wins == 1, "Terminal state cannot award repeated wins")
	game.start()
	check(game.collected == 0 and game.goals.size() == 5 and game.enemies.size() == 3 and game.elapsed == 0.0, "Restart after victory restores level")
	game.enemies[0] = game.player
	game.step(Vector2.ZERO, 0.0)
	check(game.state == &"lost", "Enemy contact loses")
	game.start()
	check(game.state == &"playing" and game.player == game.config.arena.get_center(), "Restart after defeat")
	var level := LevelConfig.new()
	level.goal_spawns = [level.arena.get_center()]
	level.enemy_spawns = [level.arena.get_center()]
	var simultaneous := RunState.new(level)
	simultaneous.start()
	simultaneous.step(Vector2.ZERO, 0.0)
	check(simultaneous.state == &"lost" and simultaneous.collected == 0, "Contact beats final signal")
	level.enemy_spawns.clear()
	var custom := RunState.new(level)
	custom.start()
	custom.step(Vector2.ZERO, 0.0)
	check(custom.state == &"won" and custom.collected == 1, "Goal total comes from configuration")
	check(level.goal_spawns.size() == 1, "Runtime collection preserves level data")
	print("Signal Run: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
