extends Node

var lock = true
var castle_defeated = false
var void_defeated = false
var base_health = 100
var base_souls = 0
var health
var souls
var show_player_controls = true
var external_pause = false

func _ready():
	if health == null and souls == null:
		reset_stats()

func update_player_stats(player : CharacterBody2D):
	health = player.HealthComponent.health
	souls = player.souls

func use_stats(player : CharacterBody2D):
	player.HealthComponent.health = health
	player.souls = souls

func reset_stats():
	health = base_health
	souls = base_souls
