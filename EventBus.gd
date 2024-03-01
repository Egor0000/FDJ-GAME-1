extends Node

#General
signal goal_achived
signal room_level_changed(room)
signal changed_turn # used in battles to change between player and enemy turn
signal changed_battle_scene(isBattleScene) # used to detect battle scene switching 

signal changed_hp(health)
signal changed_xp(xp)
signal changed_xp_level
signal print_level_up(message)

signal no_hp
signal player_died

# Enemy
signal changed_enemy_attack(deltaAttack)
signal changed_enemy_defence(deltaDefance)
signal changed_enemy_health(deltaHealth)
signal enemy_dies(reward)
signal enemy_hit()

# Player in Battle
signal changed_player_attack_b(deltaAttack)
signal changed_player_defence_b(deltaDefance)
signal changed_player_health_b(attack) # signal triggered when enemy attacks player,
signal player_attacks(attack) # signal triggered when player attack enemy
signal player_actions(active_stats) # signal triggered when action button is pressed. Signal listened by player
#signal player_dies()
signal player_hit()

# Player Stats in Battle
signal changed_player_stats(args)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
