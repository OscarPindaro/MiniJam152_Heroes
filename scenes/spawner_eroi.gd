extends Node2D

export var min_wait_time = 2
export var max_wait_time = 5
export var wave_dim = 100

var spawn_num = 0

var hero_scene = preload("res://scenes/eroe.tscn")
var orc_sprite = preload("res://asset/heroes/orc.tres")
var elf_sprite = preload("res://asset/heroes/elf.tres")
var dwarf_sprite = preload("res://asset/heroes/dwarf.tres")

onready var spawnEdges = $SpawnEdges.get_children()

class Stats:
	var name : String
	var sprite : SpriteFrames
	var speed : float
	var preferences : Dictionary
	
	func _init(my_name, my_sprite, my_speed, my_preferences):
		name = my_name
		sprite = my_sprite
		speed = my_speed
		preferences = my_preferences
	

onready var hero_stats = [
	Stats.new(
		"orc",
		orc_sprite,
		50.0,
		{
			"main": ['bistecca', 'pesce'],
			"cooking": ['fritto'],
			"side": ['patate']
		}
	),
	Stats.new(
		"elf",
		elf_sprite,
		60.0,
		{
			"main": ['bistecca', 'pesce'],
			"cooking": ['fritto'],
			"side": ['patate']
		}
	),
	Stats.new(
		"dwarf",
		dwarf_sprite,
		40.0,
		{
			"main": ['bistecca', 'pesce'],
			"cooking": ['fritto'],
			"side": ['patate']
		}
	)
]

func spawn_hero():
	# Randomize the hero and its preferences
	var species_index = randi() % hero_stats.size()
	var preferences = {
		"main": [hero_stats[species_index].preferences["main"][randi() % hero_stats[species_index].preferences["main"].size()]],
		"cooking": [hero_stats[species_index].preferences["cooking"][randi() % hero_stats[species_index].preferences["cooking"].size()]],
		"side": [hero_stats[species_index].preferences["side"][randi() % hero_stats[species_index].preferences["side"].size()]]
	}
	
	# Randomize the spawn point and define the destination
	var spawn_position = spawnEdges[0].global_position.linear_interpolate(spawnEdges[1].global_position, randf())
	var destination = spawn_position + Vector2(0, 300)
	
	# Spawn the hero and populate its parameters
	var hero = hero_scene.instance()
	hero.sprite = hero_stats[species_index].sprite
	hero.speed = hero_stats[species_index].speed
	hero.preferences = preferences
	hero.global_position = spawn_position
	hero.destination = destination
	add_child(hero)
	
	# TODO: subscribe the menu to the hero's "reached_kitchen" signal

func restart_timer():
	var time = max_wait_time
	var half_wave = wave_dim / 2
	
	# If a wave has finished, begin again
	if spawn_num == wave_dim:
		spawn_num = 0
	
	# Ascend or descend depending on the position
	if spawn_num <= half_wave:
		var t = float(spawn_num) / half_wave
		time = max_wait_time * (1 - t) + min_wait_time * t
	else:
		var t = float(spawn_num - half_wave) / half_wave
		time = max_wait_time * t + min_wait_time * (1 - t)
	
	$SpawnTimer.start(time)
	spawn_num += 1

func _ready():
	randomize() 	# Init RNG
	restart_timer() # Start spawn timer

func _on_SpawnTimer_timeout():
	spawn_hero()
	restart_timer()
