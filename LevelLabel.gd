extends Label

const levelText = "lvl: {lvl}"
var lvl = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("changed_xp_level", change_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_level():
	lvl+=1
	text = levelText.format({"lvl": str(lvl)})
