extends Node
export (PackedScene) var grape
export (PackedScene) var mushroom

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var num_grapes = 0
var num_mushroom = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$grapeTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_grapeTimer_timeout():
	# Choose a random location on Path2D.
	#$grapePath/grapeSpawnLocation.set_offset(randi())
	
	while $grapePath/grapeSpawnLocation.position.distance_to($player.position) < 200:
		print(1)
		$grapePath/grapeSpawnLocation.set_offset(randi())
	# Create a Mob instance and add it to the scene.
	var g = grape.instance()
	g.scale.x = 2.5
	g.scale.y = 2.5
	add_child(g)
	# Set the mob's position to a random location.
	g.position = $grapePath/grapeSpawnLocation.position
	
	num_grapes += 1
	if num_grapes >= 15:
		$grapeTimer.stop()
		$mushroomTimer.start()


func _on_player_hit():
	$produce_aisle.stop()
	$grapeTimer.stop()
	get_tree().call_group("mobs", "queue_free")
	$gameover.play()
	$gameover.stop()


func _on_mushroomTimer_timeout():
	# Choose a random location on Path2D.
	$grapePath/grapeSpawnLocation.set_offset(randi())
	while $grapePath/grapeSpawnLocation.position.distance_to($player.position) < 200:
		$grapePath/grapeSpawnLocation.set_offset(randi())
	
	# Create a Mob instance and add it to the scene.
	var m = mushroom.instance()
	m.scale.x = 1
	m.scale.y = 1
	add_child(m)
	
	# Set the mob's position to a random location.
	m.position = $grapePath/grapeSpawnLocation.position
	
	num_mushroom += 1
	if num_mushroom == 7:
		$mushroomTimer.stop()
