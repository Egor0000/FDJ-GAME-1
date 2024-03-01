extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel.hide()
	EventBus.connect("print_level_up", on_level_up);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_level_up(message):
	$Panel.show()
	var timer = Timer.new()
	add_child(timer)
	timer.set_one_shot(true)
	timer.timeout.connect(on_timeout)  # Connect to your "on_timeout" function
	timer.start(2.0)
	$Panel/VBoxContainer/InfoLabel.text = message

func _on_timer_timeout():
	pass # Replace with function body.
	
func on_timeout():
	$Panel.hide()
