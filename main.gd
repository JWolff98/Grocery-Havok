extends Node
export (PackedScene) var grape
export (PackedScene) var mushroom
export (PackedScene) var magic_smoke
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
var boss = false
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
	$HUD/progress.hide()
	$HUD/progress.set_value(0)
	$boss_fight/general_manager.disable()
	$boss_fight.hide()
	num_grapes = 0
	num_mushroom = 0
	$player.num_enemies_hit = 0
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
	boss = false
	$empty_fridge.hide()
	$HUD/tutorial.hide()
	get_tree().call_group("mobs", "queue_free")
	$HUD/progress.show()
	$player.dead = false
	num_grapes = 0
	num_mushroom = 0
	$HUD/progress.max_value = 23
	$HUD/progress.set_value(0)
	#p = pepper.instance()
	$player.tutorial = false
	$start_menu.hide()
	$tutorial.hide()
	$boss_fight.hide()
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
	boss = false

func _on_HUD_tutorial():
	boss = false
	$empty_fridge.hide()
	$player.dead = false
	$player.tutorial = true
	$start_menu.hide()
	$HUD/start_button.hide()
	$HUD/boss.hide()
	$boss_fight.hide()
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
	boss = false
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
	$magic_smoke.show()
	$magic_smoke/AnimatedSprite.playing = true
	$magic_smoke2.show()
	$magic_smoke2/AnimatedSprite.playing = true
	$magic_smoke3.show()
	$magic_smoke3/AnimatedSprite.playing = true
	$magic_smoke4.show()
	$magic_smoke4/AnimatedSprite.playing = true
	$magic_smoke5.show()
	$magic_smoke5/AnimatedSprite.playing = true
	$magic_smoke6.show()
	$magic_smoke6/AnimatedSprite.playing = true
	$magic_smoke7.show()
	$magic_smoke7/AnimatedSprite.playing = true
	$magic_smoke8.show()
	$magic_smoke8/AnimatedSprite.playing = true
	$magic_smoke9.show()
	$magic_smoke9/AnimatedSprite.playing = true
	$magic_smoke10.show()
	$magic_smoke10/AnimatedSprite.playing = true
	$magic_smoke11.show()
	$magic_smoke11/AnimatedSprite.playing = true
	$magic_smoke12.show()
	$magic_smoke12/AnimatedSprite.playing = true
	$magic_smoke13.show()
	$magic_smoke13/AnimatedSprite.playing = true
	$magic_smoke14.show()
	$magic_smoke14/AnimatedSprite.playing = true
	$magic_smoke15.show()
	$magic_smoke15/AnimatedSprite.playing = true
	$magic_smoke16.show()
	$magic_smoke16/AnimatedSprite.playing = true
	$magic_smoke17.show()
	$magic_smoke17/AnimatedSprite.playing = true
	$magic_smoke18.show()
	$magic_smoke18/AnimatedSprite.playing = true
	$magic_smoke19.show()
	$magic_smoke19/AnimatedSprite.playing = true
	$magic_smoke20.show()
	$magic_smoke20/AnimatedSprite.playing = true
	$magic_smoke21.show()
	$magic_smoke21/AnimatedSprite.playing = true
	$magic_smoke22.show()
	$magic_smoke22/AnimatedSprite.playing = true
	$magic_smoke23.show()
	$magic_smoke23/AnimatedSprite.playing = true
	$magic_smoke24.show()
	$magic_smoke24/AnimatedSprite.playing = true
	$magic_smoke25.show()
	$magic_smoke25/AnimatedSprite.playing = true
	$magic_smoke26.show()
	$magic_smoke26/AnimatedSprite.playing = true
	$magic_smoke27.show()
	$magic_smoke27/AnimatedSprite.playing = true
	$magic_smoke28.show()
	$magic_smoke28/AnimatedSprite.playing = true
	$magic_smoke29.show()
	$magic_smoke29/AnimatedSprite.playing = true
	$magic_smoke30.show()
	$magic_smoke30/AnimatedSprite.playing = true
	$magic_smoke31.show()
	$magic_smoke31/AnimatedSprite.playing = true
	$magic_smoke32.show()
	$magic_smoke32/AnimatedSprite.playing = true
	$magic_smoke33.show()
	$magic_smoke33/AnimatedSprite.playing = true
	$magic_smoke34.show()
	$magic_smoke34/AnimatedSprite.playing = true
	$magic_smoke35.show()
	$magic_smoke35/AnimatedSprite.playing = true
	$magic_smoke36.show()
	$magic_smoke36/AnimatedSprite.playing = true
	$magic_smoke37.show()
	$magic_smoke37/AnimatedSprite.playing = true
	$magic_smoke38.show()
	$magic_smoke38/AnimatedSprite.playing = true
	$magic_smoke39.show()
	$magic_smoke39/AnimatedSprite.playing = true
	$magic_smoke40.show()
	$magic_smoke40/AnimatedSprite.playing = true
	$magic_smoke41.show()
	$magic_smoke41/AnimatedSprite.playing = true
	
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
		$magic_smoke.hide()
		$magic_smoke/AnimatedSprite.playing = false
		$magic_smoke2.hide()
		$magic_smoke2/AnimatedSprite.playing = false
		$magic_smoke3.hide()
		$magic_smoke3/AnimatedSprite.playing = false
		$magic_smoke4.hide()
		$magic_smoke4/AnimatedSprite.playing = false
		$magic_smoke5.hide()
		$magic_smoke5/AnimatedSprite.playing = false
		$magic_smoke6.hide()
		$magic_smoke6/AnimatedSprite.playing = false
		$magic_smoke7.hide()
		$magic_smoke7/AnimatedSprite.playing = false
		$magic_smoke8.hide()
		$magic_smoke8/AnimatedSprite.playing = false
		$magic_smoke9.hide()
		$magic_smoke9/AnimatedSprite.playing = false
		$magic_smoke10.hide()
		$magic_smoke10/AnimatedSprite.playing = false
		$magic_smoke11.hide()
		$magic_smoke11/AnimatedSprite.playing = false
		$magic_smoke12.hide()
		$magic_smoke12/AnimatedSprite.playing = false
		$magic_smoke13.hide()
		$magic_smoke13/AnimatedSprite.playing = false
		$magic_smoke14.hide()
		$magic_smoke14/AnimatedSprite.playing = false
		$magic_smoke15.hide()
		$magic_smoke15/AnimatedSprite.playing = false
		$magic_smoke16.hide()
		$magic_smoke16/AnimatedSprite.playing = false
		$magic_smoke17.hide()
		$magic_smoke17/AnimatedSprite.playing = false
		$magic_smoke18.hide()
		$magic_smoke18/AnimatedSprite.playing = false
		$magic_smoke19.hide()
		$magic_smoke19/AnimatedSprite.playing = false
		$magic_smoke20.hide()
		$magic_smoke20/AnimatedSprite.playing = false
		$magic_smoke21.hide()
		$magic_smoke21/AnimatedSprite.playing = false
		$magic_smoke22.hide()
		$magic_smoke22/AnimatedSprite.playing = false
		$magic_smoke23.hide()
		$magic_smoke23/AnimatedSprite.playing = false
		$magic_smoke24.hide()
		$magic_smoke24/AnimatedSprite.playing = false
		$magic_smoke25.hide()
		$magic_smoke25/AnimatedSprite.playing = false
		$magic_smoke26.hide()
		$magic_smoke26/AnimatedSprite.playing = false
		$magic_smoke27.hide()
		$magic_smoke27/AnimatedSprite.playing = false
		$magic_smoke28.hide()
		$magic_smoke28/AnimatedSprite.playing = false
		$magic_smoke29.hide()
		$magic_smoke29/AnimatedSprite.playing = false
		$magic_smoke30.hide()
		$magic_smoke30/AnimatedSprite.playing = false
		$magic_smoke31.hide()
		$magic_smoke31/AnimatedSprite.playing = false
		$magic_smoke32.hide()
		$magic_smoke32/AnimatedSprite.playing = false
		$magic_smoke33.hide()
		$magic_smoke33/AnimatedSprite.playing = false
		$magic_smoke34.hide()
		$magic_smoke34/AnimatedSprite.playing = false
		$magic_smoke35.hide()
		$magic_smoke35/AnimatedSprite.playing = false
		$magic_smoke36.hide()
		$magic_smoke36/AnimatedSprite.playing = false
		$magic_smoke37/AnimatedSprite.hide()
		$magic_smoke37/AnimatedSprite.playing = false
		$magic_smoke38.hide()
		$magic_smoke38/AnimatedSprite.playing = false
		$magic_smoke39.hide()
		$magic_smoke39/AnimatedSprite.playing = false
		$magic_smoke40.hide()
		$magic_smoke40/AnimatedSprite.playing = false
		$magic_smoke41.hide()
		$magic_smoke41/AnimatedSprite.playing = false
		start_hidden = false #th function body.
