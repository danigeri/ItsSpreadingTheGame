extends Node2D

@onready var game_over_scene : PackedScene = load("res://game_over_scene/game_over_scene.tscn")


func _on_road_scene_crashed_received() -> void:
	trigger_game_over()


func trigger_game_over() -> void:
	SceneTransition.change_scene(game_over_scene.instantiate())
