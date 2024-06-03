extends CharacterBody2D


enum {
	MOVE,
	ATTACK,
	ATTACK2,
	ATTACK3,
	BLOCK,
	SLIDE,
	DEATH,
	DAMAGE
}

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Get the gravity from the project settings to be synced with RigidBody nodes.
@onready var leafs = $Leafs
@onready var anim = $AnimatedSprite2D #get_node("AnimatedSprite2D")
@onready var animPlayer = $AnimationPlayer
@onready var stats = $Stats

var gold = 0
var state = MOVE
var run_speed = 1
var combo = false
var attack_cooldown = false
var basic_damage = 10
var damage_multiplier = 1
var recovery = false

func _ready():
	Signals.connect("enemy_attack", Callable(self, "_on_damage_taken"))



func _physics_process(delta):
		# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if velocity.y > 0:
		anim.play("Fall")
		
	Global.player_damage = basic_damage * damage_multiplier
	
	
	match state:
		MOVE:
			move_state()
		ATTACK:
			attack_state()
		ATTACK2:
			attack2_state()
		ATTACK3:
			attack3_state()
		BLOCK:
			block_state()
		SLIDE:
			slide_state()
		DEATH:
			death_state()
		DAMAGE:
			damage_state()



	
	move_and_slide()
	Global.player_pos = self.position
	
	
func move_state ():
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED * run_speed
		if velocity.y == 0:	
			if run_speed == 1:
				animPlayer.play("Walk")
			else:
				animPlayer.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:	
			animPlayer.play("Idle")
	if direction == -1:
		anim.flip_h = true
		$AttackDirection.scale=Vector2(-1,1)
	elif direction == 1:
		anim.flip_h = false
		$AttackDirection.scale=Vector2(1,1)
	if Input.is_action_pressed("run") and !recovery:
		run_speed = 1.5
		stats.stamina -= stats.run_cost
	else:
		run_speed = 1
	if Input.is_action_pressed("block"):
		if !recovery:
			if velocity.x == 0:
				stats.stamina_cost = stats.block_cost
				if stats.stamina_cost <= stats.stamina:
					state = BLOCK
			else:
				stats.stamina_cost = stats.slide_cost
				if stats.stamina_cost <= stats.stamina:
					state = SLIDE
	
	if Input.is_action_just_pressed("attack"):
		if !recovery:
			stats.stamina_cost = stats.attack_cost
			if !attack_cooldown and stats.stamina_cost <= stats.stamina:
				state = ATTACK
		
func death_state():
	velocity.x = 0
	animPlayer.play("Death")
	await animPlayer.animation_finished
	queue_free()
	get_tree().change_scene_to_file.bind("res://menu.tscn").call_deferred()
		
func block_state ():
	stats.stamina -= stats.stamina_cost
	velocity.x = 0
	animPlayer.play("Block")
	if Input.is_action_just_released("block") or recovery:
		state = MOVE

func slide_state ():
	stats.stamina_cost = stats.slide_cost
	animPlayer.play("Slide")
	await animPlayer.animation_finished
	state = MOVE
	
func attack_state ():
	damage_multiplier = 1
	stats.stamina_cost = stats.attack_cost
	if Input.is_action_just_pressed("attack") and combo == true and stats.stamina_cost <= stats.stamina:
		state = ATTACK2
	velocity.x = 0
	animPlayer.play("Attack")
	await animPlayer.animation_finished
	attack_freeze()
	state = MOVE

func attack2_state ():
	damage_multiplier = 1.2
	stats.stamina_cost = stats.attack_cost
	if Input.is_action_just_pressed("attack") and combo == true and stats.stamina_cost <= stats.stamina:
		state = ATTACK3
	animPlayer.play("Attack2")
	await animPlayer.animation_finished
	state = MOVE

func attack3_state ():
	stats.stamina_cost = stats.attack_cost
	damage_multiplier = 1.5
	animPlayer.play("Attack3")
	await animPlayer.animation_finished
	state = MOVE

func combo1 ():
	combo = true
	await animPlayer.animation_finished
	combo = false

func attack_freeze():
	attack_cooldown = true
	await get_tree().create_timer(0.3).timeout
	attack_cooldown = false

func damage_state ():
	velocity.x = 0
	animPlayer.play("TakeHit")
	await animPlayer.animation_finished
	state = MOVE

func _on_damage_taken(enemy_damage):
	if state == BLOCK:
		enemy_damage /=2
	elif state == SLIDE:
		enemy_damage = 0
	else:
		state = DAMAGE
	stats.health -= enemy_damage
	if stats.health <= 0:
		stats.health = 0
		state = DEATH		
	


func _on_stats_no_stamina():
	recovery = true
	await get_tree().create_timer(2).timeout
	recovery = false
	
func steps():
	leafs.emitting = true
	leafs.one_shot = true
