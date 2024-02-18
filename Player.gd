extends CharacterBody2D

var total_objects
var current_objects

func _ready():
	print("", $Camera2D.is_current())
	$Camera2D.make_current()
	print("", $Camera2D.is_current())


func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	set_velocity(Vector2(x_input, y_input)*100)
	move_and_slide()
	
	
func set_total_objects(total_objects):
	self.total_objects = total_objects

func set_current_objects(current_objects):
	self.current_objects = current_objects 
