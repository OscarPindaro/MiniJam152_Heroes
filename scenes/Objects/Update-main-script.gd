extends Area2D

onready var Main = 'Empty'
onready var Cooking = ''
onready var sprite = $AnimatedSprite
var sprite_frame = null

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_frame = Main + Cooking
	sprite.animation = sprite_frame
	pass # Replace with function body.

func set_property_main(newMain):
	Main = newMain
	sprite_frame = Main + Cooking
	sprite.animation = sprite_frame

func set_property_cooking(newCooking):
	Cooking = newCooking
	sprite_frame = Main + Cooking
	sprite.animation = sprite_frame

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
