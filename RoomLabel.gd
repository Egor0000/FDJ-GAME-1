extends Label

const roomText = "Room: {room}"

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("room_level_changed", display_room)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func display_room(room):
	print("HEHHEH", room)
	text = roomText.format({"room": str(room)})
