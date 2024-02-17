extends KinematicBody2D

var KEY_A = KEY_A  # Godot constant for the A key
var KEY_S = KEY_S  # Godot constant for the S key
var KEY_D = KEY_D  # Godot constant for the D key
var KEY_E = KEY_E  # Godot constant for the E key


func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	move_and_slide(Vector2(x_input, y_input)*100)
