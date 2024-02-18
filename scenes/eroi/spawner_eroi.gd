extends Node2D

export var min_wait_time : float = 2
export var max_wait_time : float = 5
export var rushHour_treshold : float = 1.5
export var wave_dim = 100

export var menu_path : NodePath = "MenuController"
onready var menu = get_node(menu_path)

onready var player = get_tree().root.get_node("TestItem").get_node("Player")

export var spawnEdges : PoolVector2Array
export var destEdges : PoolVector2Array
export var exitPoints : PoolVector2Array

signal rushHour_start()
signal rushHour_end()
var is_rushHour = false

var spawn_num = 0

var hero_scene = preload("res://scenes/eroi/eroe.tscn")
var orc_sprite = preload("res://asset/heroes/orc.tres")
var elf_sprite = preload("res://asset/heroes/elf.tres")
var dwarf_sprite = preload("res://asset/heroes/dwarf.tres")

class Stats:
	var species : String
	var sprite : SpriteFrames
	var speed : float
	var preferences : Dictionary
	
	func _init(my_species, my_sprite, my_speed, my_preferences):
		species = my_species
		sprite = my_sprite
		speed = my_speed
		preferences = my_preferences
	

onready var hero_stats = [
	Stats.new(
		"orc",
		orc_sprite,
		50.0,
		{
			"main": {"carne": 0.5, "pesce": 0.4, "fungo": 0.1, "melanzana": 0.0},
			"cooking": {"fritto": 0.33, "grigliato": 0.32, "crudo": 0.35},
			"side": {"patate": 0.9, "insalata": 0.0, "pomodori": 0.1}
		}
	),
	Stats.new(
		"elf",
		elf_sprite,
		60.0,
		{
			"main": {"carne": 0.0, "pesce": 0.0, "fungo": 0.2, "melanzana": 0.8},
			"cooking": {"fritto": 0.1, "grigliato": 0.2, "crudo": 0.7},
			"side": {"patate": 0.1, "insalata": 0.45, "pomodori": 0.45}
		}
	),
	Stats.new(
		"dwarf",
		dwarf_sprite,
		40.0,
		{
			"main": {"carne": 0.25, "pesce": 0.25, "fungo": 0.25, "melanzana": 0.25},
			"cooking": {"fritto": 0.5, "grigliato": 0.5, "crudo": 0.35},
			"side": {"patate": 0.7, "insalata": 0.1, "pomodori": 0.2}
		}
	)
]

func spawn_hero():
	# Randomize the hero and its preferences
	var species_index = randi() % hero_stats.size()
	var stats = hero_stats[species_index]
	
	var preferences = {} # Empty Dictionary
	for key in stats.preferences: # For every course...
		var random_float = randf()
		var total = 0.0
		for item in stats.preferences[key]: # ... get the item based on weighted probability
			total += stats.preferences[key][item]
			if total >= random_float:
				preferences[key] = item
				break
	
	# Randomize the spawn point and define the destination
	var spawn_position = spawnEdges[0].linear_interpolate(spawnEdges[1], randf())
	var destination = destEdges[0].linear_interpolate(destEdges[1], randf())
	
	# Spawn the hero and populate its parameters
	var hero = hero_scene.instance()
	hero.species = hero_stats[species_index].species
	hero.sprite = hero_stats[species_index].sprite
	hero.speed = hero_stats[species_index].speed
	hero.preferences = preferences
	hero.global_position = spawn_position
	hero.destination = destination
	add_child(hero)
	
	# Subscribe the menu to the hero's "reached_kitchen" signal
	hero.connect("kitchen_reached", menu, "on_kitchen_reached")
	hero.connect("kitchen_reached", self, "on_kitchen_reached_by_hero")

	# Subscribe the player to the hero's "enter/exit" signal
	hero.connect("player_player_enter", player, "on_player_enter")
	hero.connect("player_player_exit", player, "on_player_exit")

func on_kitchen_reached_by_hero(hero):
	# Send hero to exit and disable area
	hero.set_navigation_target(exitPoints[randi() % exitPoints.size()])
	hero.monitoring = false
	hero.head_out()

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
	
	if not is_rushHour and time <= rushHour_treshold:
		emit_signal("rushHour_start")
		is_rushHour = true
		print("START RUSH HOUR")
	elif is_rushHour and time > rushHour_treshold:
		emit_signal("rushHour_end")
		is_rushHour = false
		print("END RUSH HOUR")
	
	$SpawnTimer.start(time)
	spawn_num += 1

func _ready():
	randomize() 	# Init RNG
	restart_timer() # Start spawn timer

func _on_SpawnTimer_timeout():
	spawn_hero()
	restart_timer()


