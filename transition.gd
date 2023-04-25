extends Area2D

var transition
var speed
signal transition_done
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
		if $player.position.x >=  306:
			transition = false
			#$player.position = Vector2(-119, 473)
			$player.playing = false
			finish()
			#hide()


func start():
	transition = true
	$player.position = Vector2(-119, 473)
	$player.playing = true
func finish():
	$kyle.animation = "right"
	$kyle.flip_h = true
	$Label.text = "What are you doing here!"
	$ColorRect.show()
	$Label.show()
	yield(get_tree().create_timer(1.5), "timeout")
	$Label.text = "What are you doing here!\nYou are not supposed to be here!"
	yield(get_tree().create_timer(1.5), "timeout")
	$Label.text = "What are you doing here!\nYou are not supposed to be here!\nGet Out!"
	yield(get_tree().create_timer(1), "timeout")
	$Label.text = ""
	$Label.hide()
	$ColorRect.hide()
	$TextureRect2.show()
	$TextureRect2/kyle_transform.play()
	$TextureRect2/kyle_transform.frame = 0
	yield($TextureRect2/kyle_transform, "animation_finished")
	$TextureRect2/kyle_transform.playing = false
	$TextureRect2/kyle_transform.frame = 6
	$magic_barrier/AnimatedSprite.playing = true
	$magic_barrier.show()
	yield(get_tree().create_timer(0.14), "timeout")
	$magic_barrier2/AnimatedSprite.playing = true
	$magic_barrier2.show()
	yield(get_tree().create_timer(0.14), "timeout")
	$magic_barrier3/AnimatedSprite.playing = true
	$magic_barrier3.show()
	yield(get_tree().create_timer(0.14), "timeout")
	$magic_barrier4/AnimatedSprite.playing = true
	$magic_barrier4.show()
	yield(get_tree().create_timer(0.14), "timeout")
	$magic_barrier5/AnimatedSprite.playing = true
	$magic_barrier5.show()
	yield(get_tree().create_timer(0.14), "timeout")
	$magic_barrier6/AnimatedSprite.playing = true
	$magic_barrier6.show()
	yield(get_tree().create_timer(0.14), "timeout")
	$magic_barrier7/AnimatedSprite.playing = true
	$magic_barrier7.show()
	yield(get_tree().create_timer(0.14), "timeout")
	emit_signal("transition_done")
	$TextureRect2.hide()
	$TextureRect2/kyle_transform.playing = false
	transition = false
	$player.position = Vector2(-119, 473)
	$player.playing = false
	$magic_barrier/AnimatedSprite.playing = false
	$magic_barrier.hide()
	$magic_barrier2/AnimatedSprite.playing = false
	$magic_barrier2.hide()
	$magic_barrier3/AnimatedSprite.playing = false
	$magic_barrier3.hide()
	$magic_barrier4/AnimatedSprite.playing = false
	$magic_barrier4.hide()
	$magic_barrier5/AnimatedSprite.playing = false
	$magic_barrier5.hide()
	$magic_barrier6/AnimatedSprite.playing = false
	$magic_barrier6.hide()
	$magic_barrier7/AnimatedSprite.playing = false
	$magic_barrier7.hide()
	hide()
	
	
