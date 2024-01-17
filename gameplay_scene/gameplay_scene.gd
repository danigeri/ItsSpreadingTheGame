extends Node2D

@onready var game_over_scene : PackedScene = load("res://game_over_scene/game_over_scene.tscn")

@onready var road_scene = $RoadScene
@onready var truck_scene = $TruckScene
@onready var ui = $UI


func trigger_game_over() -> void:
	SceneTransition.change_scene(game_over_scene.instantiate())


func _on_speed_increase_timer_timeout() -> void:
	road_scene.increase_road_speed()
	truck_scene.increase_speed()


func _on_ui_update_timer_timeout() -> void:
	ui.update_velocity(road_scene.get_road_speed())
	ui.update_distance(road_scene.get_distance())


func _on_truck_scene_crashed() -> void:
	trigger_game_over()

