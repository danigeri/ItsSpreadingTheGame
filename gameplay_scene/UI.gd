extends Control

@onready var velocity_display = $VelocityGauge/VelocityLabel
@onready var distance_display = $DistancePanel/DistanceLabel
@onready var scale_gaude = $ScaleGauge
@onready var multiplier_display = $Multiplier/MultiplierLabel
@onready var score_display = $Score/ScoreLabel
@onready var jean_portrait = $JCVDPortrait
@onready var epic_spread_label = $EpicSpreadLabel


func update_velocity(velocity : int):
	velocity_display.text = "%d" % velocity


func update_distance(distance : int):
	distance_display.text = "%d" % distance


func update_scale(percentage : float):
	scale_gaude.set_marker(percentage)


func update_multiplier(multiplier : int):
	var color
	
	if multiplier == 1:
		color = Color8(41, 156, 70)
	elif multiplier == 2:
		color = Color8(250, 227, 71)
	elif multiplier == 4:
		color = Color8(248, 129, 73)
	elif multiplier == 8:
		color = Color8(203, 15, 30)
	
	multiplier_display.set("theme_override_colors/font_color", color)
	multiplier_display.text = "x%d" % multiplier


func update_score(score : int):
	score_display.text = str(score)


func update_debug(a : float):
	$Debug/DebugLabel.text = "%.2f m/s" % a


func blink_jean_portrait(multiplier_level : int) -> void:
	jean_portrait.trigger_reaction(multiplier_level)


func show_epic_spread_label() -> void:
	# SoundManager.play_epic_spread_sound()
	epic_spread_label.visible = true


func hide_epic_spread_label() -> void:
	epic_spread_label.visible = false


func blink_gameover_portrait() -> void:
	jean_portrait.death()
