extends Node

const Player = preload("res://Player.tscn")
const Exit = preload("res://ExitDoor.tscn")
const Obj = preload("res://Object.tscn")

var borders = Rect2(1, 1, 38, 21)


onready var tileMap = $TileMap

func _ready():
	randomize()
	generate_level()

func generate_level():
	var walker = Walker.new(Vector2(19, 11), borders)
	var map = walker.walk(200)
	
	var player = Player.instance()
	add_child(player)
	player.position = map.front()*32
	
	print("Player pos", player.position)
	
	var exit = Exit.instance()
	add_child(exit)
	exit.position = walker.get_end_room().position*32
	exit.connect("leaving_level", self, "reload_level")
	
	# add objects
	for room in walker.rooms:
		if room.objs.size() > 0 and room.position*32 != exit.position:
			var room_obj = Obj.instance()
			add_child(room_obj)
			room_obj.position =room.position*32
			var obj
			room_obj.connect("destroy_object", self, "destroy_room_obj")

	
	walker.queue_free()
	for location in map:
		tileMap.set_cellv(location, -1)
	tileMap.update_bitmask_region(borders.position, borders.end)

func reload_level():
	get_tree().reload_current_scene()

func destroy_room_obj(obj):
	obj.queue_free()
	print("Destroy obj ", obj)
	pass

func _input(event):

	if event.is_action_pressed("ui_accept"):
		print("HELLO")
		reload_level()
		


