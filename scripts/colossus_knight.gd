extends CharacterBody2D

@onready var player = $/root/Death_void/Player
@onready var anim = $AnimatedSprite2D
#@onready var loot_base = $/root/World/loot

@export var attack_damage: float
@export var knockback_force: float
@export var stun_damage: float

var speed = 0.0
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
	BASH,
	SLAM,
	DEATH
	
}

func _process(delta):
	if !state == states.DEATH and $Death_timer.is_stopped() == true:
		handle_physics(delta)
		handle_flipping()
		if player_far and attack_ip == false:
			attack_ip = true
			state = states.CHARGE
			$Shield/shield_hitbox.disabled = false
			$charge_timer.start()
		elif player_far == false and attack_ip == false:
			attack_ip = true
			state = states.SLAM
			$Shield/shield_hitbox.disabled = false
			$slam_timer.start()
		
		if state == states.BASH and $bash_timer.is_stopped():
			$bash_timer.start()
	
		handle_states()

func handle_physics(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = direction.x * speed
	
	move_and_slide()

func handle_states():
	match state:
		states.IDLE:
			speed = 0.0
			anim.play("idle")
		states.CHARGE:
			speed = 80.0
			anim.play("charge1")
			if player_far == false:
				state = states.BASH
		states.BASH:
			speed = 25.0
			anim.play("bash1")
		states.SLAM:
			speed = 0.0
			if anim.flip_h == true:
				$Shield/shield_hitbox.rotation_degrees = 180
			else:
				$Shield/shield_hitbox.rotation_degrees = 0
			anim.play("slam1")
			$shield_collision.set_collision_layer_value(1, false)
			$shield_collision.set_collision_mask_value(1, false)

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
		player_far = false

func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		player_far = true
	
	
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
	#loot_base.add_child(new_soul)
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
	state = states.IDLE
	print("bash done")
	$Shield/shield_hitbox.disabled = true
	anim.play("idle")
	$attack_cooldown.start()

func _on_slam_timer_timeout():
	state = states.IDLE
	$shield_collision.set_collision_layer_value(1, true)
	$shield_collision.set_collision_mask_value(1, true)
	$Shield/shield_hitbox.disabled = true
	$attack_cooldown.start()

func _on_attack_cooldown_timeout():
	attack_ip = false
