extends Node2D

@export var player : CharacterBody2D
var location

func _ready():
	Global.use_stats(player)
	player.boss_bar.visible = true
	player.boss_name.text = "COLOSSUS KNIGHT"

func _process(_delta):
	if player.dead and Global.void_defeated == false and $fade.is_stopped():
		$CanvasLayer/Control/ColorRect.visible = true
		$CanvasLayer/Control/AnimationPlayer.play("fade_out")
		player.boss_bar.visible = false
		Global.reset_stats()
		location = "res://scenes/death_void.tscn"
		$fade.start()
	elif player.dead and Global.void_defeated == true and $fade.is_stopped():
		$CanvasLayer/Control/ColorRect.visible = true
		$CanvasLayer/Control/AnimationPlayer.play("fade_out")
		player.boss_bar.visible = false
		location = "res://scenes/death_screen.tscn"
		$fade.start()
		
	if Global.castle_defeated and $Timer.is_stopped():
		$CanvasLayer/Control/Label.visible = true
		player.boss_bar.visible = false
		$Timer.start()

func _on_timer_timeout():
	$CanvasLayer/Control/ColorRect.visible = true
	$CanvasLayer/Control/AnimationPlayer.play("fade_out")
	location = "res://scenes/main_menu.tscn"
	$fade.start()

func _on_fade_timeout():
	get_tree().change_scene_to_file(location)
