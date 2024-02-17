extends Control

func _ready():
	Global.reset_stats()
	Global.lock = true
	Global.castle_defeated = false
	Global.void_defeated = false
	Engine.time_scale = 1
	$AnimationPlayer.play("fade_in")

func _on_start_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_exit_btn_pressed():
	get_tree().quit()

func _on_options_btn_pressed():
	$options_menu.visible = true
