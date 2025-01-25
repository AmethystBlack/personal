extends Node

@export var max_health: int = 1:
	set(value):
		max_health = value
		set_max_health(value)
var health = max_health:
	set(value):
		health = value
		set_health(value)
			
signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_health(value):
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func set_max_health(value):
	health = min(health, max_health)
	emit_signal("max_health_changed", max_health)
	
func _ready():
	health = max_health
