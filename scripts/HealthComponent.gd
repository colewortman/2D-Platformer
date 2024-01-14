extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 100
var health : float

signal death

# Called when the node enters the scene tree for the first time.
func _ready():
	health = MAX_HEALTH

func damage(attack: Attack):
	health -= attack.attack_damage
	
	if health <= 0:
		emit_signal("death")

func heal(hp):
	health += hp
	if health >= 200:
		health = 200
