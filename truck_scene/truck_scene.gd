extends Node2D

var shift_speed_left : float = 0.0
var shift_speed_right : float = 0.0
var steering_sensitivity : float = 0.0

var horizontal_distance : float = 0.0
var damage_state : int = 0

var collision_handled : bool = false

@export var shift_falloff = 0.5
@export var initial_steering_sensitivity = 2
@export var max_steering_sensitivity = 10
@export var steering_sensitivity_step := 0.05
@export var animation_speed = 0.5
@export var max_spread_length : int = 190
@export var min_spread_length : int = 90
@export var truck_bounce : float = 0.2

@onready var right_truck : StaticBody2D = $RightTruckBody
@onready var left_truck : StaticBody2D = $LeftTruckBody
@onready var right_border : StaticBody2D = $ScreenBorderR
@onready var left_border : StaticBody2D = $ScreenBorderL

@onready var right_truck_sprite : Sprite2D = $RightTruckBody/Sprite
@onready var left_truck_sprite : Sprite2D = $LeftTruckBody/Sprite

@onready var connections : Node2D = $ConnectionsToTrucks
@onready var jean : Node2D = $Jean

@onready var animations = $TruckAnimation
@onready var road_collider : StaticBody2D = $RoadBody

signal crashed
signal off_roaded
signal jean_fell_off


func _ready() -> void:
	steering_sensitivity = initial_steering_sensitivity
	set_process(true)


func _physics_process(delta: float) -> void:
	handle_steering(delta)

	var left_collision  = left_truck.move_and_collide(Vector2(shift_speed_left, 0))
	var right_collision = right_truck.move_and_collide(Vector2(shift_speed_right, 0))

	hande_falling_off()
	handle_collisions(right_collision, left_collision)


func handle_collisions(right_collision : KinematicCollision2D,
					   left_collision : KinematicCollision2D) -> void:
	# left_truck to left_truck collisions
	if right_collision and right_collision.get_collider() == left_truck:
		inflict_damage()
		shift_speed_left = -truck_bounce
		shift_speed_right = truck_bounce

	elif left_collision and left_collision.get_collider() == right_truck:
		inflict_damage()
		shift_speed_left = -truck_bounce
		shift_speed_right = truck_bounce

	# left_truck to screen border collisions
	elif left_collision and left_collision.get_collider() == left_border:
		shift_speed_left = truck_bounce
		inflict_damage()
	elif right_collision and right_collision.get_collider() == right_border:
		shift_speed_right = -truck_bounce
		inflict_damage()

func handle_steering(delta : float) -> void:
	if Input.is_action_pressed("ui_right"):
		shift_speed_right += delta * steering_sensitivity
	elif Input.is_action_pressed("ui_left"):
		shift_speed_right -= delta * steering_sensitivity
	else:
		if shift_speed_right > 0:
			shift_speed_right -= delta * shift_falloff
		elif shift_speed_right < 0:
			shift_speed_right += delta * shift_falloff

	if Input.is_action_pressed("LeftTruckToTheRight"):
		shift_speed_left += delta * steering_sensitivity
	elif Input.is_action_pressed("LeftTruckToTheLeft"):
		shift_speed_left -= delta * steering_sensitivity
	else:
		if shift_speed_left > 0:
			shift_speed_left -= delta * shift_falloff
		elif shift_speed_left < 0:
			shift_speed_left += delta * shift_falloff


func hande_falling_off() -> void:
	var a = right_truck.global_position
	var b = left_truck.global_position
	var current_distance = a.x - b.x

	if horizontal_distance != current_distance:
		horizontal_distance = current_distance

		if (horizontal_distance > max_spread_length) or (
			horizontal_distance < min_spread_length):
			fall_off()


func fall_off() -> void:
	if(connections):
		remove_child(connections)
		jean.dismember()
		jean_fell_off.emit()


func increase_speed():
	if steering_sensitivity < max_steering_sensitivity:
		steering_sensitivity += steering_sensitivity_step
		animations.speed_scale += 0.01


func stop_the_trucks():
	steering_sensitivity = initial_steering_sensitivity


func get_spread_percentage() -> float:
	return (horizontal_distance - min_spread_length)/(max_spread_length-min_spread_length)*100


func inflict_damage():
	if(damage_state >= 6):
		crashed.emit()
		fall_off()
	else:
		damage_state += 1
		right_truck_sprite.set_frame(damage_state)
		left_truck_sprite.set_frame(damage_state)
		animations.play("TakingDamage")

		if damage_state == 6:
			animations.play("SeriouslyHurt")


func set_heelfire_visibility(is_visible : bool) -> void:
	jean.set_heelfire_visibility(is_visible)


func apply_skin(skin_number : int) -> void:
	jean.apply_skin(skin_number)
