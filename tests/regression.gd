extends SceneTree

var failures := 0
var checks := 0

func _initialize() -> void:
	call_deferred("_run")

func check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		push_error(label)

func _run() -> void:
	var script := load("res://scripts/main.gd") as GDScript
	if script == null or not script.can_instantiate():
		push_error("Cannot load game script")
		quit(1)
		return
	var game = script.new()
	var other = script.new()
	root.add_child(game)
	game.set_physics_process(false)
	game.set_process(false)
	check(game.player == Vector2(480, 286), "Initial player position")
	check(game.enemies.size() == 3 and game.goals.size() == 5, "Initial counts")
	var original_enemies: Array = game.enemies.duplicate()
	var original_goals: Array = game.goals.duplicate()
	game.enemies[0] = Vector2.ZERO
	game.goals.remove_at(0)
	check(other.enemies == original_enemies and other.goals == original_goals, "Instance isolation")
	game.restart()
	check(game.enemies == original_enemies and game.goals == original_goals, "Restart restores all positions")
	check(game._previous_player == game.player and game._previous_enemies == game.enemies, "Restart interpolation reset")
	game.enemies.clear()
	Input.action_press("move_right")
	game._physics_process(0.1)
	Input.action_release("move_right")
	check(game.player.is_equal_approx(Vector2(508, 286)), "Cardinal speed")
	game.player = Vector2(480, 286)
	Input.action_press("move_right")
	Input.action_press("move_down")
	game._physics_process(0.1)
	Input.action_release("move_right")
	Input.action_release("move_down")
	check(is_equal_approx(game.player.distance_to(Vector2(480, 286)), 28.0), "Diagonal normalization")
	game.player = Vector2(-1000, -1000)
	game._physics_process(0.0)
	check(game.player == Vector2(64, 108), "Top/left arena bounds")
	game.player = Vector2(2000, 2000)
	game._physics_process(0.0)
	check(game.player == Vector2(896, 464), "Bottom/right arena bounds")
	game.restart()
	game.enemies.assign([game.player + Vector2(100, 0)])
	game._physics_process(0.1)
	check(is_equal_approx(game.enemies[0].distance_to(game.player), 90.8), "Enemy pursuit speed")
	game.enemies.assign([game.player + Vector2(34, 0)])
	game._physics_process(0.0)
	check(game.state == "lost", "Inclusive collision radius")
	var end_position: Vector2 = game.player
	Input.action_press("move_left")
	game._physics_process(0.1)
	Input.action_release("move_left")
	check(game.player == end_position, "Loss freezes simulation")
	game.restart()
	check(game.state == "playing" and game.collected == 0, "Restart after loss")
	game.enemies.clear()
	for goal in original_goals:
		game.player = goal
		game._physics_process(0.0)
	check(game.state == "won" and game.collected == 5 and game.goals.is_empty(), "Collect all goals and win")
	game.restart()
	check(game.state == "playing" and game.goals == original_goals, "Restart after win")
	game.enemies.clear()
	game.goals.assign([game.player, game.player])
	game._physics_process(0.0)
	check(game.goals.is_empty() and game.collected == 2, "Simultaneous collection without skipped goals")
	game.restart()
	game.enemies.assign([game.player])
	game.goals.assign([game.player])
	game.collected = 4
	game._physics_process(0.0)
	check(game.state == "lost" and game.collected == 4, "Collision priority over final goal")
	game.restart()
	game.enemies.clear()
	game.player = game.goals[0]
	game._physics_process(0.0)
	check(game._pickup_feedback_left > 0.0, "Pickup feedback starts")
	game._process(1.0)
	check(game._pickup_feedback_left == 0.0, "Pickup feedback expires")
	game.player = game.goals[0]
	game._physics_process(0.0)
	game.restart()
	check(game._pickup_feedback_left == 0.0, "Restart clears pickup feedback")
	game.free()
	other.free()
	print("REGRESSION: %d checks, %d failures" % [checks, failures])
	quit(1 if failures else 0)
