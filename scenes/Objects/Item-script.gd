extends Node2D 
class_name Item


var Main = null
var Side = null
var Cooking = null
onready var MainCourse_node = $MainCourse
onready var Side_node = $Side

var main_list = ['bistecca', 'pesce', 'melanzana', 'fungo']
var cooking_list = ['griglia', 'crudo', 'fritto']
var side_list = ['pomodoro', 'insalata', 'patate']

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_main(newMain): 
	assert(newMain in main_list)
	Main = newMain
	MainCourse_node.set_property_main(Main)
	
func set_side(newSide):
	assert(newSide in side_list)
	Side = newSide
	Side_node.set_side(Side)
	
func set_coocking(newCooking):
	assert(newCooking in cooking_list)
	Cooking = newCooking
	MainCourse_node.set_property_cooking(Cooking)

func get_property():
	return [Main, Side, Cooking]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
