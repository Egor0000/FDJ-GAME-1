extends Node

const Player = preload("res://Player.tscn")
const Exit = preload("res://ExitDoor.tscn")
const Obj = preload("res://Object.tscn")

var borders = Rect2(1, 1, 38, 21)
var player

@onready var tileMap = $TileMap

func _ready():
	randomize()
	generate_level()

func generate_level():
	var walker = Walker.new(Vector2(19, 11), borders)
	var map = walker.walk(200)
	
	player = Player.instantiate()
	add_child(player)
	player.position = map.front()*32
	
	print("Player pos", player.position)
	
	var exit = Exit.instantiate()
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
	
	player.set_total_objects(get_tree().get_nodes_in_group("objects"))
	
	walker.queue_free()
	for location in map:
		tileMap.set_cell(0, location, 0, Vector2(7, 6))
	#tileMap.set_cells_terrain_connect(0, borders)

func reload_level():
	get_tree().reload_current_scene()

func destroy_room_obj(obj):
	obj.queue_free()


func _input(event):

	if event.is_action_pressed("ui_accept"):
		reload_level()
		


