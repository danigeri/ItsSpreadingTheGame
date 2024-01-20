extends Node2D

@onready var joints = $Joints
@onready var torso = $Torso
@onready var head = $Head


func dismember() -> void:
	if(joints):
		remove_child($Joints)
		torso.lock_rotation = false
		head.lock_rotation = false
