extends PointLight2D

@onready var timer = $Timer
var day_state = 0

func _ready():
	Signals.connect("day_time", Callable(self, "_on_time_changed"))
	light_off()

func _on_timer_timeout():
	if day_state == 3:
		var tween = get_tree().create_tween()
		tween.parallel().tween_property(self, "texture_scale", randf_range(0.8, 1.2), timer.wait_time)
		tween.parallel().tween_property(self, "energy", randf_range(1.3, 1.7), timer.wait_time)
		timer.wait_time = randf_range(0.4, 0.8)

func _on_time_changed (state):
	day_state = state
	if state == 0:
		light_off()
	elif state == 2:
		light_on()
		
func light_off():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "energy", 0, randi_range(15, 20))
	
func light_on():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "energy", 1.5, randi_range(15, 20))
