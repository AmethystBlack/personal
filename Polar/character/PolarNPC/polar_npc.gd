@tool
extends Actor
class_name PolarNPC

func _ready():
	super._ready()
	if not Engine.is_editor_hint():
		h.Party.append(self)

func _input(event):
	if h.HUD.isFree():
		if mousedOver == true:
			if event is InputEventMouseButton && event.pressed == true:
				h.HUD.selectCharacter(self)
