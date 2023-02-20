extends KinematicBody2D

var right
var left
var up
var down
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_directions(r, l, u, d):
	right = r
	left = l
	up = u
	down = d
	
var speed = 500

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		var velocity = Vector2.ZERO
		if right:
			velocity.x += 1
		if left:
			velocity.x -= 1
		if down:
			velocity.y += 1
		if up:
			velocity.y -= 1

		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
		
		position += velocity * delta


