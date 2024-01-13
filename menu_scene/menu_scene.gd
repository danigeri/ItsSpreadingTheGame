extends Control


func _on_start_button_pressed() -> void:
	var gameplay_scene = preload("res://gameplay_scene/gameplay_scene.tscn").instantiate()
	SceneTransition.change_scene(gameplay_scene)


func _on_how_to_play_button_pressed() -> void:
	var tutorial_scene = preload("res://tutorial_scene/tutorial_scene.tscn").instantiate()
	SceneTransition.change_scene(tutorial_scene)

