extends Control

export(PackedScene) var game_scene

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_PlayButton_pressed():
	get_tree().change_scene_to(game_scene)
