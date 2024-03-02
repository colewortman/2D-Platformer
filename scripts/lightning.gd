extends Area2D

@onready var anim = $AnimatedSprite2D
@onready var player = $/root/World/Player
var attack_damage = 40
var speed = 200.0

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("idle")
	$AudioStreamPlayer.play()
	$Attack_cooldown.start()
	
func _on_attack_cooldown_timeout():
	$CollisionShape2D.disabled = false
	anim.play("hit")
	$Anim_cooldown.start()

func _on_anim_cooldown_timeout():
	queue_free()


func _on_area_entered(area):
	if area.has_method("damage"):
		var new_attack = Attack.new()
		new_attack.attack_damage = attack_damage
		
		area.damage(new_attack)
