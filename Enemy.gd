extends AspectRatioContainer


@export var MAX_HEALTH=20
@export var health=MAX_HEALTH
@export var attack=10
@export var defence=10

var action_probabilites = {
	"healthy" : [[0, 31],[31, 41], [41, 101]],
	"wounded" : [[0, 16], [16, 36], [36, 101]],
	"injured" : [[0, 6], [6, 31], [31, 101]],
	"critical": [[0, 46], [46, 46], [46, 101]]
}

# Called when the node enters the scene tree for the first time.
func _ready():
	change_health(0)	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_defence(deltaDefance) -> int:
	self.defence = self.defence + deltaDefance
	return self.defence

func change_attack(deltaAttack) -> int:
	self.attack = self.attack + deltaAttack
	return self.attack

func change_health(deltaHealth) -> int:
	self.health = self.health + deltaHealth
	$VBoxContainer/HealthBar.max_value = MAX_HEALTH
	$VBoxContainer/HealthBar.value = health
	
	var reward = {
		"player_xp": 10
	}
	
	if (self.health <= 0):
		EventBus.enemy_dies.emit(reward)
		#$Timer.set_one_shot(true)
		#$Timer.start(1.0)
	else:
		EventBus.enemy_hit.emit()
	
	return self.health
	
func on_player_attack(playerAttack):
	var dmgMultiplier = 1 - float(get_defence()) / float(playerAttack + get_defence())
	var dmg = playerAttack * dmgMultiplier
	change_health(-ceil(dmg))
	
func get_attack() -> int:
	return attack

func get_defence() -> int:
	return defence
	
func action():
	EventBus.changed_player_health_b.emit(get_attack())
	EventBus.changed_turn.emit()

func get_action():
	var action = "damage"
	
	var health_status = get_health_status()
		
	var probs = action_probabilites[health_status]
	
	var r = randi() % 100 + 1
	var actions = ["attack", "defence", "damage"]
	
	for i in range(probs.size()):
		if r >= probs[i][0] and r < probs[i][1]:
			action = actions[i] 
	
	if (action == "damage"):
		EventBus.changed_player_health_b.emit(get_attack())
	elif action == "defence":
		EventBus.changed_enemy_defence.emit(2)
		#change_defence(2)
	elif action == "attack":
		EventBus.changed_enemy_attack.emit(2)
		#change_attack(2)
		
	EventBus.changed_turn.emit()

func get_health_status():
	if (health <= MAX_HEALTH*0.25):
		return "critical"
	elif (health <= MAX_HEALTH*0.5):
		return "injured"
	elif (health <= MAX_HEALTH*0.75):
		return "wounded"
	else:
		return "healthy"

