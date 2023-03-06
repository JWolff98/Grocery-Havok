extends Area2D
var speed = 15
var num_enemies_hit = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var direction = Vector2.ZERO
var ang = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	global_position.x += cos(ang)*speed
	global_position.y += sin(ang)*speed
func set_ang(an):
	ang = an
	

func _on_Bullet_body_entered(body):
	if body.is_in_group("mobs"):	
		num_enemies_hit += 1
		body.queue_free() # Replace with function body
	queue_free()
	
	#22 enemies in the first wave
	if num_enemies_hit == 22:
		$success.play()
	
	
