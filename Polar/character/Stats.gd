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

@export var damage: int = 1

@export var acceleration: int = 30
@export var max_speed: int = 60
@export var dodge_speed: int = 80
@export var friction: int = 1400
@export var knockback_friction: int = 400
@export var knockback_distance: int = 450

@export var initiative = 50

func set_health(value):
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func set_max_health(value):
	health = min(health, max_health)
	emit_signal("max_health_changed", max_health)
	
func _ready():
	health = max_health
	
func roll_initiative(): # sometimes the old ways are the best.
	var totalInit = initiative 
	totalInit += randf_range(-15,15)
	totalInit = clamp(totalInit, 0, 100)
	return totalInit
