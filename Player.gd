extends CharacterBody2D


const MAX_HEALTH=100
const MAX_XP=100
const MAX_LEVEL=5

var health = 100
var xp = 0
var level = 0;
var attack = 10;
var defence = 10;

var total_objects
var current_objects

var health_b = health
var attack_b = attack
var defence_b = defence

var battleScene = false
var died = false

func _ready():
	EventBus.connect("no_hp", on_no_hp)
	EventBus.connect("changed_player_health_b", on_player_health_b_changed)
	EventBus.connect("changed_player_attack_b", on_player_attack_b_changed)
	EventBus.connect("changed_player_defence_b", on_player_defence_b_changed)
	EventBus.connect("changed_battle_scene", on_battle_scene_changed)
	EventBus.connect("player_hit", on_player_hit)

	
func on_player_health_b_changed(deltaHp):
	self.health_b += deltaHp
	self.health = self.health_b
	EventBus.changed_player_stats.emit(["health", self.health_b])
	change_health(deltaHp)
	pass

func on_player_attack_b_changed(deltaAtatck):
	pass

func on_player_defence_b_changed(deltaDefence):
	pass

func on_battle_scene_changed(isBattleScene):
	print("CHANGED SCENE", isBattleScene)
	battleScene = isBattleScene
	if (isBattleScene):

		health_b = health
		attack_b = attack
		defence_b = defence
		
		EventBus.changed_player_stats.emit(["health", self.health_b])
		EventBus.changed_player_stats.emit(["attack", self.attack_b])
		EventBus.changed_player_stats.emit(["defence", self.defence_b])
	else:
		health = health_b
		change_health(health)
	
func on_player_hit():
	pass
	
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == 75:
			change_health(-50)
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
	print("GEALTH ", health)	
	EventBus.changed_hp.emit(health)

func change_xp(xp):
	EventBus.change_health.emit(xp)
	
func change_level(level):
	EventBus.change_health.emit(level)
	
	
func on_no_hp():
	print("KILLED", battleScene)
	# TODO VERY VERY VERY BAD !!!! Added as an workaround. SHould investigate why it is called twice and fix
	if (died):
		return
	died = true
	if (battleScene):
		print("dnewldnj")
		EventBus.changed_battle_scene.emit(!battleScene)
	$AnimationPlayer.play("player_died")
	await $AnimationPlayer.animation_finished
	EventBus.player_died.emit()
