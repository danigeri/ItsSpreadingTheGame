extends Node2D

enum {LEFT, STRAIGHT, RIGHT}

var sprite_frames : Array = [0,1,2,3]
var frame_timer : float = 0
var direction : int = STRAIGHT
var active_sprite : Sprite2D

var shift_speed_left : float = 0.0
var shift_speed_right : float = 0.0
var steering_sensitivity : float = 0.0

var horizontal_distance : float = 0.0

@export var shift_falloff = 0.5
@export var initial_steering_sensitivity = 5
@export var animation_speed = 0.5
@export var max_spread_length : int = 700

@onready var truck_to_the_left : Sprite2D = $LeftTruckBody/TruckToTheLeft
@onready var truck_straight : Sprite2D = $LeftTruckBody/TruckGoingStraight
@onready var truck_to_the_right : Sprite2D = $LeftTruckBody/TruckToTheRight

@onready var left_truck : StaticBody2D = $LeftTruckBody
@onready var right_truck : StaticBody2D = $RightTruckBody

@onready var road_collider : StaticBody2D = $RoadBody

@onready var connections : Node2D = $ConnectionsToTrucks
@onready var jean : Node2D = $Jean

signal crashed
signal off_roaded
signal jean_fell_off


func _ready() -> void:
	steering_sensitivity = initial_steering_sensitivity
	active_sprite = truck_straight
	set_process(true)


func _process(delta: float) -> void:
	update_steering_animation()
	update_idle_animation(delta)


func _physics_process(delta: float) -> void:
	handle_steering(delta)

	var collision : KinematicCollision2D = left_truck.move_and_collide(Vector2(shift_speed_left, 0))
	handle_collisions(collision)

	collision = right_truck.move_and_collide(Vector2(shift_speed_right, 0))
	handle_collisions(collision)
	hande_falling_off()


func handle_steering(delta : float) -> void:
	if Input.is_action_pressed("ui_right"):
		shift_speed_left += delta * steering_sensitivity
	elif Input.is_action_pressed("ui_left"):
		shift_speed_left -= delta * steering_sensitivity
	else:
		if shift_speed_left > 0:
			shift_speed_left -= delta * shift_falloff
		elif shift_speed_left < 0:
			shift_speed_left += delta * shift_falloff

	if Input.is_action_pressed("LeftTruckToTheRight"):
		shift_speed_right += delta * steering_sensitivity
	elif Input.is_action_pressed("LeftTruckToTheLeft"):
		shift_speed_right -= delta * steering_sensitivity
	else:
		if shift_speed_right > 0:
			shift_speed_right -= delta * shift_falloff
		elif shift_speed_right < 0:
			shift_speed_right += delta * shift_falloff


func handle_collisions(collision : KinematicCollision2D) -> void:
	if collision != null:
		var collider = collision.get_collider()

		if collider != road_collider:
			crashed.emit()


func hande_falling_off() -> void:
	var a = left_truck.global_position
	var b = right_truck.global_position
	var current_distance = a.x - b.x

	if horizontal_distance != current_distance:
		horizontal_distance = current_distance

		if(horizontal_distance > max_spread_length):
			remove_child(connections)
			jean.dismember()
			jean_fell_off.emit()


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


func stop_the_trucks():
	steering_sensitivity = initial_steering_sensitivity
	animation_speed = 0.5
