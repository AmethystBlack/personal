extends Map

func interactList(targetEvent):
	match targetEvent:
		"north":
			await h.tx("tell me this just works")
			await h.stx("this too pls")
			await h.stx("also this hi im really talking a lot")
			await h.stx("sorry it's not my fault the programmer just needs me to never shut up, so lets get that lorem ipsum girlfriend!")
