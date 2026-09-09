extends Node2D

const RunState = preload("res://features/run/run_state.gd")
const RunView = preload("res://features/run/run_view.gd")
const LevelConfig = preload("res://features/run/level_config.gd")
@export var level: LevelConfig
var model: RunState
var pickup_audio: AudioStreamPlayer

func _ready() -> void:
	model = RunState.new(level)
	var view := RunView.new()
	view.model = model
	add_child(view)
	pickup_audio = AudioStreamPlayer.new()
	pickup_audio.stream = _pickup_sound()
	pickup_audio.volume_db = -12.0
	add_child(pickup_audio)
	model.collected_signal.connect(_on_collected)
	get_window().focus_exited.connect(_on_focus_exited)

func _physics_process(delta: float) -> void:
	model.step(Input.get_vector("move_left", "move_right", "move_up", "move_down"), delta)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if model.state == &"paused":
			model.toggle_pause()
		elif model.state != &"playing":
			model.start()
	elif event.is_action_pressed("ui_cancel"):
		model.toggle_pause()
	elif event.is_action_pressed("restart") and model.state in [&"won", &"lost"]:
		model.start()

func _on_focus_exited() -> void:
	if model.state == &"playing":
		model.toggle_pause()

func _on_collected(count: int) -> void:
	pickup_audio.pitch_scale = 1.0 + count * 0.08
	pickup_audio.play()

func _pickup_sound() -> AudioStreamWAV:
	var sound := AudioStreamWAV.new()
	sound.format = AudioStreamWAV.FORMAT_16_BITS
	sound.mix_rate = 22050
	var frames := 4410
	var bytes := PackedByteArray()
	bytes.resize(frames * 2)
	for i in frames:
		var t := float(i) / sound.mix_rate
		var envelope := minf(t / 0.008, 1.0) * pow(1.0 - float(i) / frames, 2.0)
		var sample := int(sin(TAU * 660.0 * t) * envelope * 16000.0)
		bytes.encode_s16(i * 2, sample)
	sound.data = bytes
	return sound
