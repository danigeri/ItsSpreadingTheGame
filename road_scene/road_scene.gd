extends Node2D

# These are viewport properties and should be read not hardcoded
const WIDTH : int = 1920
const HEIGHT : int = 1080

@export var GRASS1 := Color8(253, 166, 97)
@export var GRASS2 := Color8(246, 129, 73)
@export var ROAD1 = Color8(82, 67, 152)
@export var ROAD2 = Color8(111, 91, 152)
@export var DIVIDER1 = Color8(250, 195, 76)
@export var DIVIDER2 := Color(0, 0, 0, 0)
@export var BORDER1 = Color(1, 1, 1)
@export var BORDER2 = Color(1, 0, 0)

# Vertical position of the camera in pixels
@export var cam_y_position : int = 500
@export var road_width_px : int = 2000
@export var horizon_ratio : float = 3.0

@export var max_velocity_mps : int = 60

var velocity_mps : float = 0
var segment_length_px : int = 100
var segments : Array
var t : float = 0.0
var distance : int = 0
var position_px : int


func _ready() -> void:
	segments = get_road_segments()

	# The trucks start at the end of the track so the length of the track for now
	position_px = segments.size()

	set_process(true)


func _physics_process(delta: float) -> void:
	t += delta

	if t >= 1/velocity_mps:
		queue_redraw()
		distance += 1
		t = 0


func get_road_segments() -> Array:
	var road_segments : Array = []

	# TODO:
	# This should'nt be created runtime
	# This should be loaded

	for i in range(160000):
		var segment = {
			x = 0,
		 	y = 0,
			z = i * segment_length_px,
			curve = 0
			}

		road_segments.push_back(segment)

	return road_segments


func _draw():
	position_px = get_updated_position(position_px)

	var current_segment = position_px/segment_length_px

	var x = 0
	var dx = 0

	var prev_perspective = {X = 0, Y = 0, W = 0}

	for i in range(current_segment, current_segment+300):
		var perspective = get_perspective(segments[i], -x, cam_y_position, position_px)

		x += dx
		dx += segments[i].curve

		if perspective.Y < HEIGHT:
			var colors = get_alternated_colors(i)

			draw_quadrangle(
				colors.grass,
			 	0, prev_perspective.Y, WIDTH,
				0, perspective.Y, WIDTH)

			# 1.05 for W means that the border will be .05 wider than the road
			draw_quadrangle(
				colors.border,
			 	prev_perspective.X, prev_perspective.Y, prev_perspective.W *1.05,
				perspective.X, perspective.Y, perspective.W *1.05)

			draw_quadrangle(
				colors.road,
			 	prev_perspective.X, prev_perspective.Y, prev_perspective.W,
				perspective.X, perspective.Y, perspective.W)

			draw_quadrangle(
				colors.divider,
				prev_perspective.X, prev_perspective.Y, prev_perspective.W*0.01,
				perspective.X, perspective.Y, perspective.W*0.01)


		prev_perspective = perspective


func get_updated_position(position : int) -> int:
	var new_position = position - segment_length_px

	# Reset track if reached the end
	if new_position == 0:
		new_position = segments.size()

	return new_position


func get_perspective(segment, cam_x, cam_y, cam_z) -> Dictionary:
	var scale = 1.0/(segment.z - cam_z)

	var perspective = {
		X = (1 + scale*(segment.x - cam_x)) * WIDTH/2,
		Y = (1 - scale*(segment.y - cam_y)) * HEIGHT/horizon_ratio,
		W = scale * road_width_px * (WIDTH/2)
	}

	return perspective


func get_alternated_colors(segment_number : int) -> Dictionary:
	var Colors = {
		border = BORDER1 if (segment_number/3)%2 else BORDER2,
		road = ROAD1 if (segment_number/3)%2 else ROAD2,
		divider = DIVIDER1 if (segment_number/9)%2 else DIVIDER2,
		grass = GRASS1 if (segment_number/9)%2 else GRASS2
	}

	return Colors


func draw_quadrangle(col, x1, y1, w1, x2, y2, w2):
	var point = [
		Vector2(int(x1-w1), int(y1)),
		Vector2(int(x2-w2), int(y2)),
		Vector2(int(x2+w2), int(y2)),
		Vector2(int(x1+w1), int(y1))
	]

	draw_primitive(PackedVector2Array(point), PackedColorArray([col,col,col,col]), PackedVector2Array([]))


func increase_road_speed() -> void:
	if(velocity_mps < max_velocity_mps):
		velocity_mps += 1


func get_road_speed() -> int:
	const MPS_TO_MPH := 2.2369
	return int(MPS_TO_MPH*velocity_mps)


func get_distance() -> int:
	return distance
