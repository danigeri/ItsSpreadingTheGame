extends Node2D

@onready var game_over_scene : PackedScene = load("res://game_over_scene/game_over_scene.tscn")
@onready var right_truck = $RoadScene/RightTruckScene
@onready var left_truck = $RoadScene/LeftTruckScene

var shift_speed : float = 0.0


func _on_lose_button_pressed() -> void:
	SceneTransition.change_scene(game_over_scene.instantiate())


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		shift_speed += 0.1

	if Input.is_action_pressed("ui_left"):
		shift_speed -= 0.1

	right_truck.translate(Vector2(10*shift_speed, 0))
