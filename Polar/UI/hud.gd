extends CanvasLayer

var dialog = preload("res://UI/dialog.tscn")

@onready var healthUi = $HealthUI

enum HUD {
	OPEN,
	DIALOG	
}
var controlState = HUD.OPEN

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func canControl():
	if controlState == HUD.OPEN:
		return true
	else:
		return false

func tx(text):
	controlState = HUD.DIALOG
	var diaObj = dialog.instantiate()
	diaObj.text = text
	add_child(diaObj)
	await diaObj.dialogue_ended

func stx(text):
	controlState = HUD.DIALOG
	var diaObj = dialog.instantiate()
	diaObj.smallDialogue = true
	diaObj.text = text
	add_child(diaObj)
	await diaObj.dialogue_ended

func freeControls():
	controlState = HUD.OPEN
