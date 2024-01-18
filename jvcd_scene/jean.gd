extends Node2D

@onready var joints = $Joints

func dismember() -> void:
	if(joints):
		remove_child($Joints)
