extends Node2D

@onready var Camera = $Camera2D

const startingMap = "gift_shop"

var preloadMap = preload("res://maps/" + startingMap + ".tscn")

func _ready() -> void:
	h.setShortcuts()
	loadMap()
	
func loadMap():
	var newMap = null
	if h.mapOverride != null: #used for playing current scene from editor
		var mapFile = load(h.mapOverride)
		newMap = mapFile.instantiate()
		h.mapOverride = null
	else:
		newMap = preloadMap.instantiate()
	add_child(newMap)
	setCameraBounds(newMap)
	
func setCameraBounds(map):
	$Camera2D/Limits/TopLeft.position = map.boundsTopLeft
	$Camera2D/Limits/BottomRight.position = map.boundsBottomRight
	$Camera2D.set_bounds()
	
	
