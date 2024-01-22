extends Node2D
	
var velocity_mps: float = -40.0 # This should be negative to move towards the player

@onready var sprite_2d : Sprite2D = $Sprite2D
var start_scale: Vector2 = Vector2(1, 1) # The scale at the bottom of the screen
var horizon_scale: Vector2 = Vector2(0, 0) # The scale at the horizon

func _physics_process(delta: float) -> void:
	position.y += velocity_mps * delta
	# sprite_2d.scale *= 0.999
	# todo remove from screen
	var road_scene = get_parent()
	var horizon_y = road_scene.get_horizon_y_position()
	#var scale_factor = lerp(1.0, 0.0, (position.y - horizon_y) / (road_scene.HEIGHT - horizon_y))
	var scale_factor = lerp(1.0, 0.0, (road_scene.HEIGHT - position.y) / (road_scene.HEIGHT - horizon_y))
	scale = start_scale * scale_factor
	if position.y < horizon_y:
		queue_free() # Remove the obstacle if it's reached the horizon
