extends Node2D

@onready var joints = $Joints
@onready var torso = $Torso
@onready var head = $Head

@onready var fire1 = $Leg_L/FireScene
@onready var fire2 = $Leg_R/FireScene

func dismember() -> void:
	if(joints):
		remove_child(joints)

		torso.lock_rotation = false
		head.lock_rotation = false

		torso.angular_velocity = 5
		head.angular_velocity = -5


func set_heelfire_visibility(is_visible : bool) -> void:
	fire1.visible = is_visible
	fire2.visible = is_visible
