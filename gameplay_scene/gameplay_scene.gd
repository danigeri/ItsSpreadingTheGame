extends Node2D

@onready var game_over_scene : PackedScene = load("res://game_over_scene/game_over_scene.tscn")

func _on_lose_button_pressed() -> void:
	SceneTransition.change_scene(game_over_scene.instantiate())
