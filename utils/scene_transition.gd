extends Node

func change_scene(nextScene: Node) -> void:
	var current_scene = get_tree().root.get_child(get_tree().root.get_child_count() - 1)
	current_scene.queue_free()
	get_tree().root.add_child(nextScene)

