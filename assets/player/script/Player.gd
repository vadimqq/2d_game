extends "res://assets/script/physics.gd"


func _process(delta):
	_MotionStop()
	
	if Input.is_action_pressed("run_right"):
		_MotionRight()
	elif Input.is_action_pressed("run_left"):
		_MotionLeft()
	else:
		Motion.x = lerp(Motion.x, 0 , 0.2)

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			Motion.y = -JumpForce

func _input(event):
	if event.is_action_pressed("pickup"):
		if $PickupZone.items_in_range.size() > 0:
			var pickup_item = $PickupZone.items_in_range.values()[0]
			pickup_item.pick_up_item(self)
			$PickupZone.items_in_range.erase(pickup_item)
