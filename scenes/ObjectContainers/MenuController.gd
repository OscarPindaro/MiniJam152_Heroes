extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(NodePath) var exposer_path1 
export(NodePath) var exposer_path2

onready var exposer1 = get_node(exposer_path1)
onready var exposer2 = get_node(exposer_path2)

signal change_score(hero_score)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func on_kitchen_reached(hero):
	var item1: Item = exposer1.dish
	var item2: Item = exposer2.dish
	var dict1 = item1.get_property()
	var dict2 = item2.get_property()
	var new_points: float = hero.evaluate(dict1, dict2)["score"]
	emit_signal("change_score", new_points)