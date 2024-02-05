extends Area2D

var speed = 200.0
var health = 1
@onready var anim = $AnimatedSprite2D
var attack_ip = false
var attack_damage = 10.0
var crit_chance = 50
var direction_right

func _process(delta):
	if !attack_ip:
		speed = 200.0
		anim.play("idle")
	if direction_right == true:
		global_position.x += speed * delta
		anim.flip_h = false
	else:
		global_position.x -= speed * delta
		anim.flip_h = true

func _on_hit_timer_timeout():
	attack_ip = false
	if health <= 0:
		queue_free()

func _on_area_entered(area):
	if area.has_method("damage") and area.get_parent().is_in_group("enemy"):
		attack_ip = true
		speed = 10
		anim.play("hit")
		health -= 1
		$Hit_timer.start()
		var attack = Attack.new()
		attack.attack_damage = randi_range(5, attack_damage)
		attack.crit_chance = crit_chance
		attack.player_attack = true
		
		area.damage(attack)


func _on_life_timer_timeout():
	self.queue_free()
