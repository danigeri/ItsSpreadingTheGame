extends Node2D

enum {LEFT, STRAIGHT, RIGHT}

var sprite_frames : Array = [0,1,2,3]
var frame_timer : float = 0
var direction : int = STRAIGHT
var active_sprite : Sprite2D

var shift_speed_left = 0
var shift_speed_right = 0
var steering_sensitivity

@export var initial_steering_sensitivity = 5
@export var animation_speed = 0.5

@onready var truck_to_the_left : Sprite2D = $LeftTruckBody/TruckToTheLeft
@onready var truck_straight : Sprite2D = $LeftTruckBody/TruckGoingStraight
@onready var truck_to_the_right : Sprite2D = $LeftTruckBody/TruckToTheRight

@onready var left_truck : StaticBody2D = $LeftTruckBody
@onready var right_truck : StaticBody2D = $RightTruckBody

@onready var road_collider : StaticBody2D = $RoadBody

signal crashed
signal off_roaded

func _ready() -> void:
	steering_sensitivity = initial_steering_sensitivity
	active_sprite = truck_straight
	set_process(true)


func _process(delta: float) -> void:
	update_steering_animation()
	update_idle_animation(delta)


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		shift_speed_left += delta * steering_sensitivity

	if Input.is_action_pressed("ui_left"):
		shift_speed_left -= delta * steering_sensitivity

	if Input.is_action_pressed("LeftTruckToTheRight"):
		shift_speed_right += delta * steering_sensitivity

	if Input.is_action_pressed("LeftTruckToTheLeft"):
		shift_speed_right -= delta * steering_sensitivity

	var collision : KinematicCollision2D = left_truck.move_and_collide(Vector2(shift_speed_left, 0))
	handle_collisions(collision)

	collision = right_truck.move_and_collide(Vector2(shift_speed_right, 0))
	handle_collisions(collision)


func handle_collisions(collision : KinematicCollision2D) -> void:
	if collision != null:
		var collider = collision.get_collider()

		if collider != road_collider:
			crashed.emit()


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
	if frame_timer >= 1/animation_speed:
		active_sprite.set_frame(sprite_frames[0])
		sprite_frames.push_back(sprite_frames[0])
		sprite_frames.pop_front()
		frame_timer = 0


func increase_speed():
	# TODO: max check
	steering_sensitivity += 0.1
	animation_speed += 0.01
