extends CharacterBody2D

#physics constants
var speed = 100.0
const dash_speed = 3000.0
var acceleration = 800.0
const FRICTION = 1000.0
const JUMP_VELOCITY = -300.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#animation variables
@onready var anim = $rogue_anim
@onready var HealthComponent = $HealthComponent
var transform_allow = true
var just_transformed = false
var attack_ip = false
var dash_ip = false
var main_attack_tracker = 0
var alt_attack_tracker = 3
var tendril_active = false
@onready var tendril = preload("res://scenes/tendril.tscn")
@onready var arrow = preload("res://scenes/arrow.tscn")
@onready var void_bomb = preload("res://scenes/void_bomb.tscn")


#player stats variables
@export var summon_base : Node2D
var souls = Global.souls
var attack_damage
var crit_chance
var dead = false

func _ready():
	print("health: ", $HealthComponent.health)
	print("souls: ", souls)

func _physics_process(delta):
	apply_gravity(delta)
	handle_jump()
	
	if souls <= 0:
			souls = 0
	elif souls >= 100:
		souls = 100
	
	var input_axis = Input.get_axis("left", "right")
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	update_movement_animations(input_axis)
	handle_dash(input_axis, delta)
	
	if Input.is_action_just_pressed("transform") and attack_ip == false:
		handle_transform()
	
	if Input.is_action_just_pressed("attack_main") and attack_ip == false:
		main_attack_tracker = handle_attack(main_attack_tracker) 
	
	if Input.is_action_just_pressed("attack_alternate") and attack_ip == false:
		alt_attack_tracker = handle_attack(alt_attack_tracker)
	
	if Input.is_action_just_pressed("down") and is_on_floor() == true:
		position.y += 1
	
	if Input.is_action_just_pressed("ultimate") and souls >= 30:
		if anim.flip_h:
			$weapon.rotation_degrees = 180
		else:
			$weapon.rotation_degrees = 0
		
		souls -= 30
		var new_void_bomb = void_bomb.instantiate()
		new_void_bomb.player = $"."
		new_void_bomb.global_position = $weapon/Weapon_area/Marker2D.global_position
		summon_base.add_child(new_void_bomb)
	
	move_and_slide()
#end _physics_process()

func apply_gravity(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
#end apply_gravity()

func handle_jump():
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
	else:
		if Input.is_action_just_released("jump") and velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2
#end handle_jump()

func handle_transform():
	#switch to monster
	if anim == $rogue_anim and transform_allow == true and attack_ip == false:
			transform_allow = false
			just_transformed = true
			anim.visible = false
			anim = $monster_anim
			anim.visible = true
			anim.play("transform2")
			$Transformation_timer.start()
	#switch back to rogue
	elif anim == $monster_anim and transform_allow == true and attack_ip == false:
			transform_allow = false
			anim.play("transform2_reverse")
			$Transformation_timer.start()
#end handle_transform()

func handle_attack(tracker):
	attack_ip = true
	
	if anim.flip_h:
		$weapon.rotation_degrees = 180
	else:
		$weapon.rotation_degrees = 0
	
	
	if tracker < 3:
		$Attack_timer.start(0.5)
		%melee_shape.disabled = false
	if anim == $rogue_anim:
		match tracker:
			0:
				anim.play("attack_dagger1")
				attack_damage = randi_range(10, 20)
				crit_chance = 25
				tracker +=1
				return tracker
			1:
				anim.play("attack_dagger2")
				attack_damage = randi_range(10, 20)
				crit_chance = 25
				tracker += 1
				return tracker
			2:
				anim.play("attack_scythe1")
				attack_damage = randi_range(20, 40)
				crit_chance = 95
				tracker = 0
				return tracker
			3:
				$Attack_timer.start(1)
				anim.play("attack_bow")
				$ArrowDelay_timer.start()
				return tracker
	else:
		match tracker:
			0:
				anim.play("attack_slash1")
				attack_damage = randi_range(20, 30)
				crit_chance = 40
				tracker +=1
				return tracker
			1:
				anim.play("attack_slash2")
				attack_damage = randi_range(20, 30)
				crit_chance = 40
				tracker += 1
				return tracker
			2:
				anim.play("attack_axe1")
				attack_damage = randi_range(45, 60)
				crit_chance = 80
				tracker = 0
				return tracker
			3:
				if !tendril_active and is_on_floor():
					$Attack_timer.start(1)
					tendril_active = true
					anim.play("attack_ground1")
					spawn_tendril()
				else:
					$Attack_timer.start(0.3)
					anim.play("attack_command")
				return tracker
#end handle_attack()

func handle_acceleration(input_axis, delta):
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, speed * input_axis, acceleration * delta)
#end handle_acceleration()

