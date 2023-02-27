extends Node
export (PackedScene) var grape

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$grapeTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_grapeTimer_timeout():
	# Choose a random location on Path2D.
	$grapePath/grapeSpawnLocation.set_offset(randi())
	# Create a Mob instance and add it to the scene.
	var g = grape.instance()
	g.scale.x = 2.5
	g.scale.y = 2.5
	add_child(g)
	# Set the mob's position to a random location.
	g.position = $grapePath/grapeSpawnLocation.position

func _on_player_hit():
	$produce_aisle.stop()
	$grapeTimer.stop()
	get_tree().call_group("mobs", "queue_free")
	$gameover.play()
	$gameover.stop()
