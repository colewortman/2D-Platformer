extends Area2D

var speed = 200.0
var health = 1
@onready var anim = $AnimatedSprite2D
@onready var player = $/root/World/Player
var attack_ip = false
var attack_damage = 10.0
var direction_right

func _ready():
	if player.anim.flip_h == true:
		direction_right = false
	else:
		direction_right = true

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
	if area.has_method("damage"):
		attack_ip = true
		speed = 10
		anim.play("hit")
		health -= 1
		$Hit_timer.start()
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		
		area.damage(attack)
