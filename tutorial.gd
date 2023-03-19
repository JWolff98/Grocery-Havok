extends CanvasLayer
export (PackedScene) var grape
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
