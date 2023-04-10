extends KinematicBody2D

var max_hp = 2800
var current_hp

onready var navigation_agent = $NavigationAgent2D
var screen_size
var speed = 150
var frameTimer
var framedVelocity
var dead = false
var tutorial = false
var hit = false
var is_freed = false
var disabled = false
signal boss_death

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
