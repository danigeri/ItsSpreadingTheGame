extends Control

func _ready():
	#BackgroundMusicPlayer.play()
	pass

func _on_start_button_pressed() -> void:
	var gameplay_scene = preload("res://gameplay_scene/gameplay_scene.tscn").instantiate()
	SceneTransition.change_scene(gameplay_scene)



func _on_high_score_button_pressed():
	print("scoreboard button todo")
	#var gameplay_scene = preload("res:/score.tscn").instantiate()
	#SceneTransition.change_scene(gameplay_scene)
	pass # Replace with function body.
