extends Node2D

enum {LEFT, STRAIGHT, RIGHT}

var sprite_frames : Array = [0,1,2,3]
var frame_timer : float = 0
var direction : int = STRAIGHT
var active_sprite : Sprite2D

var shift_speed_left = 0
var shift_speed_right = 0

@export var frame_change_time_s : float = 0.025

@onready var truck_to_the_left : Sprite2D = $LeftTruckBody/TruckToTheLeft
@onready var truck_straight : Sprite2D = $LeftTruckBody/TruckGoingStraight
@onready var truck_to_the_right : Sprite2D = $LeftTruckBody/TruckToTheRight

@onready var left_truck : RigidBody2D = $LeftTruckBody
@onready var right_truck : RigidBody2D = $RightTruckBody

func _ready() -> void:
	active_sprite = truck_straight
	set_process(true)


func _process(delta: float) -> void:
	update_steering_animation()
	update_idle_animation(delta)

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		shift_speed_left += delta * 50

	if Input.is_action_pressed("ui_left"):
		shift_speed_left -= delta * 50

	if Input.is_action_pressed("LeftTruckToTheRight"):
		shift_speed_right += delta * 50

	if Input.is_action_pressed("LeftTruckToTheLeft"):
		shift_speed_right -= delta * 50

	left_truck.move_and_collide(Vector2(shift_speed_left, 0))
	right_truck.move_and_collide(Vector2(shift_speed_right, 0))

func update_steering_animation() -> void:
	if direction == LEFT:
		active_sprite = truck_to_the_left

		truck_straight.hide()
		truck_to_the_right.hide()
	elif direction == STRAIGHT:
		active_sprite = truck_straight

		truck_to_the_left.hide()
		truck_to_the_right.hide()
	elif direction == RIGHT:
		active_sprite = truck_to_the_right

		truck_to_the_left.hide()
		truck_straight.hide()


func update_idle_animation(delta: float) -> void:
	frame_timer += delta
	if frame_timer >= frame_change_time_s:
		active_sprite.set_frame(sprite_frames[0])
		sprite_frames.push_back(sprite_frames[0])
		sprite_frames.pop_front()
		frame_timer = 0
