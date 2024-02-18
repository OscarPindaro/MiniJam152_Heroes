extends Node2D


var audioInteractionMainTheme
onready var rush_music: AudioStreamPlayer = $RushMusic
onready var after_rush: AudioStreamPlayer = $AfterRush

func _ready():
	audioInteractionMainTheme = get_node("MainMenuTheme")
	audioInteractionMainTheme.play()	


func _process(delta):
	pass


func _on_SpawnerEroi_rushHour_start():
	audioInteractionMainTheme.stop()
	after_rush.stop()
	rush_music.play()


func _on_SpawnerEroi_rushHour_end():
	rush_music.stop()
	after_rush.stop()
