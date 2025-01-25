extends Area2D

#@export var show_hit: bool = true

const HitEffect = preload("res://Effects/hit_effect.tscn")

signal invincibility_started
signal invincibility_ended

@onready var timer = $Timer

var invincible = false:
	set(value):
		invincible = value
		set_invincible(value)
	get:
		return invincible

func set_invincible(value):
	if invincible == true:
		invincibility_started.emit()
	else:
		invincibility_ended.emit()

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var effect = HitEffect.instantiate()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position


func _on_timer_timeout():
	self.invincible = false


func _on_invincibility_started():
	set_deferred("monitoring", false)

func _on_invincibility_ended():
	set_deferred("monitoring", true)
