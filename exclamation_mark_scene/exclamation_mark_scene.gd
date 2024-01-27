extends Node2D


func activate_type(type : int):
	match type:
		1:
			$Red.visible = true
		2:
			$Blue.visible = true
		3:
			$Green.visible = true