func _increment():
	$HUD.update_progress(boss)


func _on_player_level_1():
	$magic_smoke/AnimatedSprite.playing = false
	$magic_smoke2.hide()
	$magic_smoke2/AnimatedSprite.playing = false
	$magic_smoke3.hide()
	$magic_smoke3/AnimatedSprite.playing = false
	$magic_smoke4.hide()
	$magic_smoke4/AnimatedSprite.playing = false
	$magic_smoke5.hide()
	$magic_smoke5/AnimatedSprite.playing = false
	$magic_smoke6.hide()
	$magic_smoke6/AnimatedSprite.playing = false
	$magic_smoke7.hide()
	$magic_smoke7/AnimatedSprite.playing = false
	$magic_smoke8.hide()
	$magic_smoke8/AnimatedSprite.playing = false
	$magic_smoke9.hide()
	$magic_smoke9/AnimatedSprite.playing = false
	$magic_smoke10.hide()
	$magic_smoke10/AnimatedSprite.playing = false
	$magic_smoke11.hide()
	$magic_smoke11/AnimatedSprite.playing = false
	$magic_smoke12.hide()
	$magic_smoke12/AnimatedSprite.playing = false
	$magic_smoke13.hide()
	$magic_smoke13/AnimatedSprite.playing = false
	$magic_smoke14.hide()
	$magic_smoke14/AnimatedSprite.playing = false
	$magic_smoke15.hide()
	$magic_smoke15/AnimatedSprite.playing = false
	$magic_smoke16.hide()
	$magic_smoke16/AnimatedSprite.playing = false
	$magic_smoke17.hide()
	$magic_smoke17/AnimatedSprite.playing = false
	$magic_smoke18.hide()
	$magic_smoke18/AnimatedSprite.playing = false
	$magic_smoke19.hide()
	$magic_smoke19/AnimatedSprite.playing = false
	$magic_smoke20.hide()
	$magic_smoke20/AnimatedSprite.playing = false
	$magic_smoke21.hide()
	$magic_smoke21/AnimatedSprite.playing = false
	$magic_smoke22.hide()
	$magic_smoke22/AnimatedSprite.playing = false
	$magic_smoke23.hide()
	$magic_smoke23/AnimatedSprite.playing = false
	$magic_smoke24.hide()
	$magic_smoke24/AnimatedSprite.playing = false
	$magic_smoke25.hide()
	$magic_smoke25/AnimatedSprite.playing = false
	$magic_smoke26.hide()
	$magic_smoke26/AnimatedSprite.playing = false
	$magic_smoke27.hide()
	$magic_smoke27/AnimatedSprite.playing = false
	$magic_smoke28.hide()
	$magic_smoke28/AnimatedSprite.playing = false
	$magic_smoke29.hide()
	$magic_smoke29/AnimatedSprite.playing = false
	$magic_smoke30.hide()
	$magic_smoke30/AnimatedSprite.playing = false
	$magic_smoke31.hide()
	$magic_smoke31/AnimatedSprite.playing = false
	$magic_smoke32.hide()
	$magic_smoke32/AnimatedSprite.playing = false
	$magic_smoke33.hide()
	$magic_smoke33/AnimatedSprite.playing = false
	$magic_smoke34.hide()
	$magic_smoke34/AnimatedSprite.playing = false
	$magic_smoke35.hide()
	$magic_smoke35/AnimatedSprite.playing = false
	$magic_smoke36.hide()
	$magic_smoke36/AnimatedSprite.playing = false
	$magic_smoke37/AnimatedSprite.hide()
	$magic_smoke37/AnimatedSprite.playing = false
	$magic_smoke38.hide()
	$magic_smoke38/AnimatedSprite.playing = false
	$magic_smoke39.hide()
	$magic_smoke39/AnimatedSprite.playing = false
	$magic_smoke40.hide()
	$magic_smoke40/AnimatedSprite.playing = false
	$magic_smoke41.hide()
	$magic_smoke41/AnimatedSprite.playing = false
	start_hidden = false 
	boss = false
	$HUD/progress.hide()
	$HUD/progress.max_value = 23
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
	$transition.start()
	$HUD/progress.max_value = 15
	$HUD/progress.set_value(15)
	# Replace with function body.


