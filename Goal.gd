extends Label

const scoreText = "Objects remained: {current}/{total}"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func display_goal(current, total):
	text = scoreText.format({"current": str(total - current), "total" : str(total)})

	if (total - current == total):
		print("GOAL, ACHIVED")
		EventBus.goal_achived.emit()
