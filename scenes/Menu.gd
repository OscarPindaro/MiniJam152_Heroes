extends Node2D

var _dishes: Array

var tempValue: int = 0
var Value: int = 0

func _ready():
	#recupero i piatti 
	pass

func _addValue(Hero):
	Value = Hero.Value

func _add_dish(Player):
	_dishes.append(Player._dish)
