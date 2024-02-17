extends Area2D

onready var Main = 'Empty'
onready var Cooking = 'Empty'
onready var sprite = $AnimatedSprite
var sprite_frame = null
var base_path = 'res://asset/'
var extension = '.png'

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_frame = base_path + Main + Cooking + '.jpg'
	sprite.animation = sprite_frame
	pass # Replace with function body.

func set_property_main(newMain):
	Main = newMain
	sprite_frame = base_path + Main + Cooking + extension
	sprite.animation = sprite_frame

func set_property_cooking(newCooking):
	Cooking = newCooking
	sprite_frame = base_path + Main + Cooking + extension
	sprite.animation = sprite_frame



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
