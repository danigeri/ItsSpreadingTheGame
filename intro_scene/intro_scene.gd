extends Control

@onready var audio_player = $AspectRatioContainer/VideoStreamPlayer/AudioStreamPlayer2D
@onready var video_player = $AspectRatioContainer/VideoStreamPlayer


func _ready():
	video_player.play()
	video_player.paused = true


func _on_timer_timeout() -> void:
	video_player.paused = false
	audio_player.play()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	var current_scene = get_tree().root.get_child(get_tree().root.get_child_count() - 1)
	current_scene.queue_free()
	var menu_scene = preload("res://menu_scene/menu_scene.tscn").instantiate()
	get_tree().root.add_child(menu_scene)
	

