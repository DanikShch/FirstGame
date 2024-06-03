extends CanvasLayer

signal no_stamina()

@onready var health_bar = $HealthBar
@onready var stamina_bar = $StaminaBar
@onready var health_text = $"../HealthText"
@onready var health_anim = $"../HealthAnim"

var stamina_cost
var attack_cost = 10
var block_cost = 0.5
var slide_cost = 20
var run_cost = 0.3

var max_health = 100
var old_health = max_health
var health_regen = 1
var health:
	set(value):
		health = clamp(value, 0, max_health)
		health_bar.value = health
		var difference = health - old_health
		health_text.text = str(difference)
		old_health = health
		if difference < 0:
			health_anim.play("damage_taken")
		elif difference > 0:
			health_anim.play("health_regen")

var max_stamina = 100
var stamina_regen = 10
var stamina = 100:
	set(value):
		stamina = value
		if(stamina) < 1:
			emit_signal("no_stamina")

func _ready():
	health = max_health
	health_bar.max_value = health
	health_bar.value = health
	stamina_bar.max_value = max_stamina
	health_text.modulate.a = 0

func _process(delta):
	stamina_bar.value = stamina
	if stamina < max_stamina:
		stamina += stamina_regen * delta
	
func stamina_consumption():
	stamina -= stamina_cost


func _on_health_regen_timeout():
	health += health_regen
		
