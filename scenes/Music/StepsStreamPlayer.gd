extends AudioStreamPlayer

export var is_kitchen: bool
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var restaurant_audio = [
	load("res://asset/soundeffects/steps/step_wood1.wav"),
	load("res://asset/soundeffects/steps/step_wood2.wav"),
	load("res://asset/soundeffects/steps/step_wood3.wav"),
	load("res://asset/soundeffects/steps/step_wood4.wav"),
	load("res://asset/soundeffects/steps/step_wood5.wav"),
	load("res://asset/soundeffects/steps/step_wood6.wav"),
	load("res://asset/soundeffects/steps/step_wood7.wav")
]
var kitchen_audios = [
	load("res://asset/soundeffects/steps/step_kitchen1.wav"),
	load("res://asset/soundeffects/steps/step_kitchen2.wav"),
	load("res://asset/soundeffects/steps/step_kitchen3.wav"),
	load("res://asset/soundeffects/steps/step_kitchen4.wav"),
	load("res://asset/soundeffects/steps/step_kitchen5.wav"),
	load("res://asset/soundeffects/steps/step_kitchen6.wav"),
	load("res://asset/soundeffects/steps/step_kitchen6.wav"),
]

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_kitchen:
		self.set_stream(kitchen_audios[0])
	else:
		self.set_stream(restaurant_audio[0])
	self.play()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StepsStreamPlayer_finished():
	var index = randi()%7
	if is_kitchen:
		self.set_stream(kitchen_audios[index])
	else:
		self.set_stream(kitchen_audios[index])
	if playing:
		self.play()
