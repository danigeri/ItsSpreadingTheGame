extends Node2D

signal obstacle_hit()
signal repair_hit()
signal skin_hit()

var velocity_mps: float = -100.0

var min_scale: float = 0.1
var max_scale: float = 1.0

var initial_x_position: float # Store the initial X position of the obstacle

var started: bool = false

var obstacle_texture = preload("res://obstacle_scene/obstacle_texture.png")
var repair_texture = preload("res://obstacle_scene/repair_texture.png")
var skin_texture = preload("res://obstacle_scene/skin_texture.png")
@onready var sprite_2d = $Sprite2D

enum ObstacleType { OBSTACLE, REPAIR, SKIN }
var type: ObstacleType = ObstacleType.OBSTACLE

func map_value(value, start_1, end_1, start_2, end_2):
	return lerp(start_2, end_2, (value - start_1) / (end_1 - start_1))

func _ready() -> void:
	initial_x_position = position.x # Set the initial X position

	var road_scene = get_parent()
	self.velocity_mps = - map_value(road_scene.speed, 10, road_scene.max_speed, 100, 400)

	if type == ObstacleType.OBSTACLE:
		sprite_2d.texture = obstacle_texture
	elif type == ObstacleType.REPAIR:
		sprite_2d.texture = repair_texture
	elif type == ObstacleType.SKIN:
		sprite_2d.texture = skin_texture

func set_to_obstacle() -> void:
	self.type = ObstacleType.OBSTACLE
	if self.sprite_2d == null:
		return
	self.sprite_2d.texture = self.obstacle_texture

func set_to_repair() -> void:
	self.type = ObstacleType.REPAIR
	if self.sprite_2d == null:
		return
	self.sprite_2d.texture = self.repair_texture

func set_to_skin() -> void:
	self.type = ObstacleType.SKIN
	if self.sprite_2d == null:
		return
	self.sprite_2d.texture = self.skin_texture


func _physics_process(delta: float) -> void:
	if not started:
		return

	position.y += velocity_mps * delta

	var road_scene = get_parent()
	var horizon_y = road_scene.get_horizon_y_position()
	position.y = clamp(position.y, horizon_y, road_scene.HEIGHT)

	# Logarithmic scaling
	var distance_ratio = (position.y - horizon_y) / (road_scene.HEIGHT - horizon_y)
	var scale_factor = log(distance_ratio * (1 / min_scale - 1) + 1) / log(1 / min_scale)
	scale = Vector2(max_scale, max_scale) * scale_factor

	# Inverted logarithmic movement on the X axis
	var middle_x: float = road_scene.WIDTH / 2
	var x_movement_ratio = 1 - (log(distance_ratio * (1 / min_scale - 1) + 1) / log(1 / min_scale))
	position.x = lerp(float(initial_x_position), middle_x, x_movement_ratio)

	# Remove the obstacle if it reaches the horizon
	if position.y <= horizon_y:
		queue_free()


func _on_area_2d_body_entered(body):
	# print("Obstacle hit something!" + ObstacleType.keys()[type])

	if type == ObstacleType.OBSTACLE:
		obstacle_hit.emit()
	elif type == ObstacleType.REPAIR:
		repair_hit.emit()
	elif type == ObstacleType.SKIN:
		skin_hit.emit()

	#visible = false
	queue_free()  # Remove the obstacle
	pass # Replace with function body.
