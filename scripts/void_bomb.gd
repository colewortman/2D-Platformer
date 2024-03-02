extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
var player
var direction_right

var speed = 100.0
var attack_damage = 200.0
var crit_chance = 70

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	if player.anim.flip_h == true:
		direction_right = false
	else:
		direction_right = true
	
	anim.play("spawn")
	$Spawn_timer.start()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		speed = 20.0
		
	if direction_right == true:
		global_position.x += speed * delta
		anim.flip_h = false
	else:
		global_position.x -= speed * delta
		anim.flip_h = true
		
	move_and_slide()

func _on_spawn_timer_timeout():
	anim.play("idle")
	$Fuse_timer.start()

func _on_fuse_timer_timeout():
	anim.play("explode")
	$explode_snd.play()
	$Collision_delay.start()
	$Explosion_duration.start()
	
func _on_collision_delay_timeout():
	$HitboxComponent/CollisionShape2D.disabled = false

func _on_explosion_duration_timeout():
	$AnimatedSprite2D.visible = false
	if not $explode_snd.is_playing():
		queue_free()

func _on_hitbox_component_area_entered(area):
	if area.has_method("damage") and area.get_parent().is_in_group("enemy"):
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.crit_chance = crit_chance
		attack.player_attack = true
		
		area.damage(attack)
