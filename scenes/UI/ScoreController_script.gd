extends Node2D
onready var Score_node = $Score
onready var ProgressBar_node = $ProgressBar
onready var Timer_node = $Timer
onready var GoldPile_node = $GoldPile

export var score = 10.0
export var menu_path: NodePath
export var ending_scene = ""

var Menu_node = null
var hero_count = 0
var percent = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var audioInteractionScore
var makingMoney = preload("res://asset/soundeffects/tip_jar/gold_up.wav")
var losingMoney = preload("res://asset/soundeffects/tip_jar/gold_down.wav")
var tempScore

# Called when the node enters the scene tree for the first time.
func _ready():
	Menu_node = get_node(menu_path)
	Menu_node.connect('change_score', self, '_on_hero_score')
	Score_node.text = "Coins: " + str(score)
	GoldPile_node.switch_frame(score)
	audioInteractionScore = get_node("AudioStreamPlayer2D")
	tempScore = score
	pass # Replace with function body.

func _on_hero_score(newscore):
	score += newscore
	hero_count += 1
	Score_node.set_text("Coins: " + str(score))
	_check_if_sound_and_which()
	GoldPile_node.switch_frame(score)
	if score <= 0:
		get_tree().change_scene(ending_scene)

func _check_if_sound_and_which():
	var temp = int(tempScore) % 10 == 0	
	if temp == true:
		if score > tempScore:
			audioInteractionScore.set_stream(makingMoney) 
		else:
			audioInteractionScore.set_stream(losingMoney) 
		audioInteractionScore.play()
		tempScore = score
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
