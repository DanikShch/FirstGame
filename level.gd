extends Node2D

@onready var light = $Light/DirectionalLight2D
@onready var pointLight1 = $Light/PointLight2D
@onready var pointLight2 = $Light/PointLight2D2
@onready var dayText = $CanvasLayer/DayText
@onready var animPlayer = $CanvasLayer/AnimationPlayer
@onready var health_bar = $CanvasLayer/HealthBar
@onready var player = $Player/Player


enum {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}

var state = MORNING
var dayCount: int

func _ready():
	health_bar.max_value = player.max_health
	health_bar.value = player.health
	light.enabled = true
	dayCount = 1
	set_day_text()
	day_text_fade()


func morning_state ():
	var tween = get_tree().create_tween()
	tween.tween_property(light, "energy", 0.1, 20)
	var tween1 = get_tree().create_tween()
	tween1.tween_property(pointLight1, "energy", 0, 20)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(pointLight2, "energy", 0, 20)
	
func evening_state ():
	var tween = get_tree().create_tween()
	tween.tween_property(light, "energy", 0.9, 20)
	var tween1 = get_tree().create_tween()
	tween1.tween_property(pointLight1, "energy", 1.5, 20)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(pointLight2, "energy", 1.5, 20)

func _on_day_night_timeout():
	match state:
		MORNING:
			morning_state()
		EVENING:
			evening_state()
	if state == 3:
		state = 0
		dayCount +=1
		set_day_text()
		day_text_fade()
	else:
		state += 1
		
func day_text_fade():
	animPlayer.play("day_text_fade_in")
	await get_tree().create_timer(3).timeout
	animPlayer.play("day_text_fade_out")

func set_day_text():
	dayText.text = "DAY" + str(dayCount)


func _on_player_health_changed(new_health):
	health_bar.value = new_health
