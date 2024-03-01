extends Control

var playerTurn = true
var battleScene = true;

# TODO workaround to avoid multiple closing of scenes
var closed_scene = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.connect("changed_enemy_attack", on_enemy_attack_changed)
	EventBus.connect("changed_enemy_defence", on_enemy_defence_changed)
	EventBus.connect("changed_enemy_health", on_enemy_health_changed)
	EventBus.connect("enemy_dies", on_enemy_dies)
	EventBus.connect("enemy_hit", on_enemy_hit)
	EventBus.connect("changed_turn", on_turn_changed)
	EventBus.connect("changed_player_stats", on_player_stats_changed)
	EventBus.connect("changed_battle_scene", on_battle_scene_changed)
	EventBus.connect("player_attacks", on_player_attacks)
	
	set_enemy_panel()
	
	EventBus.changed_battle_scene.emit(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if event is InputEventKey:
		if event.keycode == 75:
			close_battle_scene()
		elif event.keycode == 78:
			EventBus.player_attacks.emit(100000)
			EventBus.changed_turn.emit()

func on_enemy_dies(reward):
	$AnimationPlayer.play("enemy_dies")
	await $AnimationPlayer.animation_finished
	take_reward(reward)
	close_battle_scene()

func on_enemy_hit():
	$AnimationPlayer.play("enemy_hit")
	await $AnimationPlayer.animation_finished
	
func on_turn_changed():
	playerTurn = !playerTurn
	var action_buttons = get_tree().get_nodes_in_group("action_buttons")
	for button in action_buttons:
		if (playerTurn):
			$ScrollContainer/ActionList.reload_actions()
			button.set_disabled(false)
		else:
			button.set_disabled(true)
			#$Enemy.action()
			$Enemy.get_action()
			
			
func on_player_stats_changed(args):
	if args[0] == "health":
		$PlayerPanel/PlayerHealthBarBattle.value = args[1]
	elif args[0] == "attack":
		$PlayerStatsPanel/AtackLabel.text = str(args[1])
	else:
		$PlayerStatsPanel/DefenceLabel.text = str(args[1])
	pass

func _on_timer_timeout():
	close_battle_scene()
	
# isBattleScene - value to be set to battle scene: false - battle scene down, true - battle scene up
func on_battle_scene_changed(isBattleScene):
	if (!isBattleScene):
		close_battle_scene()

func close_battle_scene():
	if (closed_scene):
		return
	closed_scene = true
	
	var root = get_tree().get_root()
	var current = root.get_child(root.get_child_count() - 1)
	current.call_deferred("free")
	var new_scene = GlobalGameData.PreviousScene
	get_tree().get_root().add_child(new_scene)

	get_tree().set_current_scene(new_scene)

func on_enemy_attack_changed(deltaAttack):
	var newAttack = $Enemy.change_attack(deltaAttack)
	$EnemyStatsPanel/AttackLabel.text = str(newAttack)
	
func on_enemy_defence_changed(deltaDefence):
	var newDefence = $Enemy.change_defence(deltaDefence)
	$EnemyStatsPanel/DefenceLabel.text = str(newDefence)
	
func on_enemy_health_changed(deltaHealth):
	$Enemy.change_health(deltaHealth)
	
func on_player_attacks(attack):
	$Enemy.on_player_attack(attack)
	
func set_enemy_panel():
	$EnemyStatsPanel/AttackLabel.text = str($Enemy.get_attack())
	$EnemyStatsPanel/DefenceLabel.text = str($Enemy.get_defence())
	
func take_reward(reward):
	for entry in reward:
		if entry == "player_xp":
			EventBus.changed_xp.emit(reward[entry])
	pass
