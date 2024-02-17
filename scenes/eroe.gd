extends Area2D

const playerGroup = "player"

# To assign before adding as a child
var sprite : SpriteFrames
var destination : Vector2
var speed : float
var preferences : Array
var dish_texture : Texture

# Called when the node enters the scene tree for the first time.
func _ready():
	$NavigationAgent2D.set_target_location(destination)
	if sprite != null:
		$AnimatedSprite.frames = sprite
		$AnimatedSprite.play()
	if dish_texture != null:
		$CompositeBaloon/DishSprite.texture = dish_texture

func _physics_process(delta):
	if $NavigationAgent2D.is_target_reached():
		return
	
	# Move to next location accounting for speed and delta
	var next_location = $NavigationAgent2D.get_next_location()
	var direction = (next_location - global_position).normalized()
	var movement_delta = speed * delta
	var velocity = direction * movement_delta
	global_position = global_position + velocity


func _on_eroe_body_entered(body):
	if body.is_in_group(playerGroup):
		$CompositeBaloon.visible = true


func _on_eroe_body_exited(body):
	if body.is_in_group(playerGroup):
		$CompositeBaloon.visible = false
