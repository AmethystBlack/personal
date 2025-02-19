extends PolarNPC


var roll_vector = Vector2.RIGHT

var moveVector : Vector2 = Vector2.ZERO :
	set (value):
		moveVector = value
		updateVectorAnims(moveVector)

@onready var swordHitbox = $HitboxPivot/SwordHitbox
@onready var interactHitbox = $HitboxPivot/InteractRange/CollisionShape2D
#@onready var control = $PlayerControl


func _ready():
	randomize()
	h.HUD.healthUi.setupHP(stats)
	self.stats.connect("no_health", queue_free)
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector
	state = State.MOVING

func _process(_delta):
	pass

func _physics_process(delta):	
	match state:
		State.MOVING:
			move_state(delta)
		State.ROLL: 
			roll_state(delta)
		State.ATTACK: 
			attack_state(delta)
		State.PATH:
			path_state(delta)
	
func updateVectorAnims(moveVector):
	if moveVector != Vector2.ZERO:
		roll_vector = moveVector
		swordHitbox.knockback_vector = moveVector
		updateFacing(moveVector)
		animationState.travel("Run")
	
func move_state(delta):	
	if moveVector != Vector2.ZERO:
		velocity = velocity.move_toward(moveVector * stats.max_speed, (stats.acceleration * delta))
		updateFacing(velocity)
	else: 
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO,(stats.friction * delta))
	move_and_slide()
	

func attack_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, (stats.friction/2) * delta)
	move_and_slide()
	animationState.travel("Attack")
	
func attack_animation_finished():
	state = State.MOVING

func roll_state(delta):
	var minimumRoll = roll_vector * (ROLL_SPEED)
	if (velocity.x**2) < (minimumRoll.x**2) || (velocity.y**2) < (minimumRoll.y**2):
		velocity = minimumRoll
	move_and_slide()
	animationState.travel("Roll")
	
func roll_animation_finished():
	state = State.MOVING

func _on_player_control_actor_attacks() -> void:
	state = State.ATTACK

func _on_player_control_actor_dodges() -> void:
	state = State.ROLL

func _on_player_control_actor_misc() -> void:
	process_misc()

func process_misc():
	#interact()
	h.actors["flaw"].path_to_cursor()
	#h.EnsembleFace()
	
func interact():
	interactHitbox.disabled = false
	await get_tree().create_timer(0.1).timeout
	interactHitbox.disabled = true
	
func directNpc():
	var targetActor = h.actors["NPC"]
	targetActor.path_to_cursor()


func _on_interact_range_area_entered(area: Area2D) -> void:
	if area.get_parent() == self:
		return
		
	var foundNode = area.get_parent()
	#var targetActor = h.actors["NPC"]
	if foundNode.has_method("interact"):
		foundNode.interact()
	else:
		h.map.interact(foundNode.name)
