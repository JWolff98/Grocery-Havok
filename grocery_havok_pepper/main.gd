extends Node
export (PackedScene) var grape
export (PackedScene) var mushroom
export (PackedScene) var pepper = preload("res://pepper.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var num_grapes = 0
var num_mushroom = 0
var game_start = false
var p = pepper.instance()
var pepper_dead = false
var start_hidden = false
export var num_enemies_hit = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$empty_fridge.hide()
	$player.hide()
	$player.connect("enemy_defeated", $player.get_parent(), "_increment")
	$tutorial.hide()
	$pepper.turn_off()
	$background_1.hide()
	$background_1/aisle_0/CollisionPolygon2D.disabled = true
	$background_1/aisle_1/CollisionPolygon2D.disabled = true
	$background_1/aisle_2/CollisionPolygon2D.disabled = true
	$background_1/aisle_3/CollisionPolygon2D.disabled = true
	$background_1/aisle_4/CollisionPolygon2D.disabled = true
	$background_1/aisle_5/CollisionPolygon2D.disabled = true
	$background_1/aisle_6/CollisionPolygon2D.disabled = true
	$background_1/aisle_7/CollisionPolygon2D.disabled = true
	$background_1/aisle_8/CollisionPolygon2D.disabled = true
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#if $player.is_visible():
	#	if p.off:
	#		$background_1.hide()
	#		start_hidden = true
	#	if not p.off and start_hidden:
	#		$background_1.show()

func _on_grapeTimer_timeout():
	# Choose a random location on Path2D.
	$grapePath/grapeSpawnLocation.set_offset(randi())
	
	while $grapePath/grapeSpawnLocation.position.distance_to($player.position) < 200:
		$grapePath/grapeSpawnLocation.set_offset(randi())
	# Create a Mob instance and add it to the scene.
	var g = grape.instance()
	g.scale.x = 2
	g.scale.y = 2
	add_child(g)
	# Set the mob's position to a random location.
	g.position = $grapePath/grapeSpawnLocation.position
	g.connect("grape_death", $player, "_on_grape_death")
	num_grapes += 1
	if num_grapes >= 15:
		$grapeTimer.stop()
		$mushroomTimer.start()

func _on_player_hit():
	$produce_aisle.stop()
	$grapeTimer.stop()
	$mushroomTimer.stop()
	$HUD.show_game_over()
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
	m.connect("mushroom_death", $player, "_on_mushroom_death")
	
	num_mushroom += 1
	if num_mushroom == 7:
		$mushroomTimer.stop()
		p = pepper.instance()
		p.scale.x = 1
		p.scale.y = 1
		add_child(p)
		p.position = Vector2(160,100)
		p.start()
		p.connect("smoke_screen", p.get_parent(), "_on_smoke_screen")
		p.connect("smoke_screen_stop", p.get_parent(), "_on_smoke_screen_stop")
		p.connect("pepper_death", $player, "_on_pepper_death")

func _on_HUD_start_game():
	$empty_fridge.hide()
	$HUD/tutorial.hide()
	get_tree().call_group("mobs", "queue_free")
	$HUD/progress.show()
	$player.dead = false
	num_grapes = 0
	num_mushroom = 0
	#p = pepper.instance()
	$player.tutorial = false
	$start_menu.hide()
	$tutorial.hide()
	$produce_aisle.play()
	$background_1.show()
	$background_1/aisle_0/CollisionPolygon2D.disabled = false
	$background_1/aisle_1/CollisionPolygon2D.disabled = false
	$background_1/aisle_2/CollisionPolygon2D.disabled = false
	$background_1/aisle_3/CollisionPolygon2D.disabled = false
	$background_1/aisle_4/CollisionPolygon2D.disabled = false
	$background_1/aisle_5/CollisionPolygon2D.disabled = false
	$background_1/aisle_6/CollisionPolygon2D.disabled = false
	$background_1/aisle_7/CollisionPolygon2D.disabled = false
	$background_1/aisle_8/CollisionPolygon2D.disabled = false
	$player.start($start_position.position)
	$grapeTimer.start() # Replace with function body.

func _on_HUD_game_over():
	$empty_fridge.hide()
	$HUD/progress.hide()
	$HUD/progress.set_value(0)
	num_grapes = 0
	num_mushroom = 0
	$player.num_enemies_hit = 0
	$start_menu.show()
	game_start = false

func _on_HUD_tutorial():
	$empty_fridge.hide()
	$player.dead = false
	$player.tutorial = true
	$start_menu.hide()
	$HUD/start_button.hide()
	$HUD/message.hide()
	$background_1.hide()
	$background_1.hide()
	$background_1/aisle_0/CollisionPolygon2D.disabled = true
	$background_1/aisle_1/CollisionPolygon2D.disabled = true
	$background_1/aisle_2/CollisionPolygon2D.disabled = true
	$background_1/aisle_3/CollisionPolygon2D.disabled = true
	$background_1/aisle_4/CollisionPolygon2D.disabled = true
	$background_1/aisle_5/CollisionPolygon2D.disabled = true
	$background_1/aisle_6/CollisionPolygon2D.disabled = true
	$background_1/aisle_7/CollisionPolygon2D.disabled = true
	$background_1/aisle_8/CollisionPolygon2D.disabled = true
	
	$empty_fridge.show()
	yield(get_tree().create_timer(1.75), "timeout")
	$empty_fridge.hide()
	$dim_kitchen.show()
	$dim_kitchen/player.playing = true
	yield(get_tree().create_timer(0.75), "timeout")
	$dim_kitchen/exclamation.show()
	yield(get_tree().create_timer(0.75), "timeout")
	$dim_kitchen/player.playing = false
	$dim_kitchen/exclamation.hide()
	$dim_kitchen.hide()
	$tutorial.show()
	$player.start($start_position.position)
	$player.show()
	$tutorial.on_boarding() # Replace with function body.
	game_start = false
	
func _on_tutorial_done():
	$empty_fridge.hide()
	$dim_kitchen.hide()
	$HUD/start_button.show()

func _on_HUD_win():
	pass # Replace with function body.

func _on_pepper_off():
	$background_1.hide()


func _on_player_victory():
	$HUD/progress.hide()
	$HUD/progress.set_value(0)
	num_grapes = 0
	num_mushroom = 0
	$player.num_enemies_hit = 0
	$grapeTimer.stop()
	$mushroomTimer.stop()

	get_tree().call_group("mobs", "queue_free")
	$player.hide()
	$start_menu.show()
	$produce_aisle.stop()
	$victory.play()
	$victory.stop()
	game_start = false
	$HUD.show_congrats() # Replace with function body.


func _on_smoke_screen():
	$background_1.hide()
	start_hidden = true
	var mobs = get_tree().get_nodes_in_group("mobs")
	# Replace with function body.
	for mob in mobs:
		if "mushroom" in mob.name or "grape" in mob.name:
			if not mob.is_dead():
				mob.hide()
				mob.disable()
				$grapePath/grapeSpawnLocation.set_offset(randi())
				while $grapePath/grapeSpawnLocation.position.distance_to($player.position) < 100:
					$grapePath/grapeSpawnLocation.set_offset(randi())
				mob.position = $grapePath/grapeSpawnLocation.position

func _on_smoke_screen_stop():
	if start_hidden:
		var mobs = get_tree().get_nodes_in_group("mobs")
	# Replace with function body.
		for mob in mobs:
			if "mushroom" in mob.name or "grape" in mob.name:
				if not mob.is_dead():
					mob.show()
					mob.enable()
		$background_1.show()
		start_hidden = false #th function body.
func _increment():
	$HUD.update_progress()


func _on_player_level_1():
	$HUD/progress.hide()
	$HUD/progress.set_value(0)
	num_grapes = 0
	num_mushroom = 0
	$player.num_enemies_hit = 0
	$grapeTimer.stop()
	$mushroomTimer.stop()

	get_tree().call_group("mobs", "queue_free")
	$player.hide() 
	$produce_aisle.stop()
	$transition.show()
	# Replace with function body.
