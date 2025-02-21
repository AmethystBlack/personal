@tool
extends Actor
class_name PolarNPC

var directable = true

func _ready():
	super._ready()
	if not Engine.is_editor_hint():
		h.Party.append(self)

func _input(event):
	if h.HUD.canControl():
		if mousedOver == true:
			if event is InputEventMouseButton && event.pressed == true:
				h.HUD.selectCharacter(self)
