extends Node2D

@export var player : CharacterBody2D
@onready var collision_polygon_2d = $StaticBody2D/CollisionPolygon2D
@onready var polygon_2d = $StaticBody2D/CollisionPolygon2D/Polygon2D

func _ready():
	polygon_2d.polygon = collision_polygon_2d.polygon
	player.boss_bar.visible = true
	player.boss_name.text = "VOID WYRM"

func _process(_delta):
	if player.dead:
		player.boss_bar.visible = false
		Global.lock = true
		Global.reset_stats()
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
	if Global.void_defeated:
		player.boss_bar.visible = false
		Global.update_player_stats(player)
		get_tree().change_scene_to_file("res://scenes/world.tscn")
