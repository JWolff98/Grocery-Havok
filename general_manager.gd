extends KinematicBody2D

var max_hp = 1500
var current_hp

#onready var navigation_agent = $NavigationAgent2D
var screen_size
var speed = 150
var frameTimer
var framedVelocity
var dead = false
var tutorial = false
var hit = false
var is_freed = false
var disabled = false
var attack = false
signal boss_death

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	frameTimer = 0
	current_hp = max_hp
	$AnimatedSprite.animation = "float"
	$attack.wait_time = randi() % 5 + 3
	disabled = true # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	if not dead and not disabled and not attack and not hit:
		$AnimatedSprite.playing = true
		$AnimatedSprite.animation = "float"
		var move_towards = get_parent().get_parent().get_node("player").position
		
		#navigation_agent.set_target_location(move_towards)
		#var move_direction = position.direction_to(navigation_agent.get_next_location())
		var velocity = position.move_toward(move_towards, delta*speed)
		var vel = velocity - position
		if vel.x != 0:
			if vel.x > 0:
				$AnimatedSprite.flip_h = false
			elif vel.x < 0:
				$AnimatedSprite.flip_h = true
		position = velocity
		#navigation_agent.set_velocity(velocity)

		#var collision = move_and_collide(velocity*delta)
		#if frameTimer == 0:
		#	if collision:
		#		if(collision.collider.name.begins_with("aisle")):
			#		framedVelocity = velocity.bounce(collision.normal)
			#		frameTimer = -500

	#	if frameTimer < 0:
	#		move_and_collide(framedVelocity * delta)
	#		frameTimer += 1
	#	else:
		#	move_and_collide(velocity*delta)
		position.x = clamp(position.x, 0, screen_size.x)
		position.y = clamp(position.y, 0, screen_size.y)
		
func on_hit(dmg):
	current_hp -= dmg
	if current_hp > 0 and not tutorial:
		hit = true
		$CollisionShape2D.set_deferred("disabled", true)
		get_node("AnimatedSprite").play("hit")
		yield($AnimatedSprite, "animation_finished")
		hit = false
		$CollisionShape2D.set_deferred("disabled", false)
	if current_hp <= 0 and not tutorial:
		on_death()
		
func on_death():
	dead = true
	$attack.stop()
	get_node("CollisionShape2D").set_deferred("disabled", true)
	$AnimatedSprite.animation = "death"
	$AnimatedSprite.play()
	
	yield($AnimatedSprite, "animation_finished")
	emit_signal("boss_death")
	
func is_dead(): 
	return is_freed

func disable():
	get_node("CollisionShape2D").set_deferred("disabled", true)
	disabled = true
	$attack.stop()

func enable():
	get_node("CollisionShape2D").set_deferred("disabled", false)
	disabled = false
	$attack.start()

func _on_attack_timeout():
	$AnimatedSprite.animation = "attack"
	$AnimatedSprite.playing = true
	attack = true
	yield($AnimatedSprite, "animation_finished")
	attack = false
	$attack.wait_time = randi() % 5 + 3
	$attack.start() # Replace with function body.
