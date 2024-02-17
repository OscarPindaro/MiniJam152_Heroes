tool
extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var cooking : String = "default" setget set_cooking
var side_list = ["default", 'griglia', 'tagliato', 'fritto']
onready var anim_sprite: AnimatedSprite = $AnimatedSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	load_ingredient()

func _player_interact(item: Item) -> Item:
	if not Engine.editor_hint:
		if item == null:
			return null
		if item.Main == null:
			return item
		if item.Cooking != null:
			return item
		item.set_cooking(cooking)
	return item

func set_cooking(new_cooking):
	if new_cooking in side_list:
		cooking = new_cooking
	if is_inside_tree():
			load_ingredient()

func load_ingredient():
	anim_sprite.animation = cooking
	

func _on_Area2D_body_entered(body:Node):
	if not Engine.editor_hint:
		if body.is_in_group("player"):
			body.enter_area(self)



func _on_Area2D_body_exited(body:Node):
	if not Engine.editor_hint:
		if body.is_in_group("player"):
			body.exit_area(self)
