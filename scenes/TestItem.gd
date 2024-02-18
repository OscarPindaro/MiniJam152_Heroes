extends Node2D


var audioInteractionMainTheme


func _ready():
	audioInteractionMainTheme = get_node("MainMenuTheme")


func _process(delta):
	if audioInteractionMainTheme.is_playing() == false:
		audioInteractionMainTheme.play()	
