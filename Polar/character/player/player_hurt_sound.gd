extends AudioStreamPlayer2D

func _ready():
	connect("finished", Callable(self, "queue_free"))
