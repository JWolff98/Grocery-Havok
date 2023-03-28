extends CanvasLayer
export (PackedScene) var grape = preload("res://grape.tscn")
export (PackedScene) var mushroom = preload("res://mushroom.tscn")
export (PackedScene) var pepper = preload("res://pepper.tscn")
signal done

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func on_boarding():
	var g = grape.instance()
	g.scale.x = 1.8
	g.scale.y = 1.8
	add_child(g)
	g.dead = true
	g.get_node("AnimatedSprite").animation = "move"
	g.get_node("AnimatedSprite").playing = true
	g.position = Vector2(139, 300)
	g.tutorial = true
	var m = mushroom.instance()
	m.scale.x = 1
	m.scale.y = 1
	add_child(m)
	m.dead = true
	m.position = Vector2(450, 300)
	m.tutorial = true

	m.get_node("AnimatedSprite").animation = "running"
	m.get_node("AnimatedSprite").playing = true
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

	yield(get_tree().create_timer(3), "timeout")
	$instructions.text = "So you decided\nto shop at\nJust Right Market"
	$instructions.show()
	
	yield(get_tree().create_timer(2), "timeout")
	$instructions.text = "Good Choice! Be Warned though\n\nthese items fight back"
	
	yield(get_tree().create_timer(2), "timeout")
	$instructions.text = "To complete your grocery list\nyou must prepare yourself!"
	
	yield(get_tree().create_timer(2), "timeout")
	$instructions.text = "Move using the 'awsd' keys\nAim wih the cursor\nShoot with the 'space' bar\n\nOnce ready click the 'start' button to start shopping"
	$instructions.show()
	emit_signal("done")
