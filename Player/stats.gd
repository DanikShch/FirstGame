extends CanvasLayer

signal no_stamina()

@onready var health_bar = $HealthBar
@onready var stamina_bar = $StaminaBar

var stamina_cost
var attack_cost = 10
var block_cost = 1
var slide_cost = 20
var run_cost = 1

var max_health = 100
var health_regen = 1
var health:
	set(value):
		health = value
		health_bar.value = health

var max_stamina = 100
var stamina_regen = 10
var stamina = 50:
	set(value):
		stamina = value
		if(stamina) < 1:
			emit_signal("no_stamina")

func _ready():
	health = max_health
	health_bar.max_value = health
	health_bar.value = health
	stamina_bar.max_value = max_stamina

func _process(delta):
	stamina_bar.value = stamina
	health += health_regen * delta
	if stamina < max_stamina:
		stamina += stamina_regen * delta
	
func stamina_consumption():
	stamina -= stamina_cost
