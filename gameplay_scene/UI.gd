extends Control

@onready var velocity_display = $VelocityGauge/VelocityLabel
@onready var distance_display = $DistancePanel/DistanceLabel
@onready var scale_gaude = $ScaleGauge
@onready var multiplier_display = $Multiplier/MultiplierLabel


func update_velocity(velocity : int):
	velocity_display.text = "%d mph" % velocity


func update_distance(distance : int):
	distance_display.text = "%d m" % distance


func update_scale(percentage : float):
	scale_gaude.set_marker(percentage)


func update_multiplier(multiplier : int):
	multiplier_display.text = "%dx" % multiplier


func update_debug(a : float):
	$Debug/DebugLabel.text = "%.2f m/s" % a
