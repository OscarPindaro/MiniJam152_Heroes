extends Area2D
var item_scene = load("res://scenes/Objects/Item.tscn")
var item = null
signal new_item_entered
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	item = item_scene.initiate()
	
func set_new_item(newitem: Item):
	
	item.set_main(newitem.Main)
	item.set_side(newitem.Side)
	item.set_cooking(newitem.Cooking)
	emit_signal("new_item_entered", newitem)
	
	return
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
