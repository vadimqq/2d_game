extends Control


onready var endurence_bar = get_node("endurence")
onready var HP_bar = get_node("Hp")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Player_change_endurence(value):
	if endurence_bar.value > value:
		yield(get_tree().create_timer(0.1), "timeout")
		endurence_bar.value -= 3
	if endurence_bar.value <= value:
		endurence_bar.value = value


func _on_Player_change_HP(value):
	#if HP_bar.value > value:
	while HP_bar.value > value:
		yield(get_tree().create_timer(0.1), "timeout")
		HP_bar.value -= 1
	if HP_bar.value < value:
		HP_bar.value = value
