extends CharacterBody2D

const KNOCKBACK_FRICTION = 400
const KNOCKBACK_DISTANCE = 450

@export var ACCELERATION = 30
@export var MAX_SPEED = 60
@export var FRICTION = 1400


const DeathEffect =  preload("res://Effects/enemy_death_effect.tscn")


enum {
	IDLE,
	WANDER,
	CHASE
}
var state = IDLE

@onready var sprite = $AnimatedSprite
@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var hurtbox = $Hurtbox
@onready var softCollision = $SoftCollision
@onready var wanderController = $WanderController
@onready var animationPlayer = $AnimationPlayer

func _ready():
	sprite.frame = randf_range(0, 4)
	idle_or_wander()

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, (KNOCKBACK_FRICTION * delta))
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, (FRICTION * delta))
			seek_player()
			if(wanderController.get_time_left() == 0):
				idle_or_wander()
				
		WANDER:
			seek_player()
			if(wanderController.get_time_left() == 0):
				idle_or_wander()
			velocity = accelerate_towards_point(wanderController.target_position)
			if global_position.distance_to(wanderController.target_position) <= (MAX_SPEED * delta) :
				idle_or_wander()
				
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				velocity = accelerate_towards_point(player.global_position)
			else:
				state = IDLE
				
	sprite.flip_h = velocity.x < 0 
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 500
	move_and_slide()

func accelerate_towards_point(point):
	var direction = position.direction_to(point)
	return velocity.move_toward(direction * MAX_SPEED, ACCELERATION)

func idle_or_wander():
	state = pick_random_state([IDLE,WANDER])
	wanderController.start_wander_timer(randf_range(1,3))

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	velocity = area.knockback_vector * KNOCKBACK_DISTANCE
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()

func _on_stats_no_health():
		await get_tree().create_timer(0.25).timeout
		create_death_effect()
		queue_free()

func create_death_effect():
		var deathEffect = DeathEffect.instantiate()
		get_parent().add_child(deathEffect)
		deathEffect.global_position = global_position
		#queue_free()
		


func _on_hurtbox_invincibility_ended():
	animationPlayer.play("Stop")


func _on_hurtbox_invincibility_started():
	animationPlayer.play("Start")
