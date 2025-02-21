@tool
extends CharacterBody2D
class_name Actor

##❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆
##❅❆❅	Config
##❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆

@onready var stats = $Stats
@onready var animationPlayer = $AnimationPlayer
@onready var blinkAnimationPlayer = $BlinkAnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var hurtbox = $Hurtbox
@onready var softCollision = $SoftCollision
@onready var navigation_agent = $NavigationAgent2D
@onready var hitbox_pivot = $HitboxPivot
@onready var _sprite: Sprite2D = $Sprite2D
@onready var attackHitbox = $HitboxPivot/AttackHitbox
@onready var interactHitbox = $HitboxPivot/InteractRange/CollisionShape2D

enum State {
	IDLE,
	MOVING,
	PATH,
	ROLL,
	ATTACK
}
var state = State.IDLE

const DamageSound = preload("res://character/player/player_hurt_sound.tscn")

signal finishedPathing

var mousedOver = false
var facingVector = Vector2.ZERO
var reservedFacing = Vector2.ZERO

@export var skin: Texture : set = set_skin
enum DIRECTIONS { DOWN , LEFT , RIGHT , UP }
@export var defaultFacing: DIRECTIONS : set = setFacing

var moveVector : Vector2 = Vector2.ZERO :
	set (value):
		moveVector = value
		updateVectorAnims(moveVector)

func updateVectorAnims(moveVector):
	if moveVector != Vector2.ZERO:
		attackHitbox.knockback_vector = moveVector
		updateFacing(moveVector)
		animationState.travel("Run")

func set_skin(value: Texture) -> void:
	skin = value
	if not _sprite:
		await ready
	_sprite.texture = value
	if value != null: #doing some math to set the offset of the sprite for variable skin sizes
		# here we are anchoring it to bottom center
		var w = value.get_width()
		var h = value.get_height()
		_sprite.offset.x = -((w/_sprite.hframes)/2)
		_sprite.offset.y = -(h/_sprite.vframes)

func setFacing(value):
	defaultFacing = value
	if Engine.is_editor_hint():
		match defaultFacing:
			DIRECTIONS.DOWN:
				_sprite.frame = 0
			DIRECTIONS.LEFT:
				_sprite.frame = 4
			DIRECTIONS.RIGHT:
				_sprite.frame = 8
			DIRECTIONS.UP:
				_sprite.frame = 12
	else:
		await ready
		updateDefaultFacing()

##❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆
##❅❆❅	Inert
##❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆

func _ready():
	self.stats.connect("no_health", queue_free)
	if not Engine.is_editor_hint():
		animationTree.active = true
	updateDefaultFacing()

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
	
##❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆
##❅❆❅	Signals
##❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆

func _on_interaction_mouse_entered() -> void:
	mousedOver = true

func _on_interaction_mouse_exited() -> void:
	mousedOver = false
	
func _on_hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")

func _on_hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_hurtbox_area_entered(area):
	takeDamage(area)

##❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆
##❅❆❅	Facing
##❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆

func updateFacing(vector2):
	if not Engine.is_editor_hint():
		animationTree.set("parameters/Idle/blend_position",vector2)
		animationTree.set("parameters/Run/blend_position",vector2)
		animationTree.set("parameters/Attack/blend_position",vector2)
		animationTree.set("parameters/Roll/blend_position",vector2)
		attackHitbox.knockback_vector = vector2
		hitbox_pivot.rotation = vector2.angle()
		facingVector = vector2
	
func faceReserved():
	if reservedFacing != Vector2.ZERO:
		updateFacing(reservedFacing)
	
func updateDefaultFacing():
	match defaultFacing:
		DIRECTIONS.DOWN:
			faceDown()
		DIRECTIONS.LEFT:
			faceLeft()
		DIRECTIONS.RIGHT:
			faceRight()
		DIRECTIONS.UP:
			faceUp()
			
##❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆
##❅❆❅	Movement functions
##❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆
	
func move_state(delta):	
	if moveVector != Vector2.ZERO:
		velocity = velocity.move_toward(moveVector * stats.max_speed, (stats.acceleration * delta))
		updateFacing(velocity)
	else: 
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO,(stats.friction * delta))
	move_and_slide()

func path_to_cursor():
	set_movement_target(get_global_mouse_position())
	state = State.PATH
	animationState.travel("Run")

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target
	
func path_state(_delta):
	if navigation_agent.is_navigation_finished():
		state = State.MOVING
		animationState.travel("Idle")
		finishedPathing.emit()
		return
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	#print(next_path_position)
	velocity = current_agent_position.direction_to(next_path_position) * stats.max_speed
	updateFacing(velocity)
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * _delta * 500
	move_and_slide()
	
##❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆
##❅❆❅	Damage and Interaction
##❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆

func takeDamage(area):
	if hurtbox.invincible == false:
		stats.health -= area.damage
		hurtbox.start_invincibility(0.5)
		hurtbox.create_hit_effect()
		var damageSound = DamageSound.instantiate()
		get_tree().current_scene.add_child(damageSound)
			
func interactedWith():
	reservedFacing = facingVector
	faceCharacter(h.actors["player"])
	
func attack_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, (stats.friction/2) * delta)
	move_and_slide()
	animationState.travel("Attack")
	
func attack_animation_finished():
	state = State.MOVING
	
func roll_state(delta):
	var minimumRoll = moveVector * (stats.roll_speed)
	if (velocity.x**2) < (minimumRoll.x**2) || (velocity.y**2) < (minimumRoll.y**2):
		velocity = minimumRoll
	move_and_slide()
	animationState.travel("Roll")
	
	
func roll_animation_finished():
	state = State.MOVING
	
		
##❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆
##❅❆❅	Usable Actor Commands
##❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆

func stx(text):
	h.stx(text, self)

func faceLeft():
	updateFacing(Vector2.LEFT)
	
func faceRight():
	updateFacing(Vector2.RIGHT)
	
func faceUp():
	updateFacing(Vector2.UP)
	
func faceDown():
	updateFacing(Vector2.DOWN)
	
func faceCharacter(targetCharacter):
	facePoint(targetCharacter.position)
	
func faceChar(targetCharacter): # alias
	faceCharacter(targetCharacter)

func facePoint(point: Vector2):
	var destination = self.position.direction_to(point)
	updateFacing(destination)
	
func runInPlace():
	animationState.travel("Run")
	
func idleInPlace():
	animationState.travel("Idle")
	
func moveTo(x,y):
	var destination = Vector2(x, y)
	set_movement_target(destination)
	state = State.PATH
	animationState.travel("Run")
	await finishedPathing
