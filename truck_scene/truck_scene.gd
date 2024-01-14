extends Node2D

var sprite_frames = [0,1,2,3]
var t : float = 0
var direction = 2
var active_sprite

enum {LEFT, STRAIGHT, RIGHT}

@export var frame_change_time_s : float = 0.025


func _ready() -> void:
	active_sprite = $TruckStraight
	set_process(true)


func _process(delta: float) -> void:
	update_steering_animation()
	update_idle_animation(delta)


func update_steering_animation() -> void:
	if direction == LEFT:
		active_sprite = $TruckLeft
		$TruckStraight.hide()
		$TruckRight.hide()
	elif direction == STRAIGHT:
		active_sprite = $TruckStraight
		$TruckLeft.hide()
		$TruckRight.hide()
	elif direction == RIGHT:
		active_sprite = $TruckRight
		$TruckLeft.hide()
		$TruckStraight.hide()


func update_idle_animation(delta: float) -> void:
	t += delta
	if t >= frame_change_time_s:
		active_sprite.set_frame(sprite_frames[0])
		sprite_frames.push_back(sprite_frames[0])
		sprite_frames.pop_front()
		t = 0
