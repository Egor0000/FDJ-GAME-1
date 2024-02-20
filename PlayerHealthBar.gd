extends ProgressBar


const MAX_HP = 100

var hp = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("changed_hp", change_hp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func change_hp(hp):
	self.hp = hp
	
	value = self.hp
	
	if (self.hp<=0):
		EventBus.no_hp.emit()

		
