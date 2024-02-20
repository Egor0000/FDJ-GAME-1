extends CharacterBody2D


const MAX_HEALTH=100
const MAX_XP=100
const MAX_LEVEL=5

var health = 100
var xp = 0
var level = 0;

var total_objects
var current_objects

func _ready():
	pass


func _physics_process(delta):
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var y_input = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	set_velocity(Vector2(x_input, y_input)*100)
	move_and_slide()
	
	
func set_total_objects(total_objects):
	self.total_objects = total_objects

func set_current_objects(current_objects):
	$Goal.display_goal(current_objects, total_objects)
	self.current_objects = current_objects 
	

func change_health(health):
	EventBus.change_health.emit(health)

func change_xp(xp):
	EventBus.change_health.emit(xp)
	
func change_level(level):
	EventBus.change_health.emit(level)
