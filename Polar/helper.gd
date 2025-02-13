extends Node
#
var World = null
var HUD = null
var Party = []


#@onready var World = get_tree().get_current_scene().get_node("%World")
#@onready var HUD = get_tree().get_current_scene().get_node("%HUD")
#@onready var Player = get_tree().get_current_scene().get_node("%Player")

var mapOverride = null

# just some shortcuts
var map = null
var actors = null

func tx(text): 
	await HUD.tx(text)
	
func stx(text): 
	await HUD.stx(text)

func setShortcuts():
	World = get_tree().get_current_scene().get_node("%World")
	HUD = get_tree().get_current_scene().get_node("%HUD")

func EnsembleFace():
	var destination = World.get_global_mouse_position()
	for npc in Party:
		var interval = EnembleInterval(npc)
		var tween = create_tween()
		tween.tween_interval(interval)
		tween.tween_callback(npc.facePoint.bind(destination))
			
	
func EnsembleMove():
	for npc in Party:
		var interval = EnembleInterval(npc)
		var tween = create_tween()
		tween.tween_interval(interval)
		tween.tween_callback(npc.path_to_cursor)
		
func EnembleInterval(npc):
		var init = npc.stats.roll_initiative()
		var interval = (100 - init) / 50 # this last number effectively decides the Scale of the reactions
		return interval
