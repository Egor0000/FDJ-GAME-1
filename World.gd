extends Node

const Player = preload("res://Player.tscn")
const Exit = preload("res://ExitDoor.tscn")
const Obj = preload("res://Object.tscn")


var borders = Rect2(1, 1, 38, 21)
var player
var exit 

var level = 1

@onready var tileMap = $TileMap

func _ready():
	EventBus.connect("player_died", on_player_died)
	
	get_node("Player").queue_free()
	get_node("Object").remove_from_group("objects")
	get_node("Object").queue_free()
	randomize()
	
	player = Player.instantiate()
	add_child(player)

	generate_level()

func generate_level():

	EventBus.room_level_changed.emit(level)
	
	var walker = Walker.new(Vector2(19, 11), borders)
	var map = walker.walk(200)
	
	player.position = map.front()*32
	
	exit = Exit.instantiate()
	add_child(exit)
	exit.position = walker.get_end_room().position*32
	exit.connect("leaving_level", Callable(self, "reload_level"))
	
	# add objects
	var created_positions = {}
	
	for room in walker.rooms:
		if room.objs.size() > 0 and room.position*32 != exit.position:
			var room_obj = Obj.instantiate()
			room_obj.position = room.position*32
			if (created_positions.has(room_obj.position)):
				continue
			created_positions[room_obj.position] = null
			add_child(room_obj)			
			room_obj.connect("destroy_object", Callable(self, "destroy_room_obj"))
	
	
	player.set_total_objects(get_tree().get_nodes_in_group("objects").size())

	player.set_current_objects(get_tree().get_nodes_in_group("objects").size())
	
	walker.queue_free()
	for location in map:
		tileMap.set_cell(0, location, 0, Vector2(7, 6))
	#tileMap.set_cells_terrain_connect(0, borders)


func reload_level():
	level+=1
	
	if (get_node("ExitDoor") != null):
		get_node("ExitDoor").queue_free()
	
	exit.queue_free()

	for nodes in get_tree().get_nodes_in_group("objects"):
		nodes.call_deferred("remove_from_group", "objects")
	

	player.set_current_objects(get_tree().get_nodes_in_group("objects").size())
		
	self.call_deferred("generate_level")
	#get_tree().reload_current_scene()

func destroy_room_obj(obj):
	obj.queue_free()
	obj.remove_from_group("objects")
	player.set_current_objects(get_tree().get_nodes_in_group("objects").size())

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			for nodes in get_tree().get_nodes_in_group("objects"):
				destroy_room_obj(nodes)
	pass
		

func on_player_died():
	get_tree().reload_current_scene()

