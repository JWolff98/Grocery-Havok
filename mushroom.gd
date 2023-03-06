extends KinematicBody2D

var screen_size
var speed = 100
var frameTimer
var framedVelocity

func _physics_process(delta):
	$AnimatedSprite.playing = true
	var velocity = Vector2.ZERO

	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, get_parent().get_node("player").position, [self])
	
	if position.distance_to(get_parent().get_node("player").position) <= 40:
		$AnimatedSprite.animation = "attack"
	elif (result.collider.name.begins_with("player")):
	
		#check if mushroom can see the player
			
		var move_towards = get_parent().get_node("player").position
		velocity = (move_towards - position).normalized() * speed
		
		$AnimatedSprite.flip_h = velocity.x < 0
		$AnimatedSprite.animation = "running"
	else:
		$AnimatedSprite.animation = "idle"
	
	var collision = move_and_collide(velocity*delta)
	if frameTimer == 0:
		if collision:
			if(collision.collider.name.begins_with("aisle")):
				framedVelocity = velocity.bounce(collision.normal)
				frameTimer = -150
	
	if frameTimer < 0:
		move_and_collide(framedVelocity * delta)
		frameTimer += 1
	else:
		move_and_collide(velocity*delta)
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
# Called when the node enters the scene tree for the first time.
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	frameTimer = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
