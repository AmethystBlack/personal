@tool
extends Actor
class_name PolarNPC

func _ready():
	super._ready()
	if h.Party:
		h.Party.append(self)
