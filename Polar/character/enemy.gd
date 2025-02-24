extends Actor

##❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆
##❅❆❅	Config
##❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆

enum AI {
	IDLE,
	WANDER,
	CHASE,
}
var aiState = AI.IDLE

@onready var playerDetectionZone = $PlayerDetectionZone
@onready var wanderController = $WanderController

##❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆
##❅❆❅	Inert
##❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆

func _ready():
	super._ready()
	idle_or_wander()

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, (stats.knockback_friction * delta))
	
	match aiState:
		AI.IDLE:
			animationState.travel("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, (stats.friction * delta))
			seek_player()
			if(wanderController.get_time_left() == 0):
				idle_or_wander()
				
		AI.WANDER:
			seek_player()
			if(wanderController.get_time_left() == 0):
				idle_or_wander()
			animationState.travel("Run")
			velocity = accelerate_towards_point(wanderController.target_position)
			updateFacing(velocity)
			if global_position.distance_to(wanderController.target_position) <= (stats.max_speed * delta) :
				idle_or_wander()
				
			
		AI.CHASE:
			var player = playerDetectionZone.player
			if player != null:
				animationState.travel("Run")
				velocity = accelerate_towards_point(player.global_position)
				updateFacing(velocity)
			else:
				aiState = AI.IDLE
				
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 500
	
	move_and_slide()


##❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆
##❅❆❅	Movement
##❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆❆❅❆❅❆

func accelerate_towards_point(point):
	var direction = position.direction_to(point)
	return velocity.move_toward(direction * stats.max_speed, stats.acceleration)

func idle_or_wander():
	aiState = pick_random_state([AI.IDLE,AI.WANDER])
	wanderController.start_wander_timer(randf_range(1,3))

func seek_player():
	if playerDetectionZone.can_see_player():
		aiState = AI.CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
