extends Node2D

const GrassEffect =  preload("res://Effects/grass_effect.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


 #Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Input.is_action_just_pressed("attack"):
	pass

func _on_hurtbox_area_entered(area):
	create_grass_effect()

func create_grass_effect():
		var grassEffect = GrassEffect.instantiate()
		get_parent().add_child(grassEffect)
		grassEffect.global_position = global_position
		queue_free()
		
