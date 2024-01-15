extends Node2D

@export var steering_sensitivity = 10

@onready var game_over_scene : PackedScene = load("res://game_over_scene/game_over_scene.tscn")

var shift_speed_right : float
var shift_speed_left : float


func _ready() -> void:
	shift_speed_right = 0.01
	shift_speed_left = -0.02


func _on_lose_button_pressed() -> void:
	trigger_game_over()


func _on_road_scene_crashed_received() -> void:
	trigger_game_over()


func trigger_game_over() -> void:
	SceneTransition.change_scene(game_over_scene.instantiate())
