extends Control


func _on_start_button_pressed() -> void:
	var current_scene = get_tree().root.get_child(get_tree().root.get_child_count() - 1)
	current_scene.queue_free()
	var gameplay_scene = preload("res://gameplay_scene/gameplay_scene.tscn").instantiate()
	get_tree().root.add_child(gameplay_scene)


func _on_how_to_play_button_pressed() -> void:
	var current_scene = get_tree().root.get_child(get_tree().root.get_child_count() - 1)
	current_scene.queue_free()
	var tutorial_scene = preload("res://tutorial_scene/tutorial_scene.tscn").instantiate()
	get_tree().root.add_child(tutorial_scene)

