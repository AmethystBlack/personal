extends Control

signal actor_attacks
signal actor_dodges
signal actor_misc

@onready var player = self.get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#h.HUD.healthUi.setupHP(player.stats)
	
	player.state = player.State.MOVING
	await player.ready
	player.interactReceiver.area_entered.connect(_on_interact_range_area_entered)
	print("A cmon")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if h.HUD == null:
		return
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
		player.state = player.State.ATTACK
	elif Input.is_action_just_pressed("roll"):
		actor_dodges.emit()
		player.state = player.State.ROLL
	elif Input.is_action_just_pressed("misc"):
		actor_misc.emit()
		process_misc()
		
		
func process_misc():
	interact()
	#h.map.introScene()
	
func interact():
	player.interactHitbox.disabled = false
	await get_tree().create_timer(0.1).timeout
	player.interactHitbox.disabled = true

func _on_interact_range_area_entered(area: Area2D) -> void:
	print(area)
	#if area.get_parent() == self:
		#return
		
	var foundNode = area.get_parent()
	if foundNode.has_method("interact"):
		foundNode.interact(player)
	else:
		h.map.interact(foundNode.name,player)
