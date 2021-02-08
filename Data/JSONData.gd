extends Node

var item_data: Dictionary
var inventory_user: Dictionary

func _ready():
	item_data = LoadData("res://Data/ItemData.json")
	inventory_user = LoadData("res://Data/inventoryUser.json")

func LoadData(file_path):
	var json_data
	var file_data = File.new()
	file_data.open(file_path, File.READ)
	json_data = JSON.parse(file_data.get_as_text())
	file_data.close()
	return json_data.result
