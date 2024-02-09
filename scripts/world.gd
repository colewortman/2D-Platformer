extends Node2D

@export var player : CharacterBody2D
var location
var popup_num = 0

func _ready():
	Engine.time_scale = 1
	Global.use_stats(player)

func _process(_delta):
	if Global.lock == false and popup_num == 0:
		popup_num = 1
		$CanvasLayer/Control/Label.visible = true
		$CanvasLayer/Control/popup_anim.play("popup")
	
	if player.dead and Global.void_defeated == false and $fade.is_stopped():
		$CanvasLayer/Control/ColorRect.visible = true
		$CanvasLayer/Control/popup_anim.play("fade_out")
		Global.reset_stats()
		location = "res://scenes/death_void.tscn"
		$fade.start()
	elif player.dead and Global.void_defeated == true and $fade.is_stopped():
		$CanvasLayer/Control/ColorRect.visible = true
		$CanvasLayer/Control/popup_anim.play("fade_out")
		location = "res://scenes/death_screen.tscn"
		$fade.start()

func _on_area_2d_body_entered(body: CharacterBody2D):
	if body == player and Global.lock == false:
		Global.update_player_stats(player)
		get_tree().change_scene_to_file("res://scenes/castle_arena.tscn")
		


func _on_fade_timeout():
	get_tree().change_scene_to_file(location)
