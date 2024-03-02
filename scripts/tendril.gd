extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
var player

var spawn_done = false
var attack_ip = false
var death = false
var direction = Vector2()
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var attack_damage = 5
var crit_chance = 50

var enemy_in_range = []

func _ready():
	$Duration.start()
	$SpawnDelay_timer.start()
	
	
func _process(delta):
	handle_physics(delta)
	handle_flipping()
	
	if spawn_done and !attack_ip and !death:
		anim.play("idle")
	
	if Input.is_action_just_pressed("attack_alternate") and spawn_done == true and attack_ip == false and !death:
		attack_ip = true
		tendril_attack()


func _on_spawn_delay_timer_timeout():
	if death == true:
		player.tendril_active = false
		queue_free()
	else:
		anim.visible = true
		anim.play("spawn")
		$Spawn_timer.start()

func _on_spawn_timer_timeout():
	spawn_done = true

func handle_physics(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()

func tendril_attack():
	$attack_control/Area2D/CollisionShape2D.disabled = false
	anim.play("attack_slam1")
	$AudioStreamPlayer.play()
	$Attack_timer.start()


func _on_attack_timer_timeout():
	$attack_control/Area2D/CollisionShape2D.disabled = true
	attack_ip = false

func _on_detection_area_body_entered(body):
	if body.is_in_group("enemy"):
		enemy_in_range.append(body)

func handle_flipping():
	if enemy_in_range.is_empty():
		direction = (player.global_position - global_position).normalized()
	else:
		direction = (enemy_in_range[0].global_position - global_position).normalized()
	
	if direction.x < 0 and attack_ip == false and !death:
		anim.flip_h = true
		$attack_control.rotation_degrees = 180
	elif direction.x > 0 and attack_ip == false and !death:
		anim.flip_h = false
		$attack_control.rotation_degrees = 0


func _on_detection_area_body_exited(body):
	if body.is_in_group("enemy"):
		enemy_in_range.clear()


func _on_area_2d_area_entered(area):
	if area.has_method("damage"):
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.crit_chance = crit_chance
		attack.player_attack = true
		
		area.damage(attack)


func _on_duration_timeout():
	death = true
	anim.play("death")
	$SpawnDelay_timer.start()
