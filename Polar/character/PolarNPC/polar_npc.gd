@tool
extends Actor
class_name PolarNPC

func _ready():
	super._ready()
	h.Party.append(self)
