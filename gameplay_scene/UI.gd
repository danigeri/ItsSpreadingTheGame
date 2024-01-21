extends Control

@onready var velocity_display = $VelocityGauge/VelocityLabel
@onready var distance_display = $DistancePanel/DistanceLabel
@onready var scale_gaude = $ScaleGauge
@onready var multiplier_display = $Multiplier/MultiplierLabel
@onready var score_display = $Score/ScoreLabel
@onready var jean_portrait = $JCVDPortrait

func update_velocity(velocity : int):
	velocity_display.text = "%d mph" % velocity


func update_distance(distance : int):
	distance_display.text = "%d m" % distance


func update_scale(percentage : float):
	scale_gaude.set_marker(percentage)


func update_multiplier(multiplier : int):
	multiplier_display.text = "%dx" % multiplier


func update_score(score : int):
	score_display.text = str(score)


func update_debug(a : float):
	$Debug/DebugLabel.text = "%.2f m/s" % a


func blink_jean_portrait() -> void:
	jean_portrait.visible = true
	await get_tree().create_timer(1.5).timeout
	jean_portrait.visible = false
