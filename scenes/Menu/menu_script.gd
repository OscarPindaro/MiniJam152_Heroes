extends Node2D

onready var Slot1 = []
onready var Slot2 = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Slot1_new_item_entered(newitem):
	Slot1[0] = newitem.Main
	Slot1[1] = newitem.Coooking
	Slot1[2] = newitem.Side
	

	pass # Replace with function body.
