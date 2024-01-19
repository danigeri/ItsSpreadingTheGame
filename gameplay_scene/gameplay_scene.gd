extends Node2D

@onready var game_over_scene : PackedScene = load("res://game_over_scene/game_over_scene.tscn")

@onready var road_scene = $RoadScene
@onready var truck_scene = $TruckScene
@onready var ui = $UI
@onready var game_over_timer = $GameOverTimer


func _on_speed_increase_timer_timeout() -> void:
	road_scene.increase_road_speed()
	truck_scene.increase_speed()


func _on_ui_update_timer_timeout() -> void:
	ui.update_velocity(road_scene.get_road_speed())
	ui.update_distance(road_scene.get_distance())
	ui.update_scale(truck_scene.get_spread_percentage())


func _on_truck_scene_crashed() -> void:
	trigger_game_over()


func _on_truck_scene_jean_fell_off() -> void:
	road_scene.stop_the_road()
	truck_scene.stop_the_trucks()
	trigger_game_over()


func trigger_game_over() -> void:
	if(game_over_timer.is_stopped()):
		game_over_timer.start(1)


func _on_game_over_timer_timeout() -> void:
	SceneTransition.change_scene(game_over_scene.instantiate())
