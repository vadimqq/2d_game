extends KinematicBody2D

var Up = Vector2(0, -1)
var MaxSpeed = -50
var Accel = 20
var Motion = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	Motion.y -= Accel
	if Motion.y < MaxSpeed:
		Motion.y = MaxSpeed
		
	Motion = move_and_slide(Motion, Up)