func _on_HUD_boss_start():
	$produce_aisle.stop()
	$transition.show()
	$transition.start()
	$HUD/progress.max_value = 15
	$HUD/progress.set_value(15)


func _on_transition_transition_done():
	$start_menu.hide()
	$HUD/start_button.hide()
	$HUD/boss.hide()
	$HUD/message.hide()
	$background_1.hide()
	$empty_fridge.hide()
	$HUD/tutorial.hide()
	get_tree().call_group("mobs", "queue_free")
	$boss_fight/general_manager.position = Vector2(300, 300)
	$HUD/progress.show()
	$player.dead = false
	$player.position = Vector2(475, 500)
	#p = pepper.instance()
	$player.tutorial = false
	boss = true
	$player.show()
	$start_menu.hide()
	$tutorial.hide()
	$produce_aisle.play()
	$background_1/aisle_0/CollisionPolygon2D.disabled = true
	$background_1/aisle_1/CollisionPolygon2D.disabled = true
	$background_1/aisle_2/CollisionPolygon2D.disabled = true
	$background_1/aisle_3/CollisionPolygon2D.disabled = true
	$background_1/aisle_4/CollisionPolygon2D.disabled = true
	$background_1/aisle_5/CollisionPolygon2D.disabled = true
	$background_1/aisle_6/CollisionPolygon2D.disabled = true
	$background_1/aisle_7/CollisionPolygon2D.disabled = true
	$background_1/aisle_8/CollisionPolygon2D.disabled = true
	$boss_fight.show()
	$boss_fight/general_manager.position = Vector2(300, 300)
	$boss_fight/general_manager.enable()
	$boss_fight/general_manager.current_hp = $boss_fight/general_manager.max_hp
	$boss_fight/general_manager/AnimatedSprite.animation = "float"
	$boss_fight/general_manager.dead = false# Replace with function body.


