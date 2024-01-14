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
	var menu_scene = preload("res://menu_scene/menu_scene.tscn").instantiate()
	SceneTransition.change_scene(menu_scene)


