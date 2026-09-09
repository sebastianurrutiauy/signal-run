extends Resource

@export var arena := Rect2(48, 92, 864, 388)
@export var player_radius := 16.0
@export var enemy_radius := 18.0
@export var goal_radius := 13.0
@export var player_speed := 280.0
@export var enemy_base_speed := 92.0
@export var enemy_speed_per_signal := 18.0
@export var enemy_max_speed := 164.0
@export var enemy_spawns: Array[Vector2] = [Vector2(170, 165), Vector2(750, 170), Vector2(210, 395)]
@export var goal_spawns: Array[Vector2] = [Vector2(145, 280), Vector2(330, 150), Vector2(520, 390), Vector2(720, 285), Vector2(830, 420)]
