extends Control

var smallDialogue = false

@onready var nine = $NinePatchRect
@onready var margin = $NinePatchRect/MarginContainer

@onready var text_obj = get_node("%Text")

@onready var text : String = "" :
	set (value):
		if not text_obj:
			await ready
		text_obj.text = value
		if smallDialogue == true:
			smallSizing()
		
signal dialogue_ended
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#text_obj.visible_ratio = 0
	setPosition()
	typeText()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		nextDialog()

func setPosition():
	size.x = 360
	size.y = 120
	anchor_left = 0
	anchor_right = 0
	anchor_top = 1
	anchor_bottom = 1
	position.y -= size.y
	
func smallSizing():
	print (text_obj.get_content_width())
	print (text_obj.get_content_height())
	print (text_obj.get_line_count())
	size.x = (text_obj.get_content_width() +24)
	size.y = (text_obj.get_content_height() + 24)
	anchor_left = 0.5
	anchor_right = 0.5
	anchor_top = 0.5
	anchor_bottom = 0.5
	nine.position.y -= (size.y / 2)
	nine.position.x -= (size.x / 2)

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
