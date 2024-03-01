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
	#EventBus.connect("changed_player_health_b", on_player_health_b_changed)
	EventBus.connect("changed_player_health_b", on_enemy_attack)
	EventBus.connect("changed_player_attack_b", on_player_attack_b_changed)
	EventBus.connect("changed_player_defence_b", on_player_defence_b_changed)
	EventBus.connect("changed_battle_scene", on_battle_scene_changed)
	EventBus.connect("player_hit", on_player_hit)
	EventBus.connect("player_actions", on_player_actions)
	EventBus.connect("changed_xp_level", on_level_up)

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
		
		print_debug("", self.health_b)

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
	EventBus.changed_hp.emit(health)

func change_xp(xp):
	EventBus.change_health.emit(xp)

func change_level(level):
	EventBus.change_health.emit(level)

# On enemy attacks 
func on_enemy_attack(enemyAttack):
	var dmgMultiplier =1 - float(get_defence()) / float(enemyAttack + get_defence())
	var dmg = enemyAttack * dmgMultiplier
	on_player_health_b_changed(-ceil(dmg))

func get_defence():
	return defence

# stats mean modifers actioned by player
# modifiers: damage, defence, attack, health, defence_enemy, attack_enemy
# for each modifer, player changes players/enemies stats
func on_player_actions(stats):
	var modifiers = stats.keys()
	
	for modifier in stats:
		if modifier == "damage":
			var attackMult = 1.0 + (float)(attack_b / 100.0)
			print_debug("", attackMult)
			EventBus.player_attacks.emit(attackMult*stats[modifier])
		elif modifier == "defence":
			defence_b += stats[modifier]
			print_debug("", defence_b)
			EventBus.changed_player_stats.emit(["defence", self.defence_b])
		elif modifier == "attack":
			attack_b += stats[modifier]
			print_debug("", attack_b)
			EventBus.changed_player_stats.emit(["attack", self.attack_b])

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
	
func on_level_up():
	EventBus.changed_hp.emit(MAX_HEALTH-self.health)
	self.health = MAX_HEALTH
	
	var next_action =  get_new_unlocked()
	GlobalGameData.unlocked_actions.append(next_action)
	EventBus.print_level_up.emit("New action unlocked: " + get_action_by_id(next_action).name)
	pass

func get_new_unlocked()	-> int:
	var next_action = -1
	var sorted_by_level = get_sorted_by_level()
	
	while (next_action < 0):
		var random_level = get_random_level(GlobalGameData.unlock_probabilities)
		if sorted_by_level.has(str(random_level)) and sorted_by_level[str(random_level)].size() > 0:
			var rdx = randi() % sorted_by_level[str(random_level)].size()

			if (!GlobalGameData.unlocked_actions.has(sorted_by_level[str(random_level)][rdx])):
				next_action = sorted_by_level[str(random_level)][rdx]
	
	return next_action


#TODO move to a separate component
# probabilites will be an array[4] of probabilites for each of 4 levels: [(0, 8), (8, 31), (31, 61), (61, 101)]
func get_random_level(probabilites) -> int:
	var randm = randi() % 100 + 1

	for rng_idx in range(probabilites.size()):
		if randm >= probabilites[rng_idx][0] and randm < probabilites[rng_idx][1]:
			return probabilites.size() - rng_idx
	return -1


func get_sorted_by_level():
	var sorted = {}
	
	for action in GlobalGameData.all_actions:
		if action != null:
			var level = str(action["level"])
			if (sorted.has(level)):
				sorted[level].append(action["id"])
			else:
				sorted[level] = [action["id"]]
	
	return sorted

func get_action_by_id(id):
	for action in GlobalGameData.all_actions:
		if str(action["id"]) == str(id):
			return action
	return null