func apply_friction(input_axis, delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
#end apply_friction()

func update_movement_animations(input_axis):
	if input_axis != 0 and attack_ip == false:
		anim.flip_h = (input_axis < 0)
		if transform_allow == true:
			anim.play("run")
	elif input_axis == 0 and transform_allow == true and attack_ip == false:
		anim.play("idle")
	
	if not is_on_floor() and transform_allow == true and attack_ip == false:
		anim.play("jump")
#end handle_update_animations()

func handle_dash(input_axis, delta):
	if Input.is_action_just_pressed("dash") and dash_ip == false:
		dash_ip = true
		if anim == $rogue_anim:
			$".".set_collision_layer_value(2, false)
			$".".set_collision_mask_value(2, false)
		$HitboxComponent/hitbox_collision.disabled = true
		$Trail.visible = true
		speed = dash_speed
		acceleration = dash_speed
		$iFrame_timer.start()
		$Dash_timer.start()
#end handle_dash()

func _on_transformation_timer_timeout():
	#allow animations to finish
	#monster_anim holds all of the transformation animations
	if anim == $monster_anim and just_transformed == false:
		anim.visible = false
		anim = $rogue_anim
		anim.visible = true
		transform_allow = true
	else:
		transform_allow = true
		just_transformed = false
#end _on_transformation_timer_timeout()

func _on_attack_timer_timeout():
	%melee_shape.disabled = true
	attack_ip = false
#end _on_attack_timer_timeout()

func _on_weapon_area_area_entered(area):
	if area.has_method("damage"):
		var attack = Attack.new()
		attack.attack_damage = attack_damage
		attack.crit_chance = crit_chance
		attack.player_attack = true
		
		area.damage(attack)
#end _on_weapon_area_area_entered()

func _on_grab_area_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self
#end _on_grab_area_area_entered()

func _on_collect_area_area_entered(area):
	if area.is_in_group("loot") and area.collected == false:
		souls += area.collect()
		$HealthComponent.heal(area.get_health())
#end  _on_collect_area_area_entered()

func _on_health_component_death():
	print("died")
	dead = true
#end _on_health_component_death()

func _on_hitbox_component_hit():
	if anim == $rogue_anim:
		$rogue_anim/rogue_color.visible = true
	else:
		$monster_anim/monster_color.visible = true
	$effects.play("hurt")
	$Hurt_timer.start()
#end _on_hitbox_component_hit()

func _on_hurt_timer_timeout():
	$rogue_anim/rogue_color.visible = false
	$monster_anim/monster_color.visible = false
#end _on_hurt_timer_timeout()

func spawn_tendril():
	var new_tendril = tendril.instantiate()
	new_tendril.player = $"."
	new_tendril.global_position = $weapon/Weapon_area/Marker2D.global_position
	summon_base.add_child(new_tendril)
#end spawn_tendril()

func spawn_arrow():
	var new_arrow = arrow.instantiate()
	new_arrow.direction_right = !anim.flip_h
	new_arrow.global_position = $weapon/Weapon_area/Marker2D.global_position
	summon_base.add_child(new_arrow)
#end spawn_arrow()

func _on_arrow_delay_timer_timeout():
	spawn_arrow()
#end _on_arrow_delay_timer_timeout()

func _on_dash_timer_timeout():
	$".".set_collision_layer_value(2, true)
	$".".set_collision_mask_value(2, true)
	speed = 100.0
	acceleration = 800.0
	velocity.x = 0
	$Dash_cooldown.start()
#end _on_dash_timer_timeout()

func _on_dash_cooldown_timeout():
	dash_ip = false
	
#end _on_dash_cooldown_timeout()


func _on_i_frame_timer_timeout():
	$Trail.visible = false
	$HitboxComponent/hitbox_collision.disabled = false
