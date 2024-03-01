extends Node

var PreviousScene
var all_actions = [
	{   "id": 1,
		"name": "Simple Damage",
		"description": "Damage Action",
		"stats": {
			"damage": 10 # modifiers: damage, defence, attack, health, defence_enemy, attack_enemy
		},
		"level": 1 # common - 1, rare - 2, epic - 3, legendary - 4
	},
	{   "id": 2,
		"name": "Simple Defence",
		"description": "Increase Player Defence",
		"stats": {
			"defence": 2 # modifiers: damage, defence, attack, health, defence_enemy, attack_enemy
		},
		"level": 1 # common - 1, rare - 2, epic - 3, legendary - 4
	},
	{   "id": 3,
		"name": "Simple Attack",
		"description": "Increase Player Attack",
		"stats": {
			"attack": 2 # modifiers: damage, defence, attack, health, defence_enemy, attack_enemy
		},
		"level": 1 # common - 1, rare - 2, epic - 3, legendary - 4
	},
	{   "id": 4,
		"name": "Simple E_Attack_d",
		"description": "Reduces enemy attack stats",
		"stats": {
			"attack_enemy": -2 # modifiers: damage, defence, attack, health, defence_enemy, attack_enemy
		},
		"level": 1 # common - 1, rare - 2, epic - 3, legendary - 4
	},
	{   "id": 5,
		"name": "Simple E_Defence_d",
		"description": "Reduces enemy defence stats",
		"stats": {
			"defence_enemy": -2 # modifiers: damage, defence, attack, health, defence_enemy, attack_enemy
		},
		"level": 1 # common - 1, rare - 2, epic - 3, legendary - 4
	},
	{   "id": 6,
		"name": "DamageAndDefend",
		"description": "10 Damage and 2 defence up to player",
		"stats": {
			"damage": 10, # modifiers: damage, defence, attack, health, defence_enemy, attack_enemy
			"defence": 2
		},
		"level": 2 # common - 1, rare - 2, epic - 3, legendary - 4
	},
	{   "id": 7,
		"name": "DamageAndAttackUp",
		"description": "10 Damage and 2 attack up to player",
		"stats": {
			"damage": 10, # modifiers: damage, defence, attack, health, defence_enemy, attack_enemy
			"attack": 2
		},
		"level": 2 # common - 1, rare - 2, epic - 3, legendary - 4
	},
	{   "id": 8,
		"name": "GreatDamageAndHealthDown",
		"description": "20 Damage and 5 health down",
		"stats": {
			"damage": 20, # modifiers: damage, defence, attack, health, defence_enemy, attack_enemy
			"health": -5
		},
		"level": 3 # common - 1, rare - 2, epic - 3, legendary - 4
	},
	{   "id": 9,
		"name": "Vampirism",
		"description": "10 Damage and 5 health up",
		"stats": {
			"damage": 10, # modifiers: damage, defence, attack, health, defence_enemy, attack_enemy
			"health": 5
		},
		"level": 3 # common - 1, rare - 2, epic - 3, legendary - 4
	},
	{   "id": 10,
		"name": "Berserk Mode",
		"description": "10 Damage and 10 health, attack and defence up each",
		"stats": {
			"damage": 10, # modifiers: damage, defence, attack, health, defence_enemy, attack_enemy
			"health": 10,
			"attack": 10,
			"defence": 10
		},
		"level": 3 # common - 1, rare - 2, epic - 3, legendary - 4
	}
]

var unlocked_actions=[1, 2, 3]
var unlock_probabilities = [[0, 8], [8, 31], [31, 61], [61, 101]]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
