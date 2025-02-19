@tool
extends CharacterBody2D
class_name Actor

@export var skin: Texture : set = set_skin

const PlayerHurtSound = preload("res://character/player/player_hurt_sound.tscn")

#const ACCELERATION = 300
#const MAX_SPEED = 220
const ROLL_SPEED = 80
#const FRICTION = 1400

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
#@onready var subHUD = $SubHUD

enum DIRECTIONS { DOWN , LEFT , RIGHT , UP }
@export var defaultFacing: DIRECTIONS : set = setFacing

var mousedOver = false

enum State {
	IDLE,
	MOVING,
	PATH,
	ROLL,
	ATTACK
}
var state = State.IDLE

var facingVector = Vector2.ZERO
var reservedFacing = Vector2.ZERO

# Both setters below manipulate the unit's Sprite node.
# Here, we update the sprite's texture.
func set_skin(value: Texture) -> void:
	skin = value
	# Setter functions are called during the node's `_init()` callback, before they entered the
	# tree. At that point in time, the `_sprite` variable is `null`. If so, we have to wait to
	# update the sprite's properties.
	if not _sprite:
		# The yield keyword allows us to wait until the unit node's `_ready()` callback ended.
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

func _ready():
	#randomize()
	self.stats.connect("no_health", queue_free)
	if not Engine.is_editor_hint():
		animationTree.active = true
	updateDefaultFacing()

func _physics_process(delta):
	match state:
		State.MOVING:
			move_state(delta)
		State.PATH:
			path_state(delta)
	

	
func move_state(delta):	
	animationState.travel("Idle")
	velocity = velocity.move_toward(Vector2.ZERO,(stats.friction * delta))
	#updateFacing(velocity)
	move_and_slide()
	
func _on_hurtbox_area_entered(area):
	if hurtbox.invincible == false:
		stats.health -= area.damage
		hurtbox.start_invincibility(0.5)
		hurtbox.create_hit_effect()
		var playerHurtSound = PlayerHurtSound.instantiate()
		get_tree().current_scene.add_child(playerHurtSound)


func _on_hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")


func _on_hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")
	
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
		return

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	#print(next_path_position)
	
	velocity = current_agent_position.direction_to(next_path_position) * stats.max_speed
	updateFacing(velocity)
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * _delta * 500

	move_and_slide()

func updateFacing(vector2):
	if not Engine.is_editor_hint():
		animationTree.set("parameters/Idle/blend_position",vector2)
		animationTree.set("parameters/Run/blend_position",vector2)
		animationTree.set("parameters/Attack/blend_position",vector2)
		animationTree.set("parameters/Roll/blend_position",vector2)
		hitbox_pivot.rotation = vector2.angle()
		facingVector = vector2
	
func interactedWith():
	reservedFacing = facingVector
	faceCharacter(h.actors["player"])
	
func faceReserved():
	if reservedFacing != Vector2.ZERO:
		updateFacing(reservedFacing)
		
############## useful actor commands

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

func facePoint(point: Vector2):
	var destination = self.position.direction_to(point)
	updateFacing(destination)
	
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
	


func _on_interaction_mouse_entered() -> void:
	mousedOver = true


func _on_interaction_mouse_exited() -> void:
	mousedOver = false
