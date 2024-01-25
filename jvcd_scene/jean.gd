extends Node2D

@onready var joints = $Joints
@onready var torso = $Torso
@onready var head = $Head

@onready var fire1 = $Leg_L/FireScene
@onready var fire2 = $Leg_R/FireScene

@onready var head_sprite = $Head/Sprite2D
@onready var torso_sprite = $Torso/Sprite2D
@onready var leg1_sprite = $Leg_L/Sprite2D
@onready var leg2_sprite = $Leg_R/Sprite2D


func dismember() -> void:
	if(joints):
		remove_child(joints)

		torso.lock_rotation = false
		head.lock_rotation = false

		torso.angular_velocity = 5
		head.angular_velocity = -5


func apply_skin(skin_number : int):
	head_sprite.frame = skin_number
	torso_sprite.frame = skin_number
	leg1_sprite.frame = skin_number
	leg2_sprite.frame = skin_number


func set_heelfire_visibility(is_visible : bool) -> void:
	fire1.visible = is_visible
	fire2.visible = is_visible
