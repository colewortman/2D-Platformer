extends CharacterBody2D

@onready var player = $/root/World/Player
@onready var anim = $AnimatedSprite2D
@onready var loot_base = $/root/World/loot

@export var attack_damage: float
@export var knockback_force: float
@export var stun_damage: float

var speed = 10.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var soul = preload("res://scenes/souls.tscn")
@export var experience := 2
@export var soul_hp := 15

var player_far = true
var attack_range = false
var attack_ip = false
var direction = Vector2()
var state = states.IDLE
var flip = false

enum states{
	
	IDLE,
	CHARGE,
	SLAM,
	DEATH
	
}

func _process(delta):
	
	if !state == states.DEATH and $Death_timer.is_stopped() == true:
		handle_physics(delta)
		handle_flipping()
		if player_far and attack_ip == false:
			state = states.CHARGE
			attack_ip = true
		elif attack_ip == false:
			state = states.SLAM
			attack_ip = true
	
		handle_states()

func handle_physics(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = direction.x * speed
	
	move_and_slide()

func handle_states():
	match state:
		states.IDLE:
			anim.play("idle")
		states.CHARGE:
			speed = 30.0
			anim.play("charge1")
			$charge_timer.start()
			if player_far == false or $charge_timer.is_stopped():
				anim.play("bash1")
				$bash_timer.start()
		states.SLAM:
			if anim.flip_h == true:
				$HitboxComponent2/shield_hitbox.rotation_degrees = 180
			else:
				$HitboxComponent2/shield_hitbox.rotation_degrees = 0
			anim.play("slam1")

func handle_flipping():
	
	direction = (player.global_position - global_position).normalized()
	
	if direction.x < 0 and !state == states.CHARGE:
		flip = false
		$flip_timer.start()
	elif direction.x > 0 and !state == states.CHARGE:
		flip = true
		$flip_timer.start()
	
func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player_far = true

func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		player_far = false
	
	
func _on_health_component_death():
	print("signal recieved")
	state = states.DEATH
	if $Death_timer.is_stopped():
		anim.play("death")
		$Death_timer.start()

func _on_death_timer_timeout():
	var new_soul = soul.instantiate()
	new_soul.global_position = global_position
	new_soul.experience = experience
	new_soul.hp = soul_hp
	loot_base.add_child(new_soul)
	queue_free()

func _on_hitbox_component_hit():
	if !state == states.DEATH:
		$AnimatedSprite2D/ColorRect.visible = true
		$hurt.play("hurt")
		$Hurt_timer.start()

func _on_shield_area_entered(area):
	if area.has_method("damage"):
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.stun_damage = stun_damage
		attack.knockback_force = knockback_force
		
		area.damage(attack)

func _on_hurt_timer_timeout():
	$AnimatedSprite2D/ColorRect.visible = false


func _on_flip_timer_timeout():
	if flip == false:
		anim.flip_h = false
	else:
		anim.flip_h = true


func _on_bash_timer_timeout():
	attack_ip = false
	anim.play("idle")