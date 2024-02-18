extends Area2D

const playerGroup = "player"

const tag_texture_scene = preload("res://scenes/tag_texture.tscn")
const textures_base_path = "res://asset/tags/"
const textures_extension = ".png"

# Score 
const scores = {
	"main": 3,
	"cooking": 2,
	"side": 1
}
const perfect_multiplier = 1.5
const failure_malus = -2

# Signals that the hero has reached the kitchen
signal kitchen_reached(eroe)
signal eaten_dish(dish_num, score)

#Signal that that the player as entred the hero
signal player_player_enter()
signal player_player_exit()

# Time to wait before deciding for a dish
const waitTime = 3.0

# To assign before adding as a child
var sprite : SpriteFrames
var destination : Vector2
var speed : float
var preferences : Dictionary # nella forma: {"main": Array, "cooking": Array, "side": Array}

# Boolean variables
var has_eaten = false
var is_going_out = false

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
	
	emit_signal("eaten_dish", chosen_dish, chosen_score)
	return {"dish": chosen_dish, "score": chosen_score}
		
func get_dish_score(dish : Dictionary):
	# Dish evaluation based on preferences
	var score = 0
	if dish == null:
		score = failure_malus
	else:
		var perfect = true
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

func _ready():
	# Set navigation destination
	set_navigation_target(destination)
	
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
		
		
		#for dish_part in preferences:
			#var tag = preferences[dish_part]
			#var individual_tag = tag_texture_scene.instance()
			#var texture_path = textures_base_path + tag + textures_extension
			#individual_tag.tag_texture = load(texture_path)
			#$BaloonUI/TagsContainer.add_child(individual_tag)

func _physics_process(delta):
	if $NavigationAgent2D.is_target_reached():
		if not has_eaten:
			# Wait for [waitTime] sec and then emit signal that a decision has been made
			$Timer.connect("timeout", self, "_on_waitTime_ended")
			$Timer.start(waitTime)
			has_eaten = true
		elif is_going_out:
			queue_free()
		return
	
	# Move to next location accounting for speed and delta
	var next_location = $NavigationAgent2D.get_next_location()
	var direction = (next_location - global_position).normalized()
	var movement_delta = speed * delta
	var velocity = direction * movement_delta
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
