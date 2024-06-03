extends Node2D

signal no_health ()
signal damage_taken()

@onready var health_bar = $HealthBar
@onready var damage_text = $DamageText
@onready var animPlayer = $AnimationPlayer

var health = 100:
	set(value):
		health = value
		health_bar.value = health
		if health <= 0:
			health_bar.visible = false
			damage_text.visible = false
		else:
			health_bar.visible = true


func _ready():
	Signals.connect("player_attack", Callable (self, "_on_damage_taken"))
	health_bar.max_value = health
	health_bar.visible = false
	damage_text.modulate.a = 0

func _on_damage_taken (player_damage):
	health -= player_damage
	damage_text.text = str(player_damage)
	animPlayer.stop()
	animPlayer.play("damageText")
	if health <= 0:
		emit_signal("no_health")
	else:
		emit_signal("damage_taken")
