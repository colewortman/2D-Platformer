extends Area2D

@export var health_component : Node2D
@export var popup_location : Marker2D
signal hit

func damage(attack: Attack):
	if health_component:
		health_component.damage(attack)
		emit_signal("hit")

	if popup_location:
		popup_location.popup(attack)
