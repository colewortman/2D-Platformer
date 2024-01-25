extends Marker2D

@export var damage_numbers : PackedScene

func _ready():
	randomize()

func popup(attack : Attack):
	var numbers = damage_numbers.instantiate()
	numbers.position = global_position
	var label = numbers.get_child(0)
	label.text = str(attack.attack_damage)
	if attack.crit_tracker == true:
		label.set("theme_override_font_sizes/font_size", 20)
		label.set("theme_override_colors/font_color", Color(1, 0.392, 0))
	
	var tween = get_tree().create_tween()
	tween.tween_property(numbers,
						"position",
						global_position + _get_direction(),
						0.75)
	
	get_tree().current_scene.add_child(numbers)
	
func _get_direction():
	return Vector2(randf_range(-1,1), -randf()) * 16
