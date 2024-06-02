extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = $AnimatedSprite2D

var chase = false
var speed = 100
var alive = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	var player = $"../../Player/Player"
	var direction = (player.position - self.position).normalized()
	if alive:
		if chase == true:
			velocity.x = direction.x * speed
			anim.play("Run")
		else: 
			velocity.x = 0
			anim.play("Idle")
		if direction.x < 0:
			anim.flip_h = true
		else:
			anim.flip_h = false
	move_and_slide()
		



func _on_detector_body_entered(body):
	if body.name == "Player":
		chase = true


func _on_detector_body_exited(body):
		if body.name == "Player":
			chase = false


func _on_death_body_entered(body):
	if body.name == "Player":
		body.velocity.y -= 400
		death()
		
func _on_death_2_body_entered(body):
	if body.name == "Player":
		if alive:
			body.health -= 40
			death()
	
	
func death():
	alive = false
	anim.play("Death")
	await anim.animation_finished
	queue_free()



