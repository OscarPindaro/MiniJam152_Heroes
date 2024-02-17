extends Area2D

const playerGroup = "player"
const tag_texture_scene = preload("res://scenes/tag_texture.tscn")
const textures_base_path = "res://asset/texture/"
const textures_extension = ".png"

# To assign before adding as a child
var sprite : SpriteFrames
var destination : Vector2
var speed : float
var preferences : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set navigation destination
	$NavigationAgent2D.set_target_location(destination)
	
	# Set animated sprite
	if sprite != null:
		$AnimatedSprite.frames = sprite
		$AnimatedSprite.play()
	
	# Populate baloon box by instancing tag_texture(s)
	if preferences != null:
		for tag in preferences:
			var individual_tag = tag_texture_scene.instance()
			
			var texture_path = textures_base_path + tag + textures_extension
			individual_tag.tag_texture = load(texture_path)
			
			$BaloonUI/TagsContainer.add_child(individual_tag)

func _physics_process(delta):
	if $NavigationAgent2D.is_target_reached():
		# TODO: emit signal
		return
	
	# Move to next location accounting for speed and delta
	var next_location = $NavigationAgent2D.get_next_location()
	var direction = (next_location - global_position).normalized()
	var movement_delta = speed * delta
	var velocity = direction * movement_delta
	global_position = global_position + velocity


func _on_eroe_body_entered(body):
	if body.is_in_group(playerGroup):
		$BaloonUI.visible = true


func _on_eroe_body_exited(body):
	if body.is_in_group(playerGroup):
		$BaloonUI.visible = false
