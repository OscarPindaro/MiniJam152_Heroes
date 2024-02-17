extends KinematicBody2D

const UP_DIRECTION := Vector2.UP
export var speed := 600.0
var _velocity := Vector2.ZERO

var _dish = "Test"

signal send_dish(name, dish)

func _input(_InputEvent) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		emit_signal("send_dish", self.name, self._dish)

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
	
	#_velocity = move_and_slide(_velocity, UP_DIRECTION)

