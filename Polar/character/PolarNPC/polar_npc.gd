@tool
extends Actor
class_name PolarNPC

func _ready():
	super._ready()
	if not Engine.is_editor_hint():
		h.Party.append(self)
