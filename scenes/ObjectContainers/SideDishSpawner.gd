tool
extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var side_dish: String = "" setget set_side_dish
onready var anim_sprite: AnimatedSprite = $AnimatedSprite

var side_list = ['pomodoro', 'insalata', 'patate']

# Called when the node enters the scene tree for the first time.
func _ready():
	load_ingredient()

func set_side_dish(new_side_dish):
	if new_side_dish in side_list:
		side_dish = new_side_dish
	if is_inside_tree():
			load_ingredient()

func load_ingredient():
	anim_sprite.animation = side_dish
	anim_sprite.play()

func _player_interact(item: Item) -> Item:
	if not Engine.editor_hint:
		if item == null:
			return null
		if item.Cooking == null:
			return item
		if item.Side != null:
			return item
		item.set_side(side_dish)
		return item
	return item

func _on_Area2D_body_entered(body:Node):
	if not Engine.editor_hint:
		if body.is_in_group("player"):
			body.enter_area(self)



func _on_Area2D_body_exited(body:Node):
	if not Engine.editor_hint:
		if body.is_in_group("player"):
			body.exit_area(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
