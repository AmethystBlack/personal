extends Map

@onready var Allia = $ObjectPlane/Actors/Allia
@onready var Jadd = $ObjectPlane/Actors/Jadd
@onready var Evristt = $ObjectPlane/Actors/Evristt
@onready var Flaw = $ObjectPlane/Actors/Flaw
@onready var Kie = $ObjectPlane/Actors/Kie
@onready var Brite = $ObjectPlane/Actors/Brite
@onready var Lee = $ObjectPlane/Actors/Lee
@onready var Aurisch = $ObjectPlane/Actors/Aurisch
@onready var North = $ObjectPlane/Actors/North
@onready var Maudritt = $ObjectPlane/Actors/Maudritt
@onready var Maerunn = $ObjectPlane/Actors/Maerunn




func interactList(targetEvent):
	var this = h.actors[targetEvent]
	match targetEvent:
		"maudritt":
			await h.tx("[MAUDRITT] hingus bingus i'm an old dingus")
			await h.tx("this has no name tag for some reason")
			await h.tx("[NORTH] this one does tho")
			await h.tx("[] and let's try this too")
		"north":
			await h.tx("tell me this just works, ah gosh i really need to write a lot of text don't i and isn't there any way to disable word wrap in the edit,r this is kind of annoying!! actually it's really annoying how the heck is this supposed to work")
			await h.stx("um?", this)
			await h.stx("also this hi im really talking a lot")
			await h.stx("sorry it's not my fault the programmer just needs me to never shut up, so lets get that lorem ipsum girlfriend!", h.actors["player"])
		"kie":
			h.HUD.fadeOut(2)
			await h.wait(1)
			h.HUD.fadeIn(2)
			await h.stx("um?", this)
		"jadd":
			h.EnsembleDirectable(true)	
		"allia":
			h.EnsembleDirectable(false)
			
