extends Node2D



func _ready():
	_connect_to__Player()
	pass
	
func _connect_to__Player():
		var tree = get_tree()
		var tree_root = tree.root
		var Player = tree_root.get_node("Node2D").get_node("Player")
		Player.connect("send_dish", self, "print_dish")
		
func print_dish(name, dish):
	print("Node name is ", name, "and test is: ", dish)
