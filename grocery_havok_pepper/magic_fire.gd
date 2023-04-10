extends Area2D
var dmg = 100

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.disabled = true
	hide()# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func start():
	$AnimatedSprite.animation = "telegraph"
	$AnimatedSprite.play()
	yield($AnimatedSprite, "animation_finished")
	$CollisionShape2D.disabled = false
	$animatedSprite.animation = "explosion"
	$AnimatedSprite.play()
	yield($AnimatedSprite, "animation_finished")
	$CollisionShape2D.disabled = false
	queue_free()
