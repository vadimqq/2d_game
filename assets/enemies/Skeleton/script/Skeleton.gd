extends "res://assets/script/physics.gd"

onready var sprite = get_node("sprites")
onready var animation = get_node("AnimationPlayer")
onready var playerDetectionZone = get_node("PlayerDetectionZone")
onready var playerAttackZone = get_node("PlayerAttackZone")
onready var stats = get_node("Stats")

enum {
	ATTACK,
	CHASE,
	IDLE,
	WANDER,
	DEATH
}

var state = IDLE
var CD_attack = false

func _process(delta):
	_MotionStop(stats.MaxSpeed)
	if stats.MaxHealth <= 0:
		state = DEATH
	match state:
		IDLE:
			idle_state()
			seek_player()
		CHASE:
			chase_state()
			seek_player()
		ATTACK:
			attack_state()
		WANDER:
			pass
		DEATH:
			death_state()


func seek_player():
	if playerAttackZone.can_see_player():
		Motion.x = lerp(Motion.x, 0 , 0.2)
		state = IDLE
		if CD_attack == false:
			state = ATTACK
	elif playerDetectionZone.can_see_player():
		state = CHASE

#Функции состояний
func chase_state():
	sprite_change("run")
	var player = playerDetectionZone.player
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		if direction.x > 0:
			_MotionRight()
			sprite.get_node("run").flip_h = false
			animation.play("run")
		if direction.x < 0:
			_MotionLeft()
			sprite.get_node("run").flip_h = true
			animation.play("run")
	else:
		state = IDLE

func idle_state():
	Motion.x = lerp(Motion.x, 0 , 0.2)
	sprite_change("idle")
	animation.play("idle")

func attack_state():
	sprite_change("attack")
	Motion.x = lerp(Motion.x, 0 , 0.2)
	var player = playerDetectionZone.player
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		if direction.x > 0:
			sprite.get_node("attack").flip_h = false
			animation.play("attack")
		if direction.x < 0:
			sprite.get_node("attack").flip_h = true
			animation.play("attack")
	else:
		state = IDLE

func death_state():
	sprite_change("death")
	animation.play("death")

func sprite_change(animation):
	for i in sprite.get_children():
		i.visible = false
		if i.name == animation:
			i.visible = true

func attack_finished():
	CD_attack = true
	state = CHASE
	yield(get_tree().create_timer(2.0), "timeout")
	CD_attack = false

func death_finished():
	queue_free()

func _on_hurtBox_area_entered(area):
	stats.MaxHealth -= area.damage
