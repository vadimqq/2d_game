extends Node2D

var step = 0
var radius = 192
export var move_to = Vector2.RIGHT * 192
export var speed = 100.0

const IDLE_DURATION = 1.0

onready var platform = get_node("Platform")
onready var tween = get_node("MoveTween")

func _ready():
	_init_tween()

func _init_tween():
	var duration = move_to.length() / float(speed)
	tween.interpolate_property(platform, "position", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, IDLE_DURATION)
	tween.interpolate_property(platform, "position", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + IDLE_DURATION * 2)
	tween.start()
