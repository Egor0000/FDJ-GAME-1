extends Area2D

signal leaving_level

var exit_enabled = false

func _ready():
	EventBus.connect("goal_achived", enable_exit)

func _on_ExitDoor_body_entered(body):
	if (exit_enabled):
		emit_signal("leaving_level")
	
func enable_exit():
	exit_enabled = true
