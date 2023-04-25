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
var attack1 = false
var attack2 = false
var preMelee = false
var num_magic_attacks
var original_color
export var magic_attack = preload("res://magic_fire.tscn")

var i = 0
var start_positions = [Vector2(42,552), Vector2(42,480), Vector2(42,408), Vector2(42,336), Vector2(42,264), Vector2(42,192), Vector2(42,120)]

var end_positions = [Vector2(554,480), Vector2(554,408), Vector2(554,336), Vector2(554,264), Vector2(554,192), Vector2(554,120), Vector2(554, 48)]


signal boss_death
signal boss_hit



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
	$melee.wait_time = randi() % 5  + 3
	num_magic_attacks = randi() % 7 + 3
	disabled = true # Replace with function body.
	original_color = $AnimatedSprite.modulate


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	if preMelee and not disabled and not dead and not attack1 and not hit:
		var velocity = position.move_toward(start_positions[0], delta*2*speed)
		var vel = velocity - position
		if vel.x != 0:
			if vel.x > 0:
				$AnimatedSprite.flip_h = false
			elif vel.x < 0:
				$AnimatedSprite.flip_h = true
		position = velocity

		position.x = clamp(position.x, 0, screen_size.x)
		position.y = clamp(position.y, 0, screen_size.y)
		if position == start_positions[0]:
			attack2 = true
			preMelee = false
	if attack2 and not disabled and not dead and not attack1 and not preMelee and not hit:
		$AnimatedSprite.animation = "float"
		$AnimatedSprite.playing = true
		melee_attack(delta)
	if not dead and not disabled and not attack1 and not attack2 and not preMelee and not hit:
		$AnimatedSprite.modulate = original_color
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
	if not attack1 and not attack2 and not preMelee:
		$AnimatedSprite.modulate = original_color
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
		emit_signal("boss_hit")
		
func on_death():
	$AnimatedSprite.modulate = original_color
	dead = true
	attack1 = false
	hit = false
	attack2 = false
	preMelee = false
	
	$attack.stop()
	$melee.stop()
	get_node("CollisionShape2D").set_deferred("disabled", true)
	$AnimatedSprite.animation = "death"
	$AnimatedSprite.play()
	
	yield($AnimatedSprite, "animation_finished")
	emit_signal("boss_death")
	position = Vector2(0, 0)
	
func is_dead(): 
	return is_freed

func disable():
	get_node("CollisionShape2D").set_deferred("disabled", true)
	#$CollisionShape2D.disabled = true
	position = Vector2(0, 0)
	disabled = true
	$attack.stop()
	$melee.stop()
	$AnimatedSprite.animation = "float"
	$attack.wait_time = randi() % 5 + 3
	$melee.wait_time = randi() % 5  + 3
	num_magic_attacks = randi() % 7 + 3
	dead = false
	tutorial = false
	hit = false
	is_freed = false
	attack1 = false
	attack2 = false
	preMelee = false
	i = 0
	get_tree().call_group("danger", "queue_free") # Replace with function body.
	

func enable():
	$AnimatedSprite.modulate = original_color
	get_node("CollisionShape2D").set_deferred("disabled", false)
	disabled = false
	$attack.start()
	$melee.start()

func _on_attack_timeout():
	if not disabled:
		attack1 = true
		$attack.stop()
		$melee.stop()
		$AnimatedSprite.modulate = Color(4, 4, 4)
		$AnimatedSprite.animation = "attack"
		$AnimatedSprite.playing = true
		for n in range(num_magic_attacks):
			var fire = magic_attack.instance()
			#fire.connect("body_entered", get_parent().get_parent().get_node("player"), "_fire_hit")
			fire.scale.x = 2
			fire.scale.y = 2
			get_parent().get_parent().add_child(fire)
			fire.global_position = get_parent().get_parent().get_node("player").position
			fire.start()
			yield(get_tree().create_timer(1.2), "timeout")
		num_magic_attacks = randi() % 7 + 3
		#$AnimatedSprite.animation = "attack"
		#$AnimatedSprite.playing = true
		$AnimatedSprite.frame = 0
		yield($AnimatedSprite, "animation_finished")
		#for n in range(num_magic_attacks):
		#	attacks.append(magic_attack.instance())
		#for fire in attacks:
		#	add_child(fire)	
		#	fire.position = get_parent().get_parent().get_node("player").position
		#	fire.scale.x = 2
		#	fire.scale.y = 2
		#	fire.start()
		$AnimatedSprite.modulate = original_color
		attack1 = false
		$attack.wait_time = randi() % 5 + 3
		$melee.wait_time = randi() % 5 + 3
		$attack.start()
		$melee.start() # Replace with function body.
func melee_attack(delta):
	if position == end_positions[i]:
		i += 1
		if i == len(end_positions):
			i = 0
			attack2 = false
			$attack.start()
			$melee.start()
		position = start_positions[i]

	var velocity = position.move_toward(end_positions[i], delta*5*speed)
	var vel = velocity - position
	if vel.x != 0:
		if vel.x > 0:
			$AnimatedSprite.flip_h = false
		elif vel.x < 0:
			$AnimatedSprite.flip_h = true
	position = velocity

	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _on_melee_timeout():
	if not disabled:
		$attack.stop()
		$melee.stop()
		$attack.wait_time = randi() % 5 + 3
		$melee.wait_time = randi() % 5 + 3
		$AnimatedSprite.modulate = Color(4, 4, 4)
		$AnimatedSprite.animation = "rush"
		$AnimatedSprite.play()
		preMelee = true# Replace with function body.
