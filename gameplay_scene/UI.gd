extends Control

@onready var velocity_display = $VelocityGauge/VelocityLabel
@onready var distance_display = $DistancePanel/DistanceLabel

func update_velocity(velocity : int):
	velocity_display.text = "%d mph" % velocity

func update_distance(distance : int):
	distance_display.text = "%d m" % distance


