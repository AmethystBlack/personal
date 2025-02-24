extends Actor


enum AI {
	IDLE,
	WANDER,
	CHASE,
}
var aiState = AI.IDLE


@onready var playerDetectionZone = $PlayerDetectionZone
@onready var wanderController = $WanderController


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
#
#func _on_hurtbox_area_entered(area):
	##if area.get_parent() == self:
		##return
	#print("but.. huh?")
	#stats.health -= area.damage
	#
	#velocity = area.knockback_vector * stats.knockback_distance
	#hurtbox.start_invincibility(0.5)
	#hurtbox.create_hit_effect()

func _on_stats_no_health():
		print("???")

func _on_hurtbox_invincibility_ended():
	animationTree.active = true
	blinkAnimationPlayer.play("Stop")


func _on_hurtbox_invincibility_started():
	animationTree.active = false
	blinkAnimationPlayer.play("Start")
