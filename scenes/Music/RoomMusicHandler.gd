extends Node

var is_in_kitchen: bool = true
onready var room_bg_player: AudioStreamPlayer = $RoomBgPlayer
onready var kitchen_bg_player: AudioStreamPlayer = $KitchenBgPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RestarurantArea_body_entered(body:Node):
	if body.is_in_group("player"):
		is_in_kitchen = false
		room_bg_player.play()

		kitchen_bg_player.stop()
		


func _on_KitchenArea_body_entered(body:Node):
	if is_inside_tree():
		if body.is_in_group("player"):
			is_in_kitchen = true
			room_bg_player.stop()

			kitchen_bg_player.play()
