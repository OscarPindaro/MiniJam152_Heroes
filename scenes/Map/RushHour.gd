extends Node2D


export var rush_hour_emitter_path: NodePath 
onready var rush_hour_emitter = get_node(rush_hour_emitter_path)

export var flicker_delta: float = 0.1
export var flicker_duration: float = 2

onready var rush_hour_sprite: Sprite = $RushHourSign
onready var flicker_timer: Timer = $FlickerTimer
onready var flicker_timer_process: Timer = $FlickerPeriodTimer
onready var rush_hour_sound: AudioStreamPlayer = $AudioStreamPlayer

var is_flikering = false
var is_rush : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	rush_hour_emitter.connect("rushHour_start", self, "on_rush_start")
	rush_hour_emitter.connect("rushHour_end", self, "on_rush_end")
	rush_hour_sprite.visible = false
	flicker_timer.wait_time = flicker_delta
	flicker_timer_process.wait_time = flicker_duration

func on_rush_start():
	is_rush = true
	rush_hour_sprite.visible = true
	flicker_timer_process.start()
	flicker_timer.start()
	rush_hour_sound.play()


func on_rush_end():
	is_rush = false
	flicker_timer_process.start()
	flicker_timer.start()
	


func _on_FlickerTimer_timeout():
	rush_hour_sprite.visible = not rush_hour_sprite.visible 


func _on_FlickerPeriodTimer_timeout():
	# stop the flikering
	flicker_timer.stop()
	rush_hour_sprite.visible = is_rush
