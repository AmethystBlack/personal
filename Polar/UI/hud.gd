extends CanvasLayer

var dialog = preload("res://UI/dialog.tscn")
var smallDialog = preload("res://UI/smallDialog.tscn")

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

func stx(text,speaker = null):
	#controlState = HUD.DIALOG
	var diaObj = smallDialog.instantiate()
	diaObj.smallDialogue = true
	diaObj.text = text
	if speaker != null:
		diaObj.speaker = speaker
		speaker.add_child(diaObj)
	else:
		add_child(diaObj)
	await diaObj.dialogue_ended

func freeControls():
	controlState = HUD.OPEN
