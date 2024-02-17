extends Node2D
onready var Score_node = $Score
onready var ProgressBar_node = $ProgressBar
onready var Timer_node = $Timer
onready var GoldPile_node = $GoldPile

export var score = 10.0
export var menu_path: NodePath

var Menu_node = null
var hero_count = 0
var percent = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Menu_node = get_node(menu_path)
	Menu_node.connect('change_score', self, '_on_hero_score')
	Score_node.text = "Coins: " + str(score)
	GoldPile_node.switch_frame(score)
	pass # Replace with function body.



func _on_hero_score(newscore):
	score += newscore
	hero_count += 1
	Score_node.set_text("Coins: " + str(score))
	GoldPile_node.set_frame(score)
	

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
