extends "res://assets/script/physics.gd"

onready var animation = get_node("hero_1/AnimationPlayer")
onready var sprite = get_node("hero_1")
onready var collisionBody = get_node("CollisionShape2D")
onready var stats = get_node("Stats")
onready var HP = stats.MaxHealth
onready var hitbox = get_node("hitboxPivot")
onready var sword = get_node("hitboxPivot/hitbox")

enum {
	MOVE,
	JUMP,
	FLY,
	ATTACK_1,
	ATTACK_2,
	DASH,
	DEATH
}
enum {
	REGEN,
	WASTE
}

var state = MOVE
var endurence_state = REGEN
var dashSpeed = 500
var endurence = 100
var starting_positon

signal change_endurence
signal change_HP
signal regen_HP

func _ready():
	sword.damage = stats.Damage
	starting_positon = position

func _process(delta):
	_MotionStop(stats.MaxSpeed)
	if endurence < 100:
		emit_signal("change_endurence", endurence)
	match state:
		MOVE:
			move_state()
		JUMP:
			jump_state()
		ATTACK_1:
			attack_1_state()
		ATTACK_2:
			attack_2_state()
		DASH:
			dash_state()
		FLY:
			fly_state()
		DEATH:
			death_state()
	match endurence_state:
		REGEN:
			regen_endurence_state()
		WASTE:
			waste_endurence_state()
#Функции состояний игрока
func move_state():
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
		if endurence > 20:
			waste_endurence(20)
			state = DASH
	if Input.is_action_just_pressed("attack"):
		if endurence > 30:
			waste_endurence(30)
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
	if Input.is_action_pressed("run_right"):
		_MotionRight()
		sprite.flip_h = false
	elif Input.is_action_pressed("run_left"):
		_MotionLeft()
		sprite.flip_h = true
	if !is_on_floor():
		if Motion.y < 0:
			animation.play("fly")
		elif Motion.y > 0:
			animation.play("fall")
	else:
		state = MOVE

func attack_1_state():
	Motion.x = lerp(Motion.x, 0 , 0.2)
	if sprite.flip_h == true:
		hitbox.scale.x = -1
	else:
		hitbox.scale.x = 1
	animation.play("attack_1")

func attack_2_state():
	animation.play("attack_2")

func death_state():
	animation.play("death")

func waste_endurence_state():
	yield(get_tree().create_timer(2.0), "timeout")
	endurence_state = REGEN

func regen_endurence_state():
	if endurence < 100:
		endurence += 1
	elif endurence >= 100:
		endurence = 100

#Вызовы в конец анимаци
func dash_finished():
	state = MOVE

func jump_finished():
	Motion.y = -JumpForce
	state = FLY

#Система боя
func attack_1_finished():
	if Input.is_action_pressed("attack"):
		if endurence > 60:
			waste_endurence(60)
			state = ATTACK_2
		else:
			state = MOVE
	else:
		state = MOVE

func attack_2_finished():
	state = MOVE

func death_finished():
	animation.stop()
	#yield(get_tree().create_timer(2.0), "timeout")
	position = starting_positon
	HP = stats.MaxHealth
	emit_signal("regen_HP", stats.MaxHealth)
	state = MOVE

func waste_endurence(value):
	endurence -= value
	endurence_state = WASTE

func _on_hurtBox_area_entered(area):
	HP -= area.damage
	var value_percent = (1000 / stats.MaxHealth * HP) / 10
	if HP <= 0:
		state = DEATH
	else:
		emit_signal("change_HP", value_percent)
