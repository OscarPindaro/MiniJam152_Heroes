extends KinematicBody2D


# Player movement speed in pixels/sec
export var movement_speed = 300
onready var sprite = $CookSprite
# Door logic
export var kitchen_path: NodePath
export var restaurant_path: NodePath
var kitchen_node = null
var restaurant_node = null

onready var kitchen_steps_player: AudioStreamPlayer = $KitchenSteps
onready var restaurant_steps_player: AudioStreamPlayer= $RoomSteps
onready var curr_steps_player: AudioStreamPlayer = kitchen_steps_player

# Player velocity
var velocity

# HeldItem
var heldItem = null

# Interactable areas the player is in
var interactables = []

var inMain = true

# Base camera zoom
var base_zoom = Vector2.ZERO

# onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer

var was_moving : bool

var heroStep 

func _ready():
	# Subscribe to all _hero_entered and _hero_exited signals
	# var interactableAreas = get_tree().get_nodes_in_group("interactable")
	# for i in range(0, interactableAreas.size()):
	# 	interactableAreas[i].connect("body_entered", self, "enter_area")
	# 	interactableAreas[i].connect("body_exited", self, "exit_area")
	kitchen_node = get_node(kitchen_path)
	restaurant_node = get_node(restaurant_path)
	restaurant_node.connect('body_entered', self, '_on_restaurant_step')
	kitchen_node.connect('body_entered', self, '_on_kitchen_step')
	was_moving = false
	# Get camera zoom
	#base_zoom = $PlayerCamera.zoom
	sprite.animation = "idle"
	
	heroStep = get_node("AudioStreamPlayer2D")
	
func _process(_delta):

		
	#print(interactables)
	if(not inMain):
		return
	
	
	# Interacting with objects
	if Input.is_action_just_pressed("player_interact") and interactables.size() > 0 :
		$ItemAnchor.remove_child(heldItem)
		var input = interactables[0]._player_interact(heldItem)
		self.add_item(input)
		$InteractButton.visible = false
	

func _physics_process(_delta):
	
	if(not inMain):
		velocity = Vector2.ZERO
		return
	
	# Movement
	var direction = Vector2.ZERO
	if Input.is_action_pressed("player_move_up"):
		direction.y += -1
	if Input.is_action_pressed("player_move_down"):
		direction.y += 1
	if Input.is_action_pressed("player_move_right"):
		direction.x += 1
	if Input.is_action_pressed("player_move_left"):
		direction.x += -1
	
	if (direction != Vector2.ZERO) and (was_moving == false):
		was_moving = true
		#audio_player.play(audio_player.get_playback_position())
	if direction == Vector2.ZERO:
		was_moving = false
		#audio_player.stop()
	
	
	var old_velocity = velocity
	var target_velocity = direction.normalized() * movement_speed
	velocity = target_velocity
	move_and_slide(velocity)
	
	
	# Animations

	if target_velocity == Vector2.ZERO:
		sprite.animation = "idle"
	elif target_velocity.x > 0:
		sprite.animation = "move_horizontal"
		sprite.flip_h = false;
	elif target_velocity.x < 0:
		sprite.animation = "move_horizontal"
		sprite.flip_h = true;
	elif target_velocity.y > 0:
		sprite.animation = "move_down"
		sprite.flip_h = false;
	else:
		sprite.animation = "move_up"
		sprite.flip_h = false;
	sprite.play()

	# music player
	if target_velocity == Vector2.ZERO:
		curr_steps_player.stop()
	else:
		if not curr_steps_player.playing:
			curr_steps_player.play()
		
func add_item(item : Item):
	if(item != null):
		$ItemAnchor.add_child(item)
		item.position = Vector2.ZERO	
	heldItem = item
		

func enter_area(area):
	print(area)
	if area.is_in_group("interactable"):
		if heldItem == null:
			if area.is_in_group("principalSpawner"):
				interactables.push_front(area)
				$InteractButton.visible = true
		elif area.is_in_group("trash"):
			interactables.push_front(area)
			$InteractButton.visible = true
		elif area.is_in_group("cookingSpawner") && (heldItem.Main != null && heldItem.Cooking == null && heldItem.Side == null):
			interactables.push_front(area)
			$InteractButton.visible = true
		elif area.is_in_group("sideDishSpawner") && (heldItem.Main != null && heldItem.Cooking != null && heldItem.Side == null):
			interactables.push_front(area)
			$InteractButton.visible = true
		elif area.is_in_group("dishExposer") && (heldItem.Main != null && heldItem.Cooking != null && heldItem.Side != null):
			interactables.push_front(area)
			$InteractButton.visible = true

func exit_area(area):
	interactables.erase(area)
	$InteractButton.visible = false
	
# func connect_runtime_interactable(interactable):
# 	interactable.connect("body_entered", self, "enter_area")
# 	interactable.connect("body_exited", self, "exit_area")


func on_player_enter():
	if heroStep.volume_db < 30:
		heroStep.volume_db += 10
	
func on_player_exit():
	heroStep.volume_db -= 10
	
	
func _on_kitchen_step(body):
	print('cucina')
	# sprites
	sprite.hide()
	sprite = $CookSprite
	sprite.show()
	# steps
	curr_steps_player.stop()
	curr_steps_player = kitchen_steps_player

func _on_restaurant_step(body):
	print('ristorante')
	sprite.hide()
	sprite = $WaiterSprite
	sprite.show()
	# steps
	curr_steps_player.stop()
	curr_steps_player = restaurant_steps_player
	
	
	
	
