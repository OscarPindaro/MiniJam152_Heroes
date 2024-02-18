tool
extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var item_scene = load("res://scenes/Objects/Item.tscn")
export var main: String = "" setget set_main
onready var anim_sprite: AnimatedSprite = $AnimatedSprite


var main_list = ['bistecca', 'pesce', 'melanzana', 'fungo']

var audioInteractionPrincipal

# Called when the node enters the scene tree for the first time.
func _ready():
	audioInteractionPrincipal = get_node("AudioStreamPlayer2D")
	load_ingredient()

func set_main(new_main):
	if new_main in main_list:
		main = new_main
	if is_inside_tree():
			load_ingredient()

func load_ingredient():
	anim_sprite.animation = main

func _player_interact(item: Item) -> Item:
	if not Engine.editor_hint:
		if item != null:
			return item
		# missing code because i need maff code
		item = item_scene.instance()
		item.Main = main
		audioInteractionPrincipal.play()
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
