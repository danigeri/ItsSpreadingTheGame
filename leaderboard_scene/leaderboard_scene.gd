extends Control

@onready var line_edit = $LineEdit
@onready var grid_container = $GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	SilentWolf.configure({
		"api_key": "5YKFXFjGSFay90gLBTs0I63qRidzfwfR1Fnkybp3",
		"game_id": "HeelsonFire",
		"log_level": 1
		})
	refresh()
	pass 

func save_player_score(player_name, score) -> void:
	var sw_result: Dictionary = await SilentWolf.Scores.save_score(player_name, score).sw_save_score_complete
	print("Score persisted successfully: " + str(sw_result.score_id))

func get_top_scores() -> Array:
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores(200).sw_get_scores_complete
	print("Scores: " + str(sw_result.scores))
	return sw_result.scores

func update_gui_from_top_scores(scores: Array):
	var i = 1
	for score in scores:
		var name_label: Label = Label.new()
		name_label.text = str(i) + ". : " + score.player_name
		grid_container.add_child(name_label)
		
		var score_label: Label = Label.new()
		score_label.text = str(int(score.score))
		grid_container.add_child(score_label)
		
		# var datetime_label: Label = Label.new()
		# datetime_label.text = Time.get_datetime_string_from_unix_time(int(score.timestamp))
		# print(Time.get_datetime_string_from_unix_time(int(score.timestamp)))
		# grid_container.add_child(datetime_label)
		
		i+=1
		
func refresh():
	clear_grid_container()
	var scores = await get_top_scores()
	update_gui_from_top_scores(scores)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func clear_grid_container():
	for child in grid_container.get_children():
		grid_container.remove_child(child)
		child.queue_free()

func _on_save_button_pressed():
	save_player_score(line_edit.text, randi_range(10, 100))
	pass # Replace with function body.


func _on_button_pressed():
	refresh()
	pass # Replace with function body.
