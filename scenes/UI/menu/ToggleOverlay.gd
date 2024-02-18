extends ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Close_pressed():
	visible = false

func _on_activation_button_pressed():
	visible = true
