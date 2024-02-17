extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var side_dish = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _player_interact(item):
	if item == null:
		return null
	if item.Cooking != null:
		return item
	item.side_dish = side_dish
	return item


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
