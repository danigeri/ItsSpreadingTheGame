extends VideoStreamPlayer


func _ready():
	play()
	paused = true


func _on_timer_timeout() -> void:
	paused = false
	$AudioStreamPlayer2D.play()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	var current_scene = get_tree().root.get_child(get_tree().root.get_child_count() - 1)
	get_tree().root.remove_child(current_scene)
