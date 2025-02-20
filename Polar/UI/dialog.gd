extends Control

var smallDialogue = false
var speaker = null

@onready var text_obj = get_node("%Text")
@onready var name_box = $NameBox
@onready var name_text = get_node_or_null("%NameText")
@onready var timer = get_node_or_null(^"Timer")

var fullyTyped = false
var textTween = null

@onready var text : String = "" :
	set (value):
		if not text_obj:
			await ready
		var parsedText = parseText(value)
		text_obj.text = parsedText
		if smallDialogue == true:
			text_obj.text = "[center]" + value + "[/center]"
			smallSizing()
		typeText()
		
		
signal dialogue_ended
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if smallDialogue != true:
		setPosition()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if smallDialogue != true:
		if Input.is_action_just_pressed("attack"):
			if fullyTyped == true:
				nextDialog()
			else:
				rushText()

func setPosition():
	size.x = 360
	size.y = 120
	
	anchor_left = 0
	anchor_right = 0
	anchor_top = 1
	anchor_bottom = 1
	position.y -= size.y
	
	text_obj.visible_ratio = 0
	
func smallSizing(): #this was weirdly fuck. also it needs to be centered to behave t all
	anchor_left = 0.5
	anchor_right = 0.5
	anchor_top = 0.5
	anchor_bottom = 0.5
	
	var contentWidth = (text_obj.get_content_width())
	size.x = (clamp(contentWidth, 0, 3300)) + 24
	size.y = (text_obj.get_content_height() + 24)

	await positionSmallText()
	
	text_obj.visible_ratio = 0
	
func parseText(text: String):
	if(text.begins_with("[")):
		var splitText = text.split("]", false, 1)
		var speaker = splitText[0]
		text = splitText[1]
		speaker = speaker.lstrip("[")
		text = text.lstrip(" ")
		if(speaker == ""):
			speaker = h.HUD.lastSpeaker
		if(speaker != ""):
			setName(speaker)
	return text
	
func setName(speaker):
	speaker = speaker.capitalize()
	name_text.text = speaker
	h.HUD.lastSpeaker = speaker
	name_box.visible = true

func typeText():
	visible = true
	var parsedText = text_obj.get_parsed_text()
	var speed = parsedText.length() * 0.02
	textTween = get_tree().create_tween()
	textTween.connect("finished", textFullyTyped)
	textTween.tween_property(text_obj, "visible_ratio", 1.0, speed)
	if(smallDialogue == true):
		textTween.tween_callback(timer.start.bind(((speed * 2) + 1)))
	
	
func nextDialog():
	h.HUD.freeControls()
	closeDialog()
	
func closeDialog():
	self.queue_free()
	dialogue_ended.emit()
	
func positionSmallText():
	if(speaker == null):
		position.x = (get_viewport_rect().size.x - size.x) -1
		position.y = 1
	else:
		position.x = -((size.x) / 2)
		position.y = -((size.y) + 24)
		
func textFullyTyped():
	fullyTyped = true
	
func rushText():
	textTween.kill()
	text_obj.visible_ratio = 1
	fullyTyped = true
	
# group dialogues
	#
	#var bigString = ("
	#test text goes here
	#test a second line
	#") 
	#var array = bigString.rsplit("\n",false)
	#print(array)


func _on_timer_timeout() -> void:
	closeDialog()
