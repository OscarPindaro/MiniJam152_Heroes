extends Area2D

onready var sprite = $AnimatedSprite
var base_path = 'res://asset/'
var extension = '.png'
var Side = 'EmptyEmpty'
var sprite_frame = null
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_frame = base_path + Side + '.jpg'
	sprite.animation = sprite_frame
	pass # Replace with function body.

func set_side(newSide):
	Side = newSide
	sprite_frame = base_path + Side + '.jpg'
	sprite.animation = sprite_frame

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
