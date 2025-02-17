extends CanvasLayer

var dialog = preload("res://UI/dialog.tscn")
var smallDialog = preload("res://UI/smallDialog.tscn")

@onready var healthUi = $HealthUI
@onready var screenAnim = $ScreenFade/AnimationPlayer

enum hudState {
	OPEN,
	DIALOG	
}
var controlState = hudState.OPEN
var lastSpeaker = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fadeIn(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func canControl():
	if controlState == hudState.OPEN:
		return true
	else:
		return false

func tx(text):
	controlState = hudState.DIALOG
	var diaObj = dialog.instantiate()
	diaObj.text = text
	add_child(diaObj)
	await diaObj.dialogue_ended

func stx(text,speaker = null):
	#controlState = hudState.DIALOG
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
	controlState = hudState.OPEN

func fadeIn(duration: float = 1):
		var speed = (1 / duration)
		screenAnim.speed_scale = speed
		screenAnim.play("FadeIn")
		await screenAnim.animation_finished
		
func fadeOut(duration: float = 1):
		var speed = (1 / duration)
		screenAnim.speed_scale = speed
		screenAnim.play("FadeOut")
		await screenAnim.animation_finished
