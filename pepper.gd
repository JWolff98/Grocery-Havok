extends KinematicBody2D
var off = false
signal smoke_screen
signal smoke_screen_stop
var screen_size
var max_hp = 150
var current_hp
var dead = false
var tutorial = false
signal pepper_death
func _physics_process(delta):
	if not dead:
		pass


# Called when the node enters the scene tree for the first time.
func _ready():
	current_hp = max_hp
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
		emit_signal("smoke_screen_stop")
		
	if $AnimatedSprite.animation == "start_burn":
		off = true
		$AnimatedSprite.animation = "burn"
		emit_signal("smoke_screen")

func turn_off():
	$AnimatedSprite.playing = false
func on_hit(dmg):
	current_hp -= dmg
	if current_hp <= 0 and not tutorial:
		on_death()
	if tutorial:
		$AnimatedSprite.animation = "death"
		$AnimatedSprite.play()
		yield($AnimatedSprite, "animation_finished")
		$AnimatedSprite.animation = "idle"
		$AnimatedSprite.playing = true    
		 
func on_death():
	dead = true
	get_node("CollisionShape2D").set_deferred("disabled", true)
	$AnimatedSprite.animation = "death"
	$AnimatedSprite.play()
	if off:
		emit_signal("smoke_screen_stop")
	yield($AnimatedSprite, "animation_finished")
	emit_signal("pepper_death")
	queue_free()
