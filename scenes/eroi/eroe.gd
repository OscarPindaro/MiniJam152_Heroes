extends Area2D

# Resources
const playerGroup = "player"

const textures_base_path = "res://asset/tags/"
const textures_extension = ".png"

# Tuning constants
const horizontal_anim_treshold = 0.35

const scores = {
	"main": 3,
	"cooking": 2,
	"side": 1
}
const perfect_multiplier = 1.5
const failure_malus = -2

const waitTime = 3.0
const choosingBaloonPermanenceTime = 2.0

# Signals that the hero has reached the kitchen
signal kitchen_reached(eroe)
signal eaten_dish(dish_num, score, perfect)

#Signal that that the player as entred the hero
signal player_player_enter()
signal player_player_exit()

# To assign before adding as a child
var species : String
var sprite : SpriteFrames
var destination : Vector2
var speed : float
var preferences : Dictionary # nella forma: {"main": Array, "cooking": Array, "side": Array}

# Boolean variables
var has_eaten = false
var is_going_out = false
var perfect = true

var audioInteractionHero

# Set new navigation target
func set_navigation_target(target : Vector2):
	$NavigationAgent2D.set_target_location(target)

# Evaluates the two dishes and returns the winning one and its score
func evaluate(dish1 : Dictionary, dish2 : Dictionary):
	var score1 = get_dish_score(dish1)
	var score2 = get_dish_score(dish2)
	
	var chosen_dish
	var chosen_score
	if score1 >= score2:
		chosen_dish = "1"
		chosen_score = score1
	else:
		chosen_dish = "2"
		chosen_score = score2

	emit_signal("eaten_dish", chosen_dish, chosen_score, perfect)
	return {"dish": chosen_dish, "score": chosen_score, "perfect": perfect}
		
func get_dish_score(dish : Dictionary):
	# Dish evaluation based on preferences
	var score = 0
	if dish == null:
		score = failure_malus
	else:
		for key in preferences:
			if preferences[key] == dish[key]:
				score += scores[key]
			elif preferences[key] != null:
				perfect = false
		
		# Give bonus or malus
		if perfect:
			score *= perfect_multiplier
		elif score == 0:
			score = failure_malus
		
	return score

func head_out():
	is_going_out = true
	$AnimatedSprite.modulate = Color(1, 1, 1, 0.8) # Apply transparency

func update_choosing_baloon(dish, score, perfect):
	var tempPathAudio
	var randomNumber = randi() % 2 + 1
	if score == failure_malus:
		$ChoosingBaloon.animation = "failure"
		if species == "elf":
			if randomNumber == 1:
				tempPathAudio = load("res://asset/soundeffects/VOX/elf_girl_bad2.wav")
			else:
				tempPathAudio = load("res://asset/soundeffects/VOX/elf_girl_bad1.wav")
		elif species == "orc":
			if randomNumber == 1:
				tempPathAudio = load("res://asset/soundeffects/VOX/orc_girl_bad1.wav")
			else:
				tempPathAudio = load("res://asset/soundeffects/VOX/orc_girl_bad2.wav")
		elif species == "dwarf":
			if randomNumber == 1:
				tempPathAudio = load("res://asset/soundeffects/VOX/dwarf_bad1.wav")
			else:
				tempPathAudio = load("res://asset/soundeffects/VOX/dwarf_bad2.wav")
	elif perfect:
		$ChoosingBaloon.animation = "perfect"
		if species == "elf":
			tempPathAudio = load("res://asset/soundeffects/VOX/elf_girl_perfect.wav")
		elif species == "orc":
			tempPathAudio = load("res://asset/soundeffects/VOX/dwarf_perfect.wav")
		elif species == "dwarfs":
			tempPathAudio = load("res://asset/soundeffects/VOX/dwarf_perfect.wav")
	else:
		$ChoosingBaloon.animation = "partial"
		if species == "elf":
			if randomNumber == 1:
				tempPathAudio = load("res://asset/soundeffects/VOX/elf_girl_good.wav")
			else:
				tempPathAudio = load("res://asset/soundeffects/VOX/elf_girl_good.wav")
		elif species == "orc":
			if randomNumber == 1:
				tempPathAudio = load("res://asset/soundeffects/VOX/orc_girl_good1.wav")
			else:
				tempPathAudio = load("res://asset/soundeffects/VOX/orc_girl_good2.wav")
		elif species == "dwarfs":
			if randomNumber == 1:
				tempPathAudio = load("res://asset/soundeffects/VOX/dwarf_good1.wav")
			else:
				tempPathAudio = load("res://asset/soundeffects/VOX/dwarf_good2.wav")
	
			
	# Start choosing baloon permanence timer
	$ChoosingBaloon/FadeTimer.connect("timeout", self, "disable_choosing_baloon")
	$ChoosingBaloon/FadeTimer.start(choosingBaloonPermanenceTime)
	audioInteractionHero.set_stream(tempPathAudio)	
	audioInteractionHero.play()
	
func disable_choosing_baloon():
	$ChoosingBaloon.visible = false

func _ready():
	# Set navigation destination
	set_navigation_target(destination)
	audioInteractionHero = 	get_node("AudioStreamPlayer2D")
	
	# Set animated sprite
	if sprite != null:
		$AnimatedSprite.frames = sprite
		$AnimatedSprite.play()
	
	# Populate baloon box by getting the correct textures
	if preferences != null:
		var mainTexture = load(textures_base_path + preferences["main"] + textures_extension)
		var cookingTexture = load(textures_base_path + preferences["cooking"] + textures_extension)
		var sideTexture = load(textures_base_path + preferences["side"] + textures_extension)
		
		$BaloonUI/Sprites/MainTexture.texture = mainTexture
		$BaloonUI/Sprites/CookingTexture.texture = cookingTexture
		$BaloonUI/Sprites/SideTexture.texture = sideTexture
	
	# If dwarf move baloon down
	if species == "dwarf":
		$BaloonUI.position.y += 16
		$ChoosingBaloon.position.y += 16
	
	# Connect eaten dish with the choosing baloon feedback
	self.connect("eaten_dish", self, "update_choosing_baloon")

func _physics_process(delta):
	if $NavigationAgent2D.is_target_reached():
		if not has_eaten:
			# Wait for [waitTime] sec and then emit signal that a decision has been made
			$Timer.connect("timeout", self, "_on_waitTime_ended")
			$Timer.start(waitTime)
			has_eaten = true
			monitoring = false
			
			# Show choosing baloon
			$ChoosingBaloon.visible = true
			$ChoosingBaloon.play()
			
			# Set idle animation
			$AnimatedSprite.animation = "idle"
			
		elif is_going_out:
			queue_free()
		return
	
	# Move to next location accounting for speed and delta
	var next_location = $NavigationAgent2D.get_next_location()
	var direction = (next_location - global_position).normalized()
	var movement_delta = speed * delta
	var velocity = direction * movement_delta
	
	# Set animation based on velocity
	if abs(direction.x) >= horizontal_anim_treshold or direction.y < 0:
		$AnimatedSprite.animation = "horizontal"
		if velocity.x < 0: 
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
	elif direction.y > 0:
		$AnimatedSprite.animation = "down"
	
	global_position = global_position + velocity

func _on_waitTime_ended():
	emit_signal("kitchen_reached", self)

func _on_eroe_body_entered(body):
	if body.is_in_group(playerGroup):
		$BaloonUI.visible = true
		emit_signal("player_player_enter")

func _on_eroe_body_exited(body):
	if body.is_in_group(playerGroup):
		$BaloonUI.visible = false
		emit_signal("player_player_exit")
