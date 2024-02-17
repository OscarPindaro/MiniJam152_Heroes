extends KinematicBody2D


# Player movement speed in pixels/sec
export var movement_speed = 300

# Player velocity
var velocity

# HeldObject
var object = null

# Interactable areas the player is in
var interactables = []

var inMain = true

# Base camera zoom
var base_zoom = Vector2.ZERO

onready var audio_player : AudioStreamPlayer = $AudioStreamPlayer

var was_moving : bool

func _ready():
	# Subscribe to all _hero_entered and _hero_exited signals
	interactables = get_tree().get_nodes_in_group("interactable")
	for i in range(0, interactables.size()):
		interactables[i].connect("area_entered", self, "enter_area")
		interactables[i].connect("area_exited", self, "exit_area")
	interactables = []
	
	was_moving = false
	# Get camera zoom
	#base_zoom = $PlayerCamera.zoom
	$AnimatedSprite.animation = "idle_down"

func _process(_delta):
	print(interactables)
	if(not inMain):
		return
	
	
	# Interacting with objects
	if Input.is_action_just_pressed("player_interact") and not interactables.is_empty():
		object = interactables[0]._player_interact(object)
		if object != null:
			self.add_child(object)
	

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
	var sprite = $AnimatedSprite
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
		
		
		

func enter_area(area):
	if area.is_in_group("interactable"):
		interactables.push_front(area)
		$InteractButton.visible = true

func exit_area(area):
	interactables.erase(area)
	$InteractButton.visible = false
	
func connect_runtime_interactable(interactable):
	interactable.connect("area_entered", self, "enter_area")
	interactable.connect("area_exited", self, "exit_area")