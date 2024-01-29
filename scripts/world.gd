extends Node2D

@export var player : CharacterBody2D

func _ready():
	Global.use_stats(player)

func _process(delta):
	
	if player.dead:
		Global.reset_stats()
		get_tree().change_scene_to_file("res://scenes/death_void.tscn")


func _on_area_2d_body_entered(body: CharacterBody2D):
	if body == player and Global.lock == false:
		Global.update_player_stats(player)
		get_tree().change_scene_to_file("res://scenes/castle_arena.tscn")
