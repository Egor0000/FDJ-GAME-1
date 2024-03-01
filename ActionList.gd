extends HBoxContainer

const Action = preload("res://BattleAction.tscn")


var sorted_by_level = {}
var random_actions = []
@export var probabilities = [[0, 8], [8, 31], [31, 61], [61, 101]]

# Called when the node enters the scene tree for the first time.
func _ready():
	# put probabilites as exported variable
	sorted_by_level = get_sorted_by_level()
	generate_new_actions(probabilities)

func _input(event):
	if event is InputEventKey:
		if  event.pressed and event.keycode == 66: # Key B	
			var act = Action.instantiate()
			add_child(act)
			#exit.position = walker.get_end_room().position*32
			#exit.connect("leaving_level", Callable(self, "reload_level"))
			print(event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func build_random_action_list(probabilites):
	var random_list = []
	while (random_list.size() < 3):
		var random_level = str(get_random_level(probabilites))
		if sorted_by_level.has(random_level) and sorted_by_level[random_level].size() > 0:
			var rdx = randi() % sorted_by_level[random_level].size()
			random_list.append(sorted_by_level[random_level][rdx])
	
	return random_list

# TODO move to a separate component
# probabilites will be an array[4] of probabilites for each of 4 levels: [(0, 8), (8, 31), (31, 61), (61, 101)]
func get_random_level(probabilites):
	var randm = randi() % 100 + 1

	for rng_idx in range(probabilites.size()):
		if randm >= probabilites[rng_idx][0] and randm < probabilites[rng_idx][1]:
			return probabilites.size() - rng_idx
	return -1


func get_sorted_by_level():
	var sorted = {}
	
	for id in GlobalGameData.unlocked_actions:
		var action = get_action_by_id(id)
		if action != null:
			var level = str(action["level"])
			if (sorted.has(level)):
				sorted[level].append(id)
			else:
				sorted[level] = [id]
		
	
	return sorted

func get_action_by_id(id):
	for action in GlobalGameData.all_actions:
		if action["id"] == id:
			return action
	return null

func add_new_action(action_id):
	var action = get_action_by_id(action_id)
	if (action != null):
		var act = Action.instantiate()
		act.button_name = action.name
		act.button_stats = action.stats
		add_child(act)
		
func generate_new_actions(probabilities):
	random_actions = build_random_action_list(probabilities)
	for action in random_actions:
		add_new_action(action)

func reload_actions():
	for node in self.get_children():
		node.queue_free()
		
	generate_new_actions(self.probabilities)
