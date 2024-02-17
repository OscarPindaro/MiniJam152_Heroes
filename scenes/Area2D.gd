extends Area2D

var audio_player


signal player_entered_area


func _ready():
	var tree = get_tree()
	var tree_root = tree.root
	var test = tree_root.get_node("TestItem").get_node("Player")
	self.connect("body_entered", test, "_on_body_enter")
	self.connect("body_exited", test, "_on_body_exit")
	
	# Get reference to the AudioStreamPlayer node
	audio_player = tree_root.get_node("TestItem").get_node("Npc").get_node("AudioStreamPlayer2D")
