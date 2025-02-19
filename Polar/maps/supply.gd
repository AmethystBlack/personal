extends Sprite2D

@onready var progress = $ProgressBar

@export var duration = 10
enum RESOURCE { FOOD , PARTS , MEDS}
@export var resourceType: RESOURCE

var harvesting = false
var timeElapsed = 0

func _ready():
	progress.visible = false
	
func _process(delta):
	if harvesting == true:
		processHarvest(delta)

func _on_area_2d_area_entered(area: Area2D) -> void:
	var gatherer = (area.get_parent().name)
	var matches = isCorrectGatherer(gatherer)
	if matches == true:
		startHarvest()
	
func _on_area_2d_area_exited(area: Area2D) -> void:
	stopHarvest()

func startHarvest():
	progress.visible = true
	harvesting = true

func stopHarvest():
	harvesting = false
	
func processHarvest(delta):
	timeElapsed += delta
	var percent = timeElapsed / duration
	progress.value = (percent * 100)
	if progress.value == 100:
		completeHarvest()
		
func completeHarvest():
	harvesting = false
	h.wait(1)
	queue_free()

func isCorrectGatherer(gatherer):
	print(gatherer)
	match resourceType:
		RESOURCE.FOOD:
			if gatherer == "North":
				return true
		RESOURCE.PARTS:
			if gatherer == "Maerunn":
				return true
		RESOURCE.MEDS:
			if gatherer == "Aurisch":
				return true
	return false
