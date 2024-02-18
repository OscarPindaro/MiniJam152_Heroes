extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var item_scene = load("res://scenes/Objects/Item.tscn")
export var main = ""
export var baloonSide = "left"
var baloonSide_list = ['right', 'left']

var dish: Item = null

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(baloonSide in baloonSide_list)
	if(baloonSide == "right"):
		$BaloonAnchor.transform.x = - $BaloonAnchor.transform.x
	pass # Replace with function body.

func _player_interact(item: Item) -> Item:
	if item == null:
		return null
	if item.Side == null:
		return item
	if dish != null:
		dish.queue_free()
	$ItemAnchor.add_child(item)
	$AudioStreamPlayer.play()

	item.position = Vector2.ZERO
	dish = item
	$FoodTimer.stop()
	$FlickerTimer.stop()
	$VanishingTimer.stop()
	
	$BaloonAnchor.get_node("DishBaloon").update_dish(dish.get_property())
	
	$FoodTimer.start()
	# samuele se, era none l'item, deve fare add_child
	return null
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func get_dish():
	if dish == null:
		return Item.new()
	return dish

func _on_Area2D_body_entered(body:Node):
	if body.is_in_group("player"):
		body.enter_area(self)



func _on_Area2D_body_exited(body:Node):
	if body.is_in_group("player"):
		body.exit_area(self)


func _on_FoodTimer_timeout():
	$FoodTimer.stop()
	$FlickerTimer.start()
	$VanishingTimer.start()


func _on_FlickerTimer_timeout():
	dish.visible = !dish.visible


func _on_VanishingTimer_timeout():
	$VanishingTimer.stop()
	dish.queue_free()
	dish = null
	$BaloonAnchor.get_node("DishBaloon").update_dish(null)
	$FlickerTimer.stop()
