extends KinematicBody2D

const UP_DIRECTION := Vector2.UP

export var speed := 600.0

var _velocity := Vector2.ZERO

var _dish = "Test"

func _physics_process(delta: float) -> void:
	var _horizontal_direction = (
		Input.get_action_strength("ui_right")
		 - Input.get_action_strength("ui_left")
	)
	var _vertical_direction = (
		Input.get_action_strength("ui_down")
		 - Input.get_action_strength("ui_up")
	)
	
	_velocity.x = _horizontal_direction * speed
	_velocity.y = _vertical_direction * speed
	
	_velocity = move_and_slide(_velocity, UP_DIRECTION)

