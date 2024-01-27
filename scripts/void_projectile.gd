extends Area2D

var speed = 0.5
var health = 1
@onready var anim = $AnimatedSprite2D
@onready var player : CharacterBody2D
@onready var summoner : CharacterBody2D
var attack_buff = 10.0
var attack_damage = 20.0

func _ready():
	anim.play("spawn")
	$spawn_timer.start()
	$duration_timer.start()

func _process(delta):
	global_position += speed*(player.global_position - global_position).normalized()

func _on_hit_timer_timeout():
	if health <= 0:
		queue_free()

func _on_area_entered(area):
	if area.has_method("damage"):
		anim.play("hit")
		health -= 1
		$hit_timer.start()
		
		if summoner.attack_damage >= 50:
			var attack = Attack.new()
			attack.attack_damage = attack_damage
			area.damage(attack)
		else:
			summoner.attack_damage += attack_buff
func _on_spawn_timer_timeout():
	$CollisionShape2D.disabled = false
	anim.play("idle")

func _on_duration_timer_timeout():
	anim.play("hit")
	health -= 1
	$hit_timer.start()
