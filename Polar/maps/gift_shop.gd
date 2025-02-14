extends Map

func interactList(targetEvent):
	var this = h.actors[targetEvent]
	match targetEvent:
		"north":
			await h.tx("tell me this just works, ah gosh i really need to write a lot of text don't i and isn't there any way to disable word wrap in the edit,r this is kind of annoying!! actually it's really annoying how the heck is this supposed to work")
			await h.stx("um?", this)
			await h.stx("also this hi im really talking a lot")
			await h.stx("sorry it's not my fault the programmer just needs me to never shut up, so lets get that lorem ipsum girlfriend!", h.actors["player"])
