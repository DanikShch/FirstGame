extends CharacterBody2D

enum {
	IDLE,
	ATTACK,
	CHASE,
	DAMAGE,
	DEATH,
	RECOVER
}

var state: int = 0:
	set(value):
		state = value
		match state:
			IDLE:
				idle_state()
			ATTACK:
				attack_state()
			CHASE:
				chase_state()
			DAMAGE:
				damage_state()
			DEATH:
				death_state()
			RECOVER:
				recover_state()

@onready var animPlayer = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var direction
var damage = 20
var alive = true


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	if state == CHASE:
		chase_state()
	move_and_slide()

	player =Global.player_pos

func _on_attack_range_body_entered(body):
	state = ATTACK
	
func idle_state():
	animPlayer.play("Idle")
	state = CHASE
	
func attack_state():
	animPlayer.play("Attack")
	await  animPlayer.animation_finished
	state = RECOVER

func chase_state():
	direction = (player - self.position).normalized()
	if direction.x < 0:
		sprite.flip_h = true
		$AttackDirection.scale=Vector2(-1,1)
	else:
		sprite.flip_h = false
		$AttackDirection.scale=Vector2(1,1)

func damage_state():
	damage_anim()
	animPlayer.play("Damage")
	await animPlayer.animation_finished
	state = IDLE

func death_state():
	if alive:
		alive = false
		Signals.emit_signal("enemy_died", position)
	animPlayer.play("Death")
	await animPlayer.animation_finished
	queue_free()

func recover_state():
	animPlayer.play("Recover")
	await animPlayer.animation_finished
	if $AttackDirection/AttackRange.has_overlapping_bodies():
		state = ATTACK
	else:
		state = IDLE

func _on_hit_box_area_entered(area):
	Signals.emit_signal("enemy_attack", damage)




func _on_mob_health_no_health():
	state = DEATH


func _on_mob_health_damage_taken():
	state = IDLE
	state = DAMAGE
	
func damage_anim():
	direction = (player - self.position).normalized()
	velocity.x = 0
	if direction.x < 0 :
		velocity.x += 200
	elif direction.x > 0:
		velocity.x -= 200
	var tween = get_tree().create_tween()
	tween.tween_property(self, "velocity", Vector2.ZERO, 0.1)
	
	
	
