extends Area2D

const playerGroup = "player"

const tag_texture_scene = preload("res://scenes/tag_texture.tscn")
const textures_base_path = "res://asset/texture/"
const textures_extension = ".png"

# Score 
const main_score = 3
const cooking_score = 2
const side_score = 1
const perfect_bonus = 2
const failure_malus = -2

# Signals that the hero has reached the kitchen
signal reached_kitchen(eroe)
signal eaten_dish(dish_num, score)

# To assign before adding as a child
var sprite : SpriteFrames
var destination : Vector2
var speed : float
var preferences : Dictionary # nella forma: {"main": Array, "cooking": Array, "side": Array}

# Sets if it has to eat
var has_eaten = false

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
		# Calculate score
		if preferences["main"].has(dish["main"]):
			score += main_score
		if preferences["cooking"].has(dish["cooking"]):
			score += cooking_score
		if preferences["side"].has(dish["side"]):
			score += side_score
		
		# Give bonus or malus
		if score == main_score + cooking_score + side_score:
			score += perfect_bonus
		elif score == 0:
			score = failure_malus
		
	return score

func _ready():
	# Set navigation destination
	set_navigation_target(destination)
	
	# Set animated sprite
	if sprite != null:
		$AnimatedSprite.frames = sprite
		$AnimatedSprite.play()
	
	# Populate baloon box by instancing tag_texture(s)
	if preferences != null:
		for dish_part in preferences:
			for tag in preferences[dish_part]:
				var individual_tag = tag_texture_scene.instance()
			
				var texture_path = textures_base_path + tag + textures_extension
				individual_tag.tag_texture = load(texture_path)
			
				$BaloonUI/TagsContainer.add_child(individual_tag)

func _physics_process(delta):
	if $NavigationAgent2D.is_target_reached():
		if not has_eaten:
			emit_signal("reached_kitchen", self)
			has_eaten = true
		return
	
	# Move to next location accounting for speed and delta
	var next_location = $NavigationAgent2D.get_next_location()
	var direction = (next_location - global_position).normalized()
	var movement_delta = speed * delta
	var velocity = direction * movement_delta
	global_position = global_position + velocity

func _on_eroe_body_entered(body):
	if body.is_in_group(playerGroup):
		$BaloonUI.visible = true

func _on_eroe_body_exited(body):
	if body.is_in_group(playerGroup):
		$BaloonUI.visible = false
