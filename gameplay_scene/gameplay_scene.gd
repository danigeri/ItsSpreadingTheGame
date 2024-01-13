extends Node2D


func _on_lose_button_pressed() -> void:
	var game_over_scene = preload("res://game_over_scene/game_over_scene.tscn").instantiate()
	SceneTransition.change_scene(game_over_scene)
