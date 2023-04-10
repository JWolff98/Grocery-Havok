extends Area2D

var transition
var speed
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	transition = false
	speed = 200 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if transition:
		var velocity = Vector2.ZERO
		velocity.x = 1
		$player.position += velocity.normalized()*speed*delta
		if $player.position.x >=  726:
			transition = false
			$player.position = Vector2(-119, 473)
			$player.playing = false
			hide()


func start():
	transition = true
	$player.position = Vector2(-119, 473)
	$player.playing = true
