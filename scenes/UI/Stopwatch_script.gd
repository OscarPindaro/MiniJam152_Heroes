extends Label

var time_elapsed = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	time_elapsed += delta
	text = _format_seconds(time_elapsed)
	pass


func _format_seconds(time : float) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)

	var milliseconds := fmod(time, 1) * 100

	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
