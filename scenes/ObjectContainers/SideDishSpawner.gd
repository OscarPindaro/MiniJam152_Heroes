extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var side_dish: String = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _player_interact(item: Item) -> Item:
	if item == null:
		return null
	if item.Cooking != null:
		return item
	item.set_side(side_dish)
	return item

func _on_Area2D_body_entered(body:Node):
	if body.is_in_group("player"):
		body.enter_area(self)



func _on_Area2D_body_exited(body:Node):
	if body.is_in_group("player"):
		body.exit_area(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass