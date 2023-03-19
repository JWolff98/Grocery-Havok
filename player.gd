extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


export var speed = 200
export var num_enemies_hit = 0
var screen_size
var frameTimer
var framedVelocity

signal victory
signal hit
# Called when the node enters the scene tree for the first time.
export var Bullet = preload("res://Bullet.tscn")
func _ready():
	screen_size = get_viewport_rect().size
	frameTimer = 0
	# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	var velocity = Vector2.ZERO
	$gun_center.look_at(get_global_mouse_position())
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	#position += velocity*delta
	#position.x = clamp(position.x, 0, screen_size.x)
	#position.y = clamp(position.y, 0, screen_size.y)
	var collision = move_and_collide(velocity*delta)
	if frameTimer == 0:
		if collision:
			if(collision.collider.name.begins_with("aisle")):
				framedVelocity = velocity.bounce(collision.normal)
				frameTimer = -10
	
	if frameTimer < 0:
		move_and_collide(framedVelocity * delta)
		frameTimer += 1
	else:
		move_and_collide(velocity*delta)
	
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	if velocity.y != 0:
		if velocity.y > 0:
			$AnimatedSprite.animation = "walk_forward"
		else:
			$AnimatedSprite.animation = "walk_backward"
	elif velocity.x != 0:
		if velocity.x < 0:
			$AnimatedSprite.animation = "walk_left"
		else:
			$AnimatedSprite.animation = "walk_right"
	
	if num_enemies_hit == 22:
		emit_signal("victory")
			
func _unhandled_input(event):
	if event.is_action_released("attack"):
		var bullet = Bullet.instance()
		owner.add_child(bullet)
		bullet.set_ang($gun_center.rotation)
		bullet.global_position = $gun_center/gun/Muzzle.global_position
		$gun_shot.play()
		$gun_shot.stop()

func _on_aoi_body_entered(body):
	if body.is_in_group("mobs"):
		emit_signal("hit")
		body.queue_free()
		hide()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false


