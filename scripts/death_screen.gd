extends Control

func _on_restart_pressed():
	Global.reset_stats()
	Global.lock = true
	Global.castle_defeated = false
	Global.void_defeated = false
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
