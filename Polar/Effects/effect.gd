extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("animation_finished", Callable(self, "_on_animation_finished"))
	play("Animate")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animation_finished():
	queue_free()
