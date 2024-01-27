extends Node2D

@export var player : CharacterBody2D
var lock = true

func _process(delta):
	if not $enemy_knight:
		lock = false
	
	if player.dead:
		get_tree().change_scene_to_file("res://scenes/death_void.tscn")


func _on_area_2d_body_entered(body: CharacterBody2D):
	if body == player and lock == false:
		get_tree().change_scene_to_file("res://scenes/castle_arena.tscn")
