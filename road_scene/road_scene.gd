extends Node2D

# These are viewport properties and should be read not hardcoded
const WIDTH : int = 480
const HEIGHT : int = 270

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

@export var max_speed : float = 550.0
@export var speed_up_step : float = 0.16
@export var road_length_px = 160000

# This is the atual width of a segment drawn that will
# also be the percieved speed
@export var speed := 10.0
var distance : float = 0.0
var position_px : int

var obstacle_scene = preload("res://obstacle_scene/obstacle_scene.tscn")
var obstacle_timer = Timer.new() # the interval between a new object is generated

var exclamation_mark_scene = preload("res://exclamation_mark_scene/exclamation_mark_scene.tscn")
var upcoming_objects = []

# the time how long exclamation mark is shown up
@export var exclamation_mark_time = 1
# propability of spawning [obstacle, repair, skin in %]
@export var p_ranges = [70, 10, 20]

func get_horizon_y_position() -> float:
	# Assuming a very large `i` so that it represents the horizon
	return get_perspective(road_length_px, cam_y_position, position_px).Y

func _ready() -> void:
	randomize()
	position_px = road_length_px
	add_child(obstacle_timer)
	obstacle_timer.wait_time = 12.0
	obstacle_timer.connect("timeout", self._on_obstacle_timer_timeout)
	obstacle_timer.start()
	set_process(true)

func _on_obstacle_timer_timeout() -> void:
	spawn_obstacle()
	obstacle_timer.wait_time = randi_range(2,10)

func _on_repair_hit() -> void:
	print("handling of repair hit in road scene")
	pass

func spawn_obstacle() -> void:
	var obstacle = obstacle_scene.instantiate()

	var gameplay_scene = get_parent()

	obstacle.connect("obstacle_hit", gameplay_scene._on_damage_pressed)
	obstacle.connect("repair_hit", gameplay_scene._on_restore_hit)
	obstacle.connect("skin_hit", gameplay_scene._on_skin_change_pressed)

	# Random obstacle()
	var random_value = randi_range(0, 100)
	var obstacle_type
	if random_value <= p_ranges[0]:
		obstacle.set_to_obstacle()
		obstacle_type = 1
	elif random_value <= p_ranges[0] + p_ranges[1]:
		obstacle.set_to_repair()
		obstacle_type = 2
	else:
		obstacle.set_to_skin()
		obstacle_type = 3

	var spawn_x_position = randi_range(0, WIDTH)
	var spawn_y_position = HEIGHT * 1.5
	obstacle.position = Vector2(spawn_x_position, spawn_y_position)
	add_child(obstacle)

	# Spawn the exclamation mark
	var exclamation_mark = exclamation_mark_scene.instantiate()
	exclamation_mark.position = Vector2(spawn_x_position, HEIGHT - 30) # Adjust Y position as needed
	exclamation_mark.scale = Vector2(0,0)
	exclamation_mark.activate_type(obstacle_type)
	add_child(exclamation_mark)

	var exclamation_mark_timer = Timer.new()
	add_child(exclamation_mark_timer)
	exclamation_mark_timer.wait_time = exclamation_mark_time
	exclamation_mark_timer.one_shot = true
	exclamation_mark_timer.start()

	upcoming_objects.append({
		"obstacle": obstacle,
		"exclamation_mark": exclamation_mark,
		"exclamation_mark_timer": exclamation_mark_timer
	})


func _process(delta):
	for upcoming_object in upcoming_objects:
		var timer = upcoming_object["exclamation_mark_timer"]
		var scale_factor = 1 - timer.time_left
		#print(upcoming_object["exclamation_mark_timer"].time_left)
		upcoming_object.exclamation_mark.scale = Vector2(scale_factor, scale_factor)
		if timer.time_left <= 0:
			# Remove the exclamation mark when the timer runs out
			upcoming_object["exclamation_mark"].queue_free()
			if upcoming_object["obstacle"] != null:
				upcoming_object["obstacle"].started = true
			upcoming_object["exclamation_mark_timer"].queue_free()
			upcoming_objects.erase(upcoming_object)


func _physics_process(delta: float) -> void:
		queue_redraw()
		# 0.1 is arbitrary
		distance += (speed * delta * 0.1)


func _draw():
	position_px = get_updated_position(position_px)

	var current_segment = position_px/speed
	var prev_perspective = {X = 0, Y = 0, W = 0}

	for i in range(current_segment, current_segment+200):
		var perspective = get_perspective(i*speed, cam_y_position, position_px)

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
	var new_position = position - speed

	# Reset track if reached the end
	if new_position == 0:
		new_position = road_length_px

	return new_position


func get_perspective(i, cam_y, cam_z) -> Dictionary:
	var scale = 1.0/(i - cam_z)
	var perspective = {
		X = WIDTH/2,
		Y = (1 + scale*(cam_y)) * HEIGHT/horizon_ratio,
		W = scale * road_width_px * (WIDTH/2)
	}

	return perspective


func get_alternated_colors(segment_number : int) -> Dictionary:
	var Colors = {
		border = BORDER1 if (segment_number/5)%2 else BORDER2,
		road = ROAD1 if (segment_number/9)%2 else ROAD2,
		divider = DIVIDER1 if (segment_number/15)%2 else DIVIDER2,
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
	if(speed < max_speed):
		speed += speed_up_step


func get_road_speed() -> int:
	const MAX_PRESENTED_SPEED = 150

	return int(MAX_PRESENTED_SPEED*speed/max_speed)


func get_distance() -> float:
	return distance


func stop_the_road():
	speed = 10
