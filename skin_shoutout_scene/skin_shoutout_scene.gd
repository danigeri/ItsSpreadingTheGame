extends Control

const skins = [
	preload("res://skin_shoutout_scene/jeans.png"),
	preload("res://skin_shoutout_scene/adams.png"),
	preload("res://skin_shoutout_scene/dragontrunks.png"),
	preload("res://skin_shoutout_scene/judo.png"),
	preload("res://skin_shoutout_scene/volvo.png"),
	preload("res://skin_shoutout_scene/berlin.png"),
	preload("res://skin_shoutout_scene/kingpin.png"),
	preload("res://skin_shoutout_scene/anoobis.png"),
	preload("res://skin_shoutout_scene/johnnycage.png")
]

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer


func shoutout(skin_number : int):
	sprite.texture = skins[skin_number]

	sprite.visible = true
	animation_player.play("enlarge")
	await get_tree().create_timer(1).timeout
	sprite.visible = false
