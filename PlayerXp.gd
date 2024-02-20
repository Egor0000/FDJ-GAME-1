extends ProgressBar

const MAX_XP = 100

var xp = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("changed_xp", change_xp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func change_xp(xp):
	var oldXp = self.xp;
	var newXp = self.xp + xp
	
	if newXp >= MAX_XP:
		print("XXXXXXXX")
		EventBus.changed_xp_level.emit()
		
	self.xp = newXp % MAX_XP
	value = self.xp
		
	
