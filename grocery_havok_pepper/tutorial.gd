extends CanvasLayer
export (PackedScene) var grape = preload("res://grape.tscn")
export (PackedScene) var mushroom = preload("res://mushroom.tscn")
export (PackedScene) var pepper = preload("res://pepper.tscn")
var area_entered
var vis
signal player_shot_an_enemy
signal done

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered = false 
	vis = false# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func on_boarding():
	area_entered = false
	vis = false	
	
	#var g = grape.instance()
	#g.scale.x = 1.8
	#g.scale.y = 1.8
	#add_child(g)
	#g.dead = true
	#g.get_node("AnimatedSprite").animation = "move"
	#g.get_node("AnimatedSprite").playing = true
	#g.position = Vector2(139, 300)
	#g.tutorial = true
	#g.hide()
	#var m = mushroom.instance()
	#m.scale.x = 1
	#m.scale.y = 1
	#add_child(m)
	#m.dead = true
	#m.position = Vector2(450, 300)
	#m.tutorial = true
	#m.hide()

	#m.get_node("AnimatedSprite").animation = "running"
	#m.get_node("AnimatedSprite").playing = true
	#var p = pepper.instance()
	#p.scale.x = 1
	#p.scale.y = 1
	#add_child(p)
	#p.dead = true
	#p.show()
	#p.tutorial = true
	#p.position = Vector2(450, 500)
	#p.get_node("AnimatedSprite").animation = "idle"
	#p.get_node("AnimatedSprite").playing = true
	$instructions.text = "Welcome\nPatron!"
	$instructions.show()
	yield(get_tree().create_timer(3), "timeout")
	$instructions.text = "So you decided\nto shop at\nJust Right Market"
	$instructions.show()
	
	yield(get_tree().create_timer(2), "timeout")
	$instructions.text = "Good Choice!\nWe have no doubt we can provide you\nthe ideal grocery store experience!"
	
	yield(get_tree().create_timer(3), "timeout")
	$instructions.text = "Before you enter\nYou need to demonstrate a few skills first"
	
	yield(get_tree().create_timer(3), "timeout")
	$instructions.text = "Move to the area highlighted in red\nUsing the \"AWSD\" keys"
	$instructions.show()
	$move_area.show()
	vis = true
	#emit_signal("done")


func _on_Area2D_body_entered(body):
	if not area_entered and vis:
		$instructions.text = "Great!\nUse the \"cursor\" to aim\nand the \"space\" bar to shoot one of the mobs below!"
		 # Replace with function body.
		var g = grape.instance()
		g.scale.x = 1.8
		g.scale.y = 1.8
		add_child(g)
		g.dead = true
		g.get_node("AnimatedSprite").animation = "move"
		g.get_node("AnimatedSprite").playing = true
		g.position = Vector2(139, 300)
		g.tutorial = true
		g.connect("grap_tutorial_shot", g.get_parent(), "_grape_shot")
		var m = mushroom.instance()
		m.scale.x = 1
		m.scale.y = 1
		add_child(m)
		m.dead = true
		m.position = Vector2(450, 300)
		m.tutorial = true
		m.get_node("AnimatedSprite").animation = "running"
		m.get_node("AnimatedSprite").playing = true
		m.connect("mush_tutorial_shot", m.get_parent(), "_mush_shot")
		var p = pepper.instance()
		p.scale.x = 1
		p.scale.y = 1
		add_child(p)
		p.dead = true
		p.show()
		p.tutorial = true
		p.position = Vector2(450, 500)
		p.get_node("AnimatedSprite").animation = "idle"
		p.get_node("AnimatedSprite").playing = true
		p.connect("pepp_tutorial_shot", p.get_parent(), "_pepp_shot")
		$move_area.hide()
		area_entered = true
func _grape_shot():
	$instructions.text = "Awesome!\nNote that JRM Inc. is not liable for any injuries upon your person\nPress the \"START\" button when you are ready to begin"
	emit_signal("done")
func _mush_shot():
	$instructions.text = "Awesome!\nNote that JRM Inc. is not liable for any injuries upon your person\nPress the \"START\" button when you are ready to begin"
	emit_signal("done")
func _pepp_shot():
	$instructions.text = "Awesome!\nNote that JRM Inc. is not liable for any injuries upon your person\nPress the \"START\" button when you are ready to begin"
	emit_signal("done")
		
		
