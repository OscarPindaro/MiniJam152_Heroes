extends Node2D
onready var Score_node = $Score
onready var ProgressBar_node = $ProgressBar
onready var Timer_node = $Timer

var score = 10.0
var hero_count = 0
var percent = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#ProgressBar_node.fill_mode = 'FILL_BOTTOM_TO_TOP'
	Score_node.text = "Coins: " + str(score)
	ProgressBar_node.value = 50
	pass # Replace with function body.

func _on_hero_score(newscore):
	score += newscore
	hero_count += 1
	Score_node.set_text("Coins: " + str(score))
	ProgressBar_node.Value = score


	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
