extends CharacterBody2D

@export var player : CharacterBody2D
@onready var anim = $AnimatedSprite2D
@export var loot_base : Node2D
@onready var HealthComponent = $HealthComponent
@onready var healthbar = player.boss_bar
@export var key_enemy : bool

@export var attack_damage: float
@export var knockback_force: float
@export var stun_damage: float

var speed = 40.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var void_projectile = preload("res://scenes/void_projectile.tscn")
var soul = preload("res://scenes/souls.tscn")
@export var experience := 2
@export var soul_hp := 15

var player_in_range = false
var attack_range = false
var attack_ip = false
var spawnpoint_right = false
var direction = Vector2()
var state = states.IDLE

enum states{
	
	IDLE,
	RUN,
	ATTACK,
	SHOOT,
	DEATH
	
}

func _ready():
	healthbar.init_health($HealthComponent.health)

func _process(delta):
	if state == states.DEATH and key_enemy == true:
		Global.void_defeated = true
	
	if !state == states.DEATH and $Death_timer.is_stopped() == true:
		handle_physics(delta)
		handle_flipping()
		if player_in_range and attack_range == true and attack_ip == false:
			attack_ip = true
			state = states.ATTACK
			$swipe/CollisionShape2D.disabled = false
			$swipe_timer.start()
		elif not player_in_range and attack_range == false and attack_ip == false:
			attack_ip = true
			state = states.SHOOT
			$shoot_timer.start()
	
		handle_states()

func handle_physics(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = direction.x * speed
	
	move_and_slide()

func handle_states():
	match state:
		states.IDLE:
			anim.play("run")
		states.RUN:
			anim.play("run")
		states.ATTACK:
			anim.play("swipe")
		states.SHOOT:
			anim.play("fireball")
			if anim.flip_h == true:
				spawnpoint_right = true
			else:
				spawnpoint_right = false

func handle_flipping():
	if player_in_range:
		speed = 40.0
		direction = (player.global_position - global_position).normalized()
	else:
		speed = 0.0
	
	if direction.x < 0 and !state == states.ATTACK and !state == states.SHOOT:
		state = states.RUN
		anim.flip_h = false
	elif direction.x > 0 and !state == states.ATTACK and !state == states.SHOOT:
		state = states.RUN
		anim.flip_h = true

func _on_swipe_timer_timeout():
	$swipe/CollisionShape2D.disabled = true
	state = states.IDLE
	$swipe_cooldown.start()
	
func _on_swipe_cooldown_timeout():
	attack_ip = false

func _on_detection_area_body_entered(body):
	if body == player:
		player_in_range = true

func _on_detection_area_body_exited(body):
	if body == player:
		player_in_range = false
	

func _on_health_component_death():
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

func _on_swipe_area_entered(area):
	if area.has_method("damage"):
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.stun_damage = stun_damage
		attack.knockback_force = knockback_force
		
		area.damage(attack)

func _on_hitbox_component_hit():
	healthbar.set_health($HealthComponent.health)
	if !state == states.DEATH:
		$AnimatedSprite2D/ColorRect.visible = true
		$hurt.play("hurt")
		$Hurt_timer.start()

func _on_hurt_timer_timeout():
	$AnimatedSprite2D/ColorRect.visible = false

func _on_attack_range_body_entered(body):
	if body == player:
		attack_range = true

func _on_attack_range_body_exited(body):
	if body == player:
		attack_range = false
		
func _on_shoot_timer_timeout():
	if not state == states.DEATH:
		var new_projectile = void_projectile.instantiate()
		new_projectile.summoner = $"."
		new_projectile.player = player
		if spawnpoint_right:
			new_projectile.global_position = $projectile_spawn_right.global_position
		else:
			new_projectile.global_position = $projectile_spawn_left.global_position
		loot_base.add_child(new_projectile) 
		state = states.IDLE
		$shoot_cooldown.start()

func _on_shoot_cooldown_timeout():
	attack_ip = false
