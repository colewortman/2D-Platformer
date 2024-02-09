extends Node2D

@export var player : CharacterBody2D
@onready var collision_polygon_2d = $StaticBody2D/CollisionPolygon2D
@onready var polygon_2d = $StaticBody2D/CollisionPolygon2D/Polygon2D
var location
var initial_escape = 0

func _ready():
	Global.external_pause = true
	Engine.time_scale = 0
	polygon_2d.polygon = collision_polygon_2d.polygon
	player.boss_bar.visible = true
	player.boss_name.text = "VOID WYRM"

func _process(_delta):
	if player.dead and $fade.is_stopped():
		$CanvasLayer/ColorRect2.visible = true
		$CanvasLayer/AnimationPlayer.play("fade_out")
		player.boss_bar.visible = false
		location = "res://scenes/death_screen.tscn"
		$fade.start()

	if Input.is_action_just_pressed("escape") and initial_escape == 0:
		initial_escape = 1
		$CanvasLayer/Control.visible = false
		Engine.time_scale = 1
		Global.external_pause = false
	
	if Global.void_defeated and $Timer.is_stopped():
		player.boss_bar.visible = false
		$Timer.start()

func _on_button_pressed():
	$CanvasLayer/Control.visible = false
	Engine.time_scale = 1
	Global.external_pause = false

func _on_timer_timeout():
	$CanvasLayer/ColorRect2.visible = true
	$CanvasLayer/AnimationPlayer.play("fade_out")
	Global.update_player_stats(player)
	location = "res://scenes/world.tscn"
	$fade.start()

func _on_fade_timeout():
	get_tree().change_scene_to_file(location)
