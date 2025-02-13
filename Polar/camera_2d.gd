extends Camera2D
#
var topLeft = Vector2.ZERO
var bottomRight = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_bounds():
	limit_top = topLeft.y
	limit_left = topLeft.x
	limit_bottom = bottomRight.y
	limit_right = bottomRight.x