func introScene():
	
			
			h.changeGameState(h.game.SCENE)
	
			await Evristt.moveTo(242,251)
			await h.tx("[EVRISTT] Grab a chair or something-- block the door!")
			Flaw.faceChar(Evristt)
			Aurisch.faceChar(Evristt)
			h.stx("Here!", Kie)
			await Kie.moveTo(225,245)
			Kie.faceDown()
			await Evristt.moveTo(241,301)
			Evristt.faceCharacter(Jadd)
			await h.wait(0.3)
			await h.tx("[EVRISTT] You two-- make sure it stays shut!")
			Jadd.moveTo(251,301)
			h.stx("On it!", Jadd)
			Allia.faceChar(Jadd)
			await h.wait(0.3)
			h.stx("Don't get yourself hurt!", Allia)
			Aurisch.faceChar(Lee)
			await h.wait(2)
			await Evristt.moveTo(211,256)
			Brite.faceLeft()
			await h.tx("[BRITE] No can do, kiddo; I've gotta record this.")
			await h.wait(0.4)
			Evristt.faceCharacter(Brite)
			Brite.faceRight()
			h.stx("You guys WON'T believe this, but right now we are running for our lives...", Brite)
			await h.wait(3)
			Maudritt.faceCharacter(Brite)
			Maudritt.stx("Disobeying orders, son?")
			await h.wait(0.6)
			Evristt.stx("The hell's your problem?")
			await h.wait(2)
			Flaw.stx("I'll help!")
			await Flaw.moveTo(231,301)
			Maerunn.faceChar(Evristt)
			await h.tx("[MAERUNN] Evristt, Lee's injured! They're bleeding bad!")
			Evristt.faceChar(Lee)
			North.faceChar(Lee)
			Lee.runInPlace()
			await h.tx("[LEE] It's okay-- I can still... Ow!")
			Maudritt.faceCharacter(Lee)
			Maerunn.faceChar(Lee)
			Lee.idleInPlace()
			Aurisch.faceChar(Lee)
			await h.tx("[AURISCH] No, in fact, you can't. That wound needs to be cleaned and bandaged.")
			await h.tx("[AURISCH] And even if you could, that trail of blood you're leaving would give us away anywhere we hide.")
			await h.tx("[NORTH] This is a gift shop, right? Maybe there's something around here we can use?")
			await h.tx("[EVRISTT] Let's fleece the place, stat. If that guy was telling the truth about there being no other train, we're going to need all the supplies we can get.")
			Maudritt.faceCharacter(Evristt)
			await h.tx("[MAUDRITT] If I may, son? You've got a cpororal's resolve, but even the best leader in the world won't get a damn thing done without the cooperation of his troops.")
			await h.tx("[MAUDRITT] If we aim to get out of this alive, the rest of us had better be prepared to take orders to the letter.")
			Maudritt.faceCharacter(Brite)
			await h.tx("[MAUDRITT] That includes you, hotshot.")
			Brite.faceCharacter(Maudritt)
			Brite.stx("Yeah, yeah, whatever you say. Old coot.")
			await h.wait(2)
			Maudritt.faceCharacter(Evristt)
			await h.tx("[MAUDRITT] That settles it, then. You call the shots, and we'll take them.")
			await h.tx("[EVRISTT] First and foremost, we need to treat that wound.")
			await h.tx("[EVRISTT] You-- You mentioned bandaging it; can you take care of it?")
			Aurisch.faceChar(Evristt)
			await h.tx("[AURISCH] The name is Aurisch. I'm a pragmatist, not a doctor, but I can improvise as well as anyone.")
			# tutorial here
			Allia.faceChar(Brite)
			await h.tx("[ALLIA] Hey, you're on some kind of broadcast, aren't you? Can't you call for help?")
			await h.tx("[BRITE] Negative, lady. I'm not live, just getting footage for my crew to edit. Ever since the storm hit, my signal's been totally out.")
			await h.tx("[LEE] Circumpolar storms... are geomagnetic. Satellite connections won't work...")
			Maerunn.faceChar(Lee)
			Maerunn.stx("Lee, save your strength.")
			await h.tx("[EVRISTT] So we can't call for help, and there's no telling how long the storm is going to last.")
			await h.tx("[EVRISTT] We'd better get as much food as we can and find a place to wait it out.")
			Maerunn.faceChar(Evristt)
			await h.tx("[MAERUNN] This shop has a good number of things, but whatever we don't take right away those men will probably snatch up.")
			await h.tx("[NORTH] If no one minds, I can take care of the food? I'm not a half-bad coo, and I have some experience getting creative to stretch a little bit out for a long while.")			
			await h.tx("[EVRISTT] Sold. Your name, by the way?")
			North.stx("It's North!")
			#north tutorial
			await h.tx("[KIE] Hey, I grabbed one of those bots on the way out because I thought maybe we could save it... Do you think it would be useful at all?")
			await h.tx("[MAERUNN] Let me take a look at it. I don't think we'll be getting it operational again, but some of the parts might be useful.")
			await h.tx("[EVRISTT] Mae's a genius engineer. You did good, kid.")
			await h.tx("[MAERUNN] Well, I wouldn't say that... but leave any tech to me.")
			# mae tutorial
			await h.tx("[EVRISTT] Okay, so we just need to find somewhere to lay low until the storm blows over and we can call for help.")
			await h.tx("[MAUDRITT] Loathe as I am to say it, you kids oughta leave me and find your own way. As I am, I'm more of a liability than anything.")
			await h.tx("[EVRISTT] Not a chance. I'm getting you all out of here alive.")
			await h.tx("[NORTH] You don't have to be a liability if you just let others help you move!")
			Maudritt.stx("Bah...")
			h.wait(1)
			await h.tx("[EVRISTT] Sir-- Sorry, I didn't get your name?")
			await h.tx("[MAUDRITT] Private Maudritt Goravesca, at your service... for what little that's worth.")
			await h.tx("[EVRISTT] Maudritt, you said we all need to be prepared to follow orders. Did that exclude you?")
			await h.tx("[MAUDRITT] Well... no.")
			await h.tx("[EVRISTT] Then I'm ordering you to get out of here with the rest of us. That means if I say someone helps you, someone helps you. Got it?")
			Maudritt.stx("Hah! Spoken like a true sargeant.")
			h.wait(2)
			await h.tx("[AURISCH] I've got this girl's leg cleaned up, but she'll need help moving too.")
			Lee.stx("I'm... not...")
			h.wait(1)
			Maerunn.faceChar("Aurisch")
			await h.tx("[MAERUNN] Lee isn't a girl, Mr. Aurisch, nor a boy. Think of them as just a person first and foremost.")
			Aurisch.stx("How nice.")
			h.wait(1)
			await h.tx("[BRITE] Ugh, tell me I'm not stuck here with a bunch of delusional gender revisionists...")
			await h.tx("[FLAW] Do we have to do this now?! We can't hold them here forever!")
			await h.tx("[KIE] Hey, can we tie the door shut with this?")
			await h.tx("[EVRISTT] The Arlitican Museum of Atmospheric Study and Circumpolar Science... Commemorative Jump Rope Set. Of course.")
			await h.tx("[EVRISTT] It's better than nothing. Flaw!")
			h.wait(0.5)
			Flaw.stx("Got it!")
			h.wait(1)
			Maerunn.faceLeft()
			await h.tx("[MAERUNN] Wait, what's that outside?")
			await h.tx("[ALLIA] Oh my God, they're just trudging through the storm?!")
			await h.tx("[AURISCH] Get away from the windows!")
			# glass breaks, several enter
			Lee.stx("Ah-- Ah-ah-ah, cold!!!")
			h.wait(0.5)
			Maerunn.stx("Lee!")
			await h.tx("[EVRISTT] Everyone stay away from the cold and get to safety! I'll act as decoy!")
			
			h.wait(3)
			await h.stx("[AURISCH] There's still more supplies here.")
			await h.stx("[AURISCH] Is the time it takes us to collect them worth the risk? The call is yours.")
			h.wait(3)
			await h.stx("[MAERUNN] Don't be a hero, Evristt!")
			await h.stx("[MAERUNN] You can buy us time, but you saw that train-- There might as well be no end to those guys!")
			
			h.gameState = h.lastState
				
			
