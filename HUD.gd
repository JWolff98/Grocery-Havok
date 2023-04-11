extends CanvasLayer
var game_played
signal start_game
signal game_over
signal win
signal tutorial
signal wave_1
signal wave_2
signal wave_3
signal pause
signal boss_start

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	game_played = false # Replace with function body.

func show_message(text):
	$message.text = text
	$message.show()
	$message_timer.start()
	
func show_game_over():
	#$heart_1.hide()
	#$heart_2.hide()
	#$heart_3.hide()
	emit_signal("game_over")
	show_message("Game Over")
	yield($message_timer, "timeout")
	#$message.text = "Grocery Havok\n JRM Inc."
	#$message.show()
	yield(get_tree().create_timer(1), "timeout")
	$message_timer.stop()
	$message.text = "Grocery Havok\nJRM Inc.\n\nRetry?"
	$message.show()
	$start_button.show()
	$tutorial.show()
	$boss.show()

func show_congrats():
	emit_signal("win")
	show_message("Congratulations!")
	yield($message_timer, "timeout")
	$message_timer.stop()
	$congrats.text = "You completed\nThe Game\nTry\nagain?"
	$congrats.show()
	$start_button.show()
	$tutorial.show()
	$boss.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_message_timer_timeout():
	$message.hide()


func _on_start_button_pressed():
	$start_button.hide()
	$message.hide()
	$congrats.hide()
	$tutorial.hide()
	$boss.hide()
	#$heart_1.animation = "full"
	#$heart_2.animation = "full"
	#$heart_3.animation = "full"
	#$heart_1.show()
	#$heart_2.show()
	#$heart_3.show()
	emit_signal("start_game")
	
func _on_tutorial_pressed():
	$start_button.hide()
	$tutorial.hide()
	$congrats.hide()
	$message.hide()
	$boss.hide()
	emit_signal("tutorial")
func update_progress():
	$progress.set_value($progress.get_value() + 1)


func _on_boss_pressed():
	$start_button.hide()
	$tutorial.hide()
	$congrats.hide()
	$message.hide()
	$boss.hide()
	emit_signal("boss_start") # Replace with function body.
