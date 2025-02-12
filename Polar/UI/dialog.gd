extends Control

@onready var text_obj = $Text

@onready var text : String = "" :
	set (value):
		if not text_obj:
			await ready
		text_obj.text = value
		
signal dialogue_ended
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_obj.visible_ratio = 0
	typeText()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		nextDialog()

func typeText():
	var textTween = get_tree().create_tween()
	var speed = text_obj.text.length() * 0.02
	textTween.tween_property(text_obj, "visible_ratio", 1.0, speed)

func nextDialog():
	closeDialog()
	
func closeDialog():
	self.queue_free()
	h.HUD.freeControls()
	dialogue_ended.emit()


# group dialogues
	#
	#var bigString = ("
	#test text goes here
	#test a second line
	#") 
	#var array = bigString.rsplit("\n",false)
	#print(array)
