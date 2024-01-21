extends Node2D


@onready var sun := $Sun
@onready var moon := $Moon
@onready var background = $Background
@onready var background2 = $Background2

var hour : float = 12
var debug_speedup = 20

const HEIGHT : int = 1067
const PIXELS_PER_H : float = HEIGHT/24


func _process(delta: float) -> void:

	background.position.y -= delta * 5.5 * debug_speedup
	background2.position.y -= delta * 5.5 * debug_speedup


	# loop arund
	if background.position.y <= -HEIGHT:
		background.position.y = background2.position.y + HEIGHT

	if background2.position.y <= -HEIGHT:
		background2.position.y = background.position.y + HEIGHT

#	hour += hour*delta*0.1

#	var time_of_day = fmod(hour, 24)
#	print(time_of_day)
#	if time_of_day <= 2:
#		print("Moon staying still")
#	elif time_of_day > 2 and time_of_day <= 7:
#		moon.position.y += delta * debug_speedup
#		print("Moon going down")
#	elif time_of_day > 7 and time_of_day <= 12:
#		sun.position.y -= delta * debug_speedup
#		print("Sun going up")
#	elif time_of_day > 12 and time_of_day <= 14:
#		print("Sun stays still")
#	elif time_of_day > 14 and time_of_day <= 19:
#		sun.position.y += delta * debug_speedup
#		print("Sun going down")
#	elif time_of_day > 19 and time_of_day <= 24:
#		moon.position.y -= delta * debug_speedup
#		print("Moon going up")

#	if(sun.position.y < 100):
#		sun.position.y += delta * debug_speedup