func _on_general_manager_boss_death():
	$HUD/progress.hide()
	$HUD/progress.set_value(0)
	$boss_fight/general_manager.disable()
	$boss_fight.hide()
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
	$HUD.show_congrats()
	boss = false


func _on_death_zone_1_body_entered(body):
	if body.is_in_group("player") and boss:
		$player.dead = true
		$player/AnimatedSprite.play("exhaustion")
		yield($player/AnimatedSprite, "animation_finished")
		$player.emit_signal("hit")
		$player.hide() # Replace with function body.


func _on_general_manager_boss_hit():
	_increment() # Replace with function body.


func _on_death_zone_2_body_entered(body): # Replace with function body.
	if body.is_in_group("player") and boss:
		$player.dead = true
		$player/AnimatedSprite.play("exhaustion")
		yield($player/AnimatedSprite, "animation_finished")
		$player.emit_signal("hit")
		$player.hide()

func _on_death_zone_3_body_entered(body):
	if body.is_in_group("player") and boss:
		$player.dead = true
		$player/AnimatedSprite.play("exhaustion")
		yield($player/AnimatedSprite, "animation_finished")
		$player.emit_signal("hit")
		$player.hide()

func _on_death_zone_4_body_entered(body):
	if body.is_in_group("player") and boss:
		$player.dead = true
		$player/AnimatedSprite.play("exhaustion")
		yield($player/AnimatedSprite, "animation_finished")
		$player.emit_signal("hit")
		$player.hide()
