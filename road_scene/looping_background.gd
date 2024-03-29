extends Node2D


@onready var sun := $Sun
@onready var moon := $Moon
@onready var background = $Background
@onready var background2 = $Background2

@onready var active_background = background

@export var day_speed_multiplier : float = 2.0

const HEIGHT : int = 1067
const DAYS_IN_PIXEL : float = HEIGHT/24


func _process(delta: float) -> void:

	background.position.y -= delta * 2.5 * day_speed_multiplier
	background2.position.y -= delta * 2.5 * day_speed_multiplier


	# loop arund
	if background.position.y <= -HEIGHT:
		background.position.y = background2.position.y + HEIGHT
		active_background = background2

	if background2.position.y <= -HEIGHT:
		background2.position.y = background.position.y + HEIGHT
		active_background = background


	var hour = abs(active_background.position.y)/DAYS_IN_PIXEL

	if hour <= 2: # 0-1 (12-13): nothing
		sun.position.y -= delta * day_speed_multiplier
	elif hour > 2 and hour <= 8: # 1-6 (13-18): sun goes down
		sun.position.y += delta * day_speed_multiplier
#	elif hour > 6 and hour <= 7: # 6-7 (18-19): nothing
#		pass
	elif hour > 8 and hour <= 14: # 7-12 (19-24): moon comes up
		moon.position.y -= delta * day_speed_multiplier
#	elif hour > 12 and hour <= 13: # 12-13 (24-1): nothing
#		pass
	elif hour > 14 and hour <= 20: # 13-18 (1-6): moon goes down
		moon.position.y += delta * day_speed_multiplier
#	elif hour > 18 and hour <= 19: # 18-19 (6-7): nothing
#		pass
	elif hour > 20 and hour <= 24: # 19-24 (7-12): sun comes up
		sun.position.y -= delta * day_speed_multiplier
