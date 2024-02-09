extends Node2D

@export var player : CharacterBody2D
@onready var collision_polygon_2d = $StaticBody2D/CollisionPolygon2D
@onready var polygon_2d = $StaticBody2D/CollisionPolygon2D/Polygon2D

func _ready():
	Global.external_pause = true
	Engine.time_scale = 0
	polygon_2d.polygon = collision_polygon_2d.polygon
	player.boss_bar.visible = true
	player.boss_name.text = "VOID WYRM"

func _process(_delta):
	if player.dead:
		player.boss_bar.visible = false
		get_tree().change_scene_to_file("res://scenes/death_screen.tscn")
	
	if Input.is_action_just_pressed("escape"):
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
	Global.update_player_stats(player)
	get_tree().change_scene_to_file("res://scenes/world.tscn")
