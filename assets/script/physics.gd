extends KinematicBody2D

var Up = Vector2(0, -1)
var Gravity = 25
var MaxFallSpeed = 500
var Accel = 20
var Motion = Vector2()
var JumpForce = 600


func _physics_process(delta):
	Motion.y += Gravity
	
	if Motion.y > MaxFallSpeed:
		Motion.y = MaxFallSpeed
		
	Motion = move_and_slide(Motion, Up)

func _MotionStop(MaxSpeed):
	Motion.x = clamp(Motion.x, -MaxSpeed, MaxSpeed)

func _MotionRight():
	Motion.x += Accel

func _MotionLeft():
	Motion.x -= Accel
