extends Control


func _on_start_button_pressed() -> void:
	# todo only once need to enter name
	var enter_username_scene = preload("res://enter_username_scene/enter_username_scene.tscn").instantiate()
	var current_scene = get_tree().root.get_child(5)
	current_scene.queue_free()
	get_tree().root.add_child(enter_username_scene)


func _on_high_score_button_pressed():
	print("scoreboard button todo")
	var leaderboard_scene = preload("res://leaderboard_scene/leaderboard_scene.tscn").instantiate()
	SceneTransition.change_scene(leaderboard_scene)
