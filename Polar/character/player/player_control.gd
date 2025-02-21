extends Control

signal actor_attacks
signal actor_dodges
signal actor_misc

@onready var player = self.get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if h.gameState != h.game.SCENE:
		player.moveVector = getInputVector()
		otherInputs()

func getInputVector():
	var input_vector = Vector2.ZERO
	if !h.HUD.canControl():
		return input_vector
		
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	return input_vector
	
func otherInputs():
	if !h.HUD.canControl():
		return
		
	if Input.is_action_just_pressed("attack"):
		actor_attacks.emit()
	elif Input.is_action_just_pressed("roll"):
		actor_dodges.emit()
	elif Input.is_action_just_pressed("misc"):
		actor_misc.emit()
