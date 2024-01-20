extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 100
var health : float
var crit_zone = false

signal death

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	health = MAX_HEALTH

func damage(attack: Attack):
	if attack.player_attack:
		if crit_zone:
			attack.crit_chance = 100
		
		attack.crit_roll = randi_range(1, 100)
		
		if attack.crit_roll <= attack.crit_chance:
			print("crit hit")
			attack.crit_damage = randf_range(attack.attack_damage * 0.15, attack.attack_damage * 2.5)
			attack.attack_damage += int(attack.crit_damage)
			attack.crit_tracker = true
			
	health -= attack.attack_damage
	
	if health <= 0:
		emit_signal("death")

func heal(hp):
	health += hp
	if health >= 200:
		health = 200
