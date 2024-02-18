extends StaticBody2D

const MAX_HEALTH = 3

var entered = false
var health = MAX_HEALTH

signal destroy_object(obj)



func _ready():
	add_to_group("objects")

	$ProgressBar.max_value = MAX_HEALTH
	$ProgressBar.value = MAX_HEALTH


func _on_Object_mouse_entered():
	print("mouse entered")

func _on_Area2D_body_entered(body):
	entered = true
	pass # Replace with function body.


func _on_Area2D_body_exited(body):
	entered = false
	

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_space") && entered:
#			
			health -=1
			update_health_bar(health)
			if (health <=0):
				emit_signal("destroy_object", self)


func update_health_bar(val):
	$ProgressBar.value = val
	
