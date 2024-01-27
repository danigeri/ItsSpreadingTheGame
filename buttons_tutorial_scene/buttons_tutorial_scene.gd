extends Control

@export var autofade_enabled = true

@onready var animation = $AnimationPlayer


func _ready() -> void:
	if autofade_enabled:
		await get_tree().create_timer(11.0).timeout
		animation.play("FadeOut")

		await animation.animation_finished
		visible = false
