extends Node2D

@export var player : CharacterBody2D

func _process(delta):
	if player.dead:
		get_tree().change_scene_to_file("res://scenes/death_void.tscn")
