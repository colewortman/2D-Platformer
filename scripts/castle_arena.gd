extends Node2D

@export var player : CharacterBody2D

func _ready():
	Global.use_stats(player)
	player.boss_bar.visible = true
	player.boss_name.text = "COLOSSUS KNIGHT"

func _process(_delta):
	if player.dead and Global.void_defeated == false:
		player.boss_bar.visible = false
		Global.reset_stats()
		get_tree().change_scene_to_file("res://scenes/death_void.tscn")
	elif player.dead and Global.void_defeated == true:
		player.boss_bar.visible = false
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		
	if Global.castle_defeated and $Timer.is_stopped():
		$CanvasLayer/Control.visible = true
		player.boss_bar.visible = false
		$Timer.start()

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
