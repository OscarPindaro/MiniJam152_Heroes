extends Area2D

func _ready():
	var tree = get_tree()
	var tree_root = tree.root
	var test = tree_root.get_node("TestItem").get_node("Player")
	self.connect("body_entered", test, "_on_body_enter")
	self.connect("body_exited", test, "_on_body_exit")
	
