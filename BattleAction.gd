extends MarginContainer

@export var button_name = "Button"
@export var description = "ButtonDescription"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.text = button_name
	$Button.add_to_group("action_buttons")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_button_up():
	EventBus.changed_enemy_health.emit(-10)
	EventBus.changed_turn.emit()
