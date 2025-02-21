extends Node2D
class_name Map

@onready var boundsTopLeft = $Limits/TopLeft.position
@onready var boundsBottomRight = $Limits/BottomRight.position

var Player = preload("res://character/player/player.tscn")
var playerGraphic = preload("res://character/trchar088.png")

@onready var player_start = $PlayerStart

var actors = {}
var a = actors

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_tree().current_scene.name != "Main":
		loadMainScene()
		return
		
	if player_start != null:
		createPlayer()
	subscribeActors()
	h.map = self
	
	autoplay()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func loadMainScene(): #strictly for testing from editor
	h.mapOverride = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://world.tscn")
	

func createPlayer():
	var newPlayerObj = Player.instantiate()
	newPlayerObj.position = player_start.position
	newPlayerObj.skin = playerGraphic
	$ObjectPlane/Actors.add_child(newPlayerObj)

func subscribeActors():
	var actorNodes = $ObjectPlane/Actors.get_children()
	for actor in actorNodes:
		var lowerName = actor.name.to_lower()
		actors[lowerName] = actor
	h.actors = actors

func interact(targetEvent):
	targetEvent = targetEvent.to_lower()
	var char = h.actors[targetEvent]
	if char.has_method("interactedWith"):
		char.interactedWith()
	targetEvent = targetEvent.to_lower()
	h.changeGameState(h.game.SCENE)
	await interactList(targetEvent)
	h.gameState = h.lastState
	endInteraction(char)

func interactList(targetEvent):
	end(targetEvent)
	
func autoplay():
	pass	
	
func end(targetEvent): # just an alias
	h.actors[targetEvent].done_interacting.emit()
	
func endInteraction(char):
	char.faceReserved()
	
