extends AspectRatioContainer


@export var MAX_HEALTH=100
@export var health=MAX_HEALTH
@export var attack=10
@export var defence=10

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
	$VBoxContainer/HealthBar.value = health
	
	if (self.health <= 0):
		EventBus.enemy_dies.emit()
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
