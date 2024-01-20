extends Node2D

var shift_speed_left = 0
var shift_speed_right = 0
var horizontal_distance = 0

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_right"):
		shift_speed_left += 1

	if Input.is_action_just_pressed("ui_left"):
		shift_speed_left -= 1

	if Input.is_action_just_pressed("LeftTruckToTheRight"):
		shift_speed_right += 1

	if Input.is_action_just_pressed("LeftTruckToTheLeft"):
		shift_speed_right -= 1

	$TestPlatform_R.move_and_collide(Vector2(shift_speed_left, 0))
	$TestPlatform_L.move_and_collide(Vector2(shift_speed_right, 0))

	var a = $TestPlatform_L.global_position
	var b = $TestPlatform_R.global_position

	if horizontal_distance != b.x - a.x:
		horizontal_distance = b.x - a.x
		print("distance = %f" % horizontal_distance)
		if(horizontal_distance > 800):
			var child1 = $RearViewMirror_L
			var child2 = $RearViewMirror_R
			remove_child(child1)
			remove_child(child2)



