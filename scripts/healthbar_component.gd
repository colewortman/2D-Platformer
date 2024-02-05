extends ProgressBar

var health = 0

func init_health(body_health):
	health = body_health
	max_value = health
	value = health
	$damagebar.max_value = health
	$damagebar.value = health


func set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health <= 0:
		$".".visible = false
	
	if health < prev_health:
		$Timer.start()
	else:
		$damagebar.value = health

func _on_timer_timeout():
	$damagebar.value = health
