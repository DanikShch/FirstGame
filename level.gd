extends Node2D

@onready var light = $DirectionalLight2D
@onready var pointLight1 = $PointLight2D
@onready var pointLight2 = $PointLight2D2

enum {
	MORNING,
	DAY,
	EVENING,
	NIGHT
}
var state = MORNING

func _ready():
	light.enabled = true

func _process(_delta):
	match state:
		MORNING:
			morning_state()
		DAY:
			pass
		EVENING:
			evening_state()
		NIGHT:
			pass

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
	if state == 3:
		state = 0
	else:
		state += 1
