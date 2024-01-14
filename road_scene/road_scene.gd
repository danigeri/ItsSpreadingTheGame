extends Node2D

# These are viewport properties and should be read not hardcoded
const WIDTH : int = 1920
const HEIGHT : int = 1080

@onready var truck = $TruckScene


func _ready() -> void:
	add_truck()
	set_process(true)


func add_truck() -> void:
	# TODO: 200 is the half of the presumed asset width
	# 300 is the distance from the bottom of the screen
	# 1.5 and 1.5 is adhoc
	truck.position = Vector2(WIDTH/2+200, HEIGHT-300)
	truck.scale = Vector2(1.5,1.5)
