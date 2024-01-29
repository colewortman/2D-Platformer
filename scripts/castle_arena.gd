extends Node2D

@export var player : CharacterBody2D

func _ready():
	Global.use_stats(player)

func _process(delta):
	if player.dead:
		Global.reset_stats()
		get_tree().change_scene_to_file("res://scenes/death_void.tscn")
