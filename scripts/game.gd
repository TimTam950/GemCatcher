extends Node2D

const EXPLODE = preload("res://assets/explode.wav")

@export var gem_scene: PackedScene
@onready var score_label: Label = $Label
@onready var timer: Timer = $Timer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var _score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_gem() # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_gem() -> void:
	var new_gem: Gem = gem_scene.instantiate()
	var xpos: float = randf_range(70, 1050)
	new_gem.on_gem_off_screen.connect(game_over)
	new_gem.position = Vector2(xpos, -50)
	add_child(new_gem)
	
func game_over() -> void:
	stop_all()
	play_game_over_sound()
	
func play_game_over_sound() -> void:
	audio_stream_player_2d.stop()
	audio_stream_player_2d.stream = EXPLODE
	audio_stream_player_2d.play()
	
func _on_timer_timeout() -> void:
	spawn_gem()


func _on_paddle_area_entered(area: Area2D) -> void:
	audio_stream_player_2d.position = area.position
	audio_stream_player_2d.play()
	_score += 1
	score_label.text = str(_score).pad_zeros(5)
	area.queue_free()
	
func stop_all() -> void:
	timer.stop()
	for child in get_children():
		child.set_process(false)
