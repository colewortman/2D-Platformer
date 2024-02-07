extends Button

@export var escape_key := false
signal click_end()

#func _on_mouse_entered():
	#$hover.play()

#func _on_pressed():
	#$click.play()

func _process(_delta):
	if Input.is_action_just_pressed("escape") and get_tree().paused == true and escape_key == true:
		emit_signal("click_end")

func _on_click_finished():
	emit_signal("click_end")
