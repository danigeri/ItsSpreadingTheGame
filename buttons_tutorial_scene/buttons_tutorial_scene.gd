extends Control

func _ready() -> void:
	await get_tree().create_timer(4.0).timeout
	$AnimationPlayer.play("FadeOut")
