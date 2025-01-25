extends CharacterBody2D

const PlayerHurtSound = preload("res://Player/player_hurt_sound.tscn")

const ACCELERATION = 300
const MAX_SPEED = 220
const ROLL_SPEED = 80
const FRICTION = 1400

enum{
	MOVE,
	ROLL,
	ATTACK	
}
var state = MOVE
var roll_vector = Vector2.DOWN
var stats = PlayerStats

@onready var animationPlayer = $AnimationPlayer
@onready var blinkAnimationPlayer = $BlinkAnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var swordHitbox = $HitboxPivot/SwordHitbox
@onready var hurtbox = $Hurtbox

func _ready():
	randomize()
	self.stats.connect("no_health", queue_free)
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL: 
			roll_state(delta)
		ATTACK: 
			attack_state(delta)
	

	
func move_state(delta):	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position",input_vector)
		animationTree.set("parameters/Run/blend_position",input_vector)
		animationTree.set("parameters/Attack/blend_position",input_vector)
		animationTree.set("parameters/Roll/blend_position",input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, (ACCELERATION * delta))
	else: 
		animationState.travel("Idle")
		#animationPlayer.play("IdleRight")
		velocity = velocity.move_toward(Vector2.ZERO,(FRICTION * delta))
		
	move_and_slide()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	elif Input.is_action_just_pressed("roll"):
		state = ROLL

func attack_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, (FRICTION/2) * delta)
	move_and_slide()
	animationState.travel("Attack")
	
func attack_animation_finished():
	state = MOVE

func roll_state(delta):
	var minimumRoll = roll_vector * (ROLL_SPEED)
	if (velocity.x**2) < (minimumRoll.x**2) || (velocity.y**2) < (minimumRoll.y**2):
		velocity = minimumRoll
	move_and_slide()
	animationState.travel("Roll")
	
func roll_animation_finished():
	state = MOVE


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
