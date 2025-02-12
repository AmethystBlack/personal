extends Control

var hearts: set = set_hearts
var max_hearts: set = set_max_hearts

@onready var heartUIFull = $HeartUIFull
@onready var heartUIEmpty = $HeartUIEmpty

var playerUnit = null

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull != null:
		heartUIFull.size.x = (hearts * 15)

func set_max_hearts(value):
	max_hearts = max(value, 1)
	if heartUIEmpty != null:
		heartUIEmpty.size.x = (max_hearts * 15)
	
func _ready():
	pass
	
func setupHP(givenStats):
	playerUnit = givenStats
	max_hearts = playerUnit.max_health
	hearts = playerUnit.health
	playerUnit.connect("health_changed", Callable(self, "set_hearts"))
	playerUnit.connect("max_health_changed", Callable(self, "set_max_hearts"))
