extends Node2D

@onready var game_over_scene : PackedScene = load("res://game_over_scene/game_over_scene.tscn")

@onready var road_scene = $RoadScene
@onready var truck_scene = $TruckScene
@onready var ui = $UI
@onready var skin_shoutout =  $UI/SkinShoutout

@onready var ui_update_timer = $UIUpdateTimer
@onready var speed_increase_timer = $SpeedIncreaseTimer

@export var score_q : float = 0.1

var distance_done : float = 0
var score : int = 0
var is_game_over_triggered : bool = false
var _multiplier : int = 1
var active_skin_number : int = 0

func _ready() -> void:
	randomize()


func _on_speed_increase_timer_timeout() -> void:
	road_scene.increase_road_speed()
	truck_scene.increase_speed()


func get_calculated_speed_mph(distance : float) -> float:
	const MPS_TO_MPH := 2.236936
	var delta_distance = distance - distance_done
	var actual_m_per_sec : float = delta_distance/ui_update_timer.wait_time

	return actual_m_per_sec*MPS_TO_MPH


func _on_ui_update_timer_timeout() -> void:
	var distance : float = road_scene.get_distance()
	var speed : float = get_calculated_speed_mph(distance)

	distance_done = distance

	ui.update_velocity(speed)
	ui.update_distance(distance)

	var spread_percentage : float = truck_scene.get_spread_percentage()
	ui.update_scale(spread_percentage)

	if(not is_game_over_triggered):
		var multiplier : int = get_calculated_multiplier(spread_percentage)

		if(multiplier != _multiplier):
			ui.update_multiplier(multiplier)

			if _multiplier == 1 and multiplier == 2:
				ui.blink_jean_portrait(1)
			elif _multiplier == 2 and multiplier == 4:
				ui.blink_jean_portrait(2)
			elif _multiplier == 4 and multiplier == 8:
				ui.blink_jean_portrait(3)

			_multiplier = multiplier

			if multiplier >= 4:
				ui.show_epic_spread_label()
				truck_scene.set_heelfire_visibility(true)
			else:
				ui.hide_epic_spread_label()
				truck_scene.set_heelfire_visibility(false)


		score += distance*multiplier*score_q
		ui.update_score(score)


func get_calculated_multiplier(spread_percentage : float) -> int:
	var multiplier : int

	if spread_percentage <= 45:
		multiplier = 1
	elif spread_percentage <= 75:
		multiplier = 2
	elif spread_percentage <= 88:
		multiplier = 4
	else:
		multiplier = 8

	return multiplier


func _on_truck_scene_crashed() -> void:
	trigger_game_over()


func _on_truck_scene_jean_fell_off() -> void:
	road_scene.stop_the_road()
	truck_scene.stop_the_trucks()
	trigger_game_over()


func trigger_game_over() -> void:
	if(not is_game_over_triggered):
		is_game_over_triggered = true

		ui.hide_epic_spread_label()
		ui.blink_gameover_portrait()

		truck_scene.set_heelfire_visibility(false)

		await get_tree().create_timer(1.0).timeout
		get_tree().root.add_child(game_over_scene.instantiate())

		ui_update_timer.stop()
		speed_increase_timer.stop()


func _on_damage_pressed() -> void:
	truck_scene.inflict_damage()


func _on_skin_change_pressed() -> void:
	var next_skin : int = randi_range(0,8)

	if(next_skin != active_skin_number):
		skin_shoutout.shoutout(next_skin%9)
		truck_scene.apply_skin(next_skin%9)
		active_skin_number = next_skin
	else:
		skin_shoutout.shoutout((next_skin+1)%9)
		truck_scene.apply_skin((next_skin+1)%9)
		active_skin_number = next_skin+1


func _on_restore_pressed() -> void:
	truck_scene.restore()
