extends Control

func _ready():
	#BackgroundMusicPlayer.play()
	pass

func _on_start_button_pressed() -> void:
	# todo only once need to enter name
	var enter_username_scene = preload("res://enter_username_scene/enter_username_scene.tscn").instantiate()
	SceneTransition.change_scene(enter_username_scene)
	

func _on_high_score_button_pressed():
	print("scoreboard button todo")
	var leaderboard_scene = preload("res://leaderboard_scene/leaderboard_scene.tscn").instantiate()
	SceneTransition.change_scene(leaderboard_scene)
	pass # Replace with function body.
