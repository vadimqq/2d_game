extends "res://assets/script/physics.gd"

var dashSpeed = 500
var endurence = 100
onready var animation = get_node("hero_1/AnimationPlayer")
onready var sprite = get_node("hero_1")
enum {
	MOVE,
	JUMP,
	FLY,
	FALL,
	ATTACK_1,
	ATTACK_2,
	DASH
}
var state = MOVE

func _ready():
	pass

func _process(delta):
	_MotionStop()
	match state:
		MOVE:
			move_state()
		JUMP:
			jump_state()
		FALL:
			pass
		ATTACK_1:
			attack_1_state()
		ATTACK_2:
			attack_2_state()
		DASH:
			dash_state()
		FLY:
			fly_state()
#Функции состояний игрока
func move_state():
	reg_endurence()
	if Input.is_action_pressed("run_right"):
		_MotionRight()
		animation.play("run")
		sprite.flip_h = false
	elif Input.is_action_pressed("run_left"):
		_MotionLeft()
		animation.play("run")
		sprite.flip_h = true
	else:
		Motion.x = lerp(Motion.x, 0 , 0.2)
		animation.play("idle")

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			state = JUMP
	if Input.is_action_just_pressed("dash"):
		state = DASH
	if Input.is_action_just_pressed("attack"):
		if endurence > 30:
			state = ATTACK_1

func dash_state():
	if sprite. flip_h == true:
		Motion.x = -dashSpeed
	elif sprite. flip_h == false:
		Motion.x = dashSpeed
	animation.play("dash")

func jump_state():
	animation.play("jump")

func fly_state():
	if !is_on_floor():
		if Motion.y < 0:
			animation.play("fly")
		elif Motion.y > 0:
			animation.play("fall")
	else:
		state = MOVE

func attack_1_state():
	Motion.x = lerp(Motion.x, 0 , 0.2)
	animation.play("attack_1")

func attack_2_state():
	animation.play("attack_2")

#Вызовы в конец анимаци
func dash_finished():
	state = MOVE

func jump_finished():
	Motion.y = -JumpForce
	state = FLY

#Система боя
func attack_1_finished():
	endurence -= 30
	if Input.is_action_pressed("attack"):
		if endurence > 60:
			state = ATTACK_2
		else:
			state = MOVE
	else:
		state = MOVE

func attack_2_finished():
	endurence -= 60
	state = MOVE

#Востановление выносливости
func reg_endurence():
	if endurence < 100:
		yield(get_tree().create_timer(1.0), "timeout")
		endurence += 0.5
	if endurence > 100:
		endurence = 100
