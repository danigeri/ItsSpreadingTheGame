extends Node2D

# These are viewport properties and should be read not hardcoded
const WIDTH : int = 1920
const HEIGHT : int = 1080

const GREEN1 := Color(0, 1, 0)
const GREEN2 := Color(0.5, 1, 0)
const BLACK := Color(0, 0, 0)
const WHITE := Color(1, 1, 1)
const GREY1 := Color(0.42, 0.42, 0.42)
const GREY2 := Color(0.4, 0.4, 0.4)
const RED := Color(1, 0, 0)
const TRANSPARENT := Color(0, 0, 0, 0)

const LILA1 = Color8(82, 67, 152)
const LILA2 = Color8(111, 91, 152)
const DIVIDER = Color8(250, 195, 76)

@onready var truck = $TruckScene

var segment_length_px : int = 200
var segments : Array

# The trucks start at the end of the track so the length of the track for now
var position_px : int

# Vertical position of the camera in pixels
@export var cam_y_position : int = 500

@export var road_width_px : int = 2000

# The perspective scale can be adjusted
@export var camera_q : float = 1.0


func _ready() -> void:
	add_truck()
	set_process(true)

	segments = get_road_segments()

	position_px = segments.size()


func _process(delta: float) -> void:
	queue_redraw()


func add_truck() -> void:
	# TODO: 200 is the half of the presumed asset width
	# 300 is the distance from the bottom of the screen
	# 1.5 and 1.5 is adhoc
#	truck.position = Vector2(WIDTH/2+200, HEIGHT-300)
#	truck.scale = Vector2(1.5,1.5)
	pass

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
	var scale = camera_q/(segment.z - cam_z)

	var perspective = {
		X = (1 + scale*(segment.x - cam_x)) * WIDTH/2,
		Y = (1 - scale*(segment.y - cam_y)) * HEIGHT/2,
		W = scale * road_width_px * (WIDTH/2)
	}

	return perspective


func get_alternated_colors(segment_number : int) -> Dictionary:
	var Colors = {
		border = WHITE if (segment_number/3)%2 else RED,
		road = LILA1 if (segment_number/3)%2 else LILA2,
		divider = DIVIDER if (segment_number/9)%2 else TRANSPARENT,
		grass = GREEN1 if (segment_number/9)%2 else GREEN2
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
