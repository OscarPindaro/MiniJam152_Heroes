extends Area2D

onready var sprite = $AnimatedSprite

onready var sprite_frame = 'Empty'
# Called when the node enters the scene tree for the first time.nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnny
func _ready():
	sprite.animation = sprite_frame
	pass # Replace with function body.

func set_side(newSide):
	sprite_frame = newSide
	sprite.animation = sprite_frame

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
