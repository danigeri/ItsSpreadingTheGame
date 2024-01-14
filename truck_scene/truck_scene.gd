extends Node2D

enum {LEFT, STRAIGHT, RIGHT}

var sprite_frames : Array = [0,1,2,3]
var t : float = 0
var direction : int = STRAIGHT
var active_sprite : Sprite2D

@export var frame_change_time_s : float = 0.025

@onready var truck_to_the_left : Sprite2D = $TruckLeft
@onready var truck_straight : Sprite2D = $TruckStraight
@onready var truck_to_the_right : Sprite2D = $TruckRight


func _ready() -> void:
	active_sprite = truck_straight
	set_process(true)


func _process(delta: float) -> void:
	update_steering_animation()
	update_idle_animation(delta)


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
	t += delta
	if t >= frame_change_time_s:
		active_sprite.set_frame(sprite_frames[0])
		sprite_frames.push_back(sprite_frames[0])
		sprite_frames.pop_front()
		t = 0
