extends Node2D

@export var player : CharacterBody2D

func _ready():
	Global.use_stats(player)

func _process(delta):
	if player.dead and Global.void_defeated == false:
		Global.reset_stats()
		get_tree().change_scene_to_file("res://scenes/death_void.tscn")
	elif player.dead and Global.void_defeated == true:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		
	if Global.castle_defeated:
		Global.lock = true
		Global.reset_stats()
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
