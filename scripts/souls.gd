extends Area2D

@export var experience := 1
@export var hp := 15
var speed = -1
var target = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")

func _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 5*delta

func collect():
	$AudioStreamPlayer.play()
	$AnimatedSprite2D.visible = false
	return experience

func get_health():
	return hp

func _on_audio_stream_player_finished():
	queue_free()
