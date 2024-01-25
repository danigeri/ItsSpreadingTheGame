extends Control

func _on_start_button_pressed() -> void:
	var gameplay_scene = preload("res://gameplay_scene/gameplay_scene.tscn").instantiate()
	SceneTransition.change_scene(gameplay_scene)

