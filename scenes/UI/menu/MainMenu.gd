extends Control

export(PackedScene) var game_scene

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var audioInteractionMainMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	audioInteractionMainMenu = get_node("MainMenuTheme")
	audioInteractionMainMenu.play()	
	

func _on_PlayButton_pressed():
	get_tree().change_scene_to(game_scene)

func _process(delta):
	if audioInteractionMainMenu.is_playing() == false:
		audioInteractionMainMenu.play()	
	
