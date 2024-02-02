extends Node

var lock = true
var castle_defeated = false
var void_defeated = false
var base_health = 100
var base_souls = 0
var health
var souls

func _ready():
	if health == null and souls == null:
		reset_stats()

func update_player_stats(player : CharacterBody2D):
	print("updating")
	health = player.HealthComponent.health
	souls = player.souls

func use_stats(player : CharacterBody2D):
	print("using")
	player.HealthComponent.health = health
	player.souls = souls

func reset_stats():
	print("resetting")
	health = base_health
	souls = base_souls
