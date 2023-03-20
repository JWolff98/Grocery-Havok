extends KinematicBody2D
var off = false

var screen_size

func _physics_process(delta):
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	$AnimatedSprite.playing = false

func start():
	show()
	$AnimatedSprite.animation = "idle"
	$AnimatedSprite.playing = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	$AnimatedSprite.animation = "start_burn"


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "burn":
		off = false
		$AnimatedSprite.animation = "idle"
		
	if $AnimatedSprite.animation == "start_burn":
		off = true
		$AnimatedSprite.animation = "burn"
		


func turn_off():
	$AnimatedSprite.playing = false
