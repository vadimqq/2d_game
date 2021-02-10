extends Control


onready var endurenceBar = get_node("endurence")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Player_change_endurence(value):
	endurenceBar.value = value
