extends CharacterBody2D

@onready var player = $/root/World/Player
@onready var anim = $AnimatedSprite2D
@export var loot_base : Node2D
@onready var lightning = preload("res://scenes/lightning.tscn")
@export var summon_base : Node2D

var speed = 0.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var soul = preload("res://scenes/souls.tscn")
@export var experience := 1
@export var soul_hp := 5

var player_in_range = false
var attack_ip = false
var direction = Vector2()
var state = states.IDLE

enum states{
	
	IDLE,
	ATTACK,
	DEATH
	
}

func _process(delta):
	
	if !state == states.DEATH and $Death_timer.is_stopped() == true:
		handle_physics(delta)
		handle_flipping()
		if player_in_range and attack_ip == false:
			attack_ip = true
			state = states.ATTACK
			$Attack_anim_timer.start()
	
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
		states.ATTACK:
			anim.play("attack")

func handle_flipping():
	if player_in_range:
		direction = (player.global_position - global_position).normalized()
	
	if direction.x < 0 and !state == states.ATTACK:
		anim.flip_h = false
	elif direction.x > 0 and !state == states.ATTACK:
		anim.flip_h = true

	
func _on_attack_cooldown_timeout():
	attack_ip = false
	
func _on_attack_anim_timer_timeout():
	spawn_lightning()
	state = states.IDLE
	$Attack_cooldown.start()

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false

func _on_health_component_death():
	anim.play("idle")
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

func spawn_lightning():
	var new_lightning = lightning.instantiate()
	new_lightning.global_position = player.global_position
	summon_base.add_child(new_lightning)


func _on_hitbox_component_hit():
	$AudioStreamPlayer.play()
	if !state == states.DEATH:
		$AnimatedSprite2D/ColorRect.visible = true
		$hurt.play("hurt")
		$Hurt_timer.start()


func _on_hurt_timer_timeout():
	$AnimatedSprite2D/ColorRect.visible = false



