extends AnimatedSprite


func _ready():
	pass # Replace with function body.

func switch_frame(score: float):
	
	if (score <= 10):
		self.animation = '10g'
	if (score >10 && score <= 20):
		self.animation = '20g'
	if (score >20 && score <= 30):
		self.animation = '30g'
	if (score >30 && score <= 40):
		self.animation = '40g'
	if (score >40 && score <= 50):
		self.animation = '50g'
	if (score >50 && score <= 60):
		self.animation = '60g'
	if (score >60 && score <= 70):
		self.animation = '70g'
	if (score > 70):
		self.animation = '80g'
								

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
