extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 200
export (PackedScene) var banana = preload("res://banana.tscn")

var b_exist = true
var right = false
var r = false
var left = false
var l = false
var up = false
var u = false
var down = false
var d = false
var have_banana = false
var had_once = false
var shooting = false
var backwards = false
var pos_change = 0
var screen_size
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		right = true
		left = false
		up = false
		down = false
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		right = false
		left = true
		up = false
		down = false
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		right = false
		left = false
		up = true
		down = false
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		right = false
		left = false
		up = false
		down = true
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	#position += velocity*delta
	#position.x = clamp(position.x, 0, screen_size.x)
	#position.y = clamp(position.y, 0, screen_size.y)
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
			
	if b_exist:
		if position.x - 20 < get_parent().get_node("banana").position.x and position.x + 20 > get_parent().get_node("banana").position.x and position.y - 20 < get_parent().get_node("banana").position.y and position.y + 20 > get_parent().get_node("banana").position.y:
			have_banana = true
		
		if have_banana and not had_once:
			get_parent().get_node("banana").position = position

		if Input.is_action_just_pressed("shoot") and have_banana and not had_once: 
			set_directions(right, left, up, down)
			shooting = true
			have_banana = false
			had_once = true
		
		if shooting:
			var b_velocity = Vector2.ZERO
			if r and not backwards or l and backwards:
				b_velocity.x += 5
			if l and not backwards or r and backwards:
				b_velocity.x -= 5
			if d and not backwards or u and backwards:
				b_velocity.y += 5
			if u and not backwards or d and backwards:
				b_velocity.y -= 5
			
			pos_change += 1
			if pos_change == 100:
				backwards = true
			if pos_change == 195:
				get_parent().get_node("banana").queue_free()
				b_exist = false
			if b_velocity.length() > 0:
				b_velocity = b_velocity.normalized() * speed
			get_parent().get_node("banana").position += b_velocity * delta

func shoot():
		var b = banana.instance()
		b.set_directions(right, left, up, down)
		owner.add_child(b)
		b.show()
		#b.transform = $Muzzle.global_transform

func set_directions(right, left, up, down):
	r = right
	l = left
	u = up
	d = down
