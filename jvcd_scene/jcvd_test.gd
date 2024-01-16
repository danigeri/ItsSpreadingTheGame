extends Node2D

var shift_speed_left = 0
var shift_speed_right = 0

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_right"):
		shift_speed_left += 1

	if Input.is_action_just_pressed("ui_left"):
		shift_speed_left -= 1

	if Input.is_action_just_pressed("LeftTruckToTheRight"):
		shift_speed_right += 1

	if Input.is_action_just_pressed("LeftTruckToTheLeft"):
		shift_speed_right -= 1

	$TestPlatform_L.move_and_collide(Vector2(shift_speed_left, 0))
	$TestPlatform_R.move_and_collide(Vector2(shift_speed_right, 0))
