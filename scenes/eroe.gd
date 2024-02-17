extends Area2D

# To assign before adding as a child
var sprite : SpriteFrames
var destination : Vector2
var speed : float
var likes : Array
var dislikes : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	$NavigationAgent2D.set_target_location(destination)
	if sprite != null:
		$AnimatedSprite.frames = sprite
		$AnimatedSprite.play()

func _physics_process(delta):
	if $NavigationAgent2D.is_target_reached():
		return
	
	# Move to next location accounting for speed and delta
	var next_location = $NavigationAgent2D.get_next_location()
	var direction = (next_location - global_position).normalized()
	var movement_delta = speed * delta
	var velocity = direction * movement_delta
	global_position = global_position + velocity
