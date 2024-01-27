extends Control

@onready var line_edit = $LineEdit
@onready var name_column = $Board/Name
@onready var score_column = $Board/Score
@onready var no_column = $Board/No


# Called when the node enters the scene tree for the first time.
func _ready():
	var scores = await get_top_scores()
	update_gui_from_top_scores(scores)
	pass 

func get_top_scores() -> Array:
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores(200).sw_get_scores_complete
	print("Scores: " + str(sw_result.scores))
	return sw_result.scores

func update_gui_from_top_scores(scores: Array):
	var i = 1
	for score in scores:
		var no_label: Label = Label.new()
		no_label.text = str(i) + ". "
		no_column.add_child(no_label)
		
		var name_label: Label = Label.new()
		name_label.text = score.player_name
		name_column.add_child(name_label)
		
		var score_label: Label = Label.new()
		score_label.text = str(int(score.score))
		score_label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_RIGHT)
		score_column.add_child(score_label)
		
		# var datetime_label: Label = Label.new()
		# datetime_label.text = Time.get_datetime_string_from_unix_time(int(score.timestamp))
		# print(Time.get_datetime_string_from_unix_time(int(score.timestamp)))
		# grid_container.add_child(datetime_label)
		
		if i == 5:
			return
		
		i+=1
		
		
func refresh():
	get_tree().reload_current_scene() 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func clear_data():
	#for child in grid_container.get_children():
	#	grid_container.remove_child(child)
	#	child.queue_free()
	pass


func _on_button_pressed():
	refresh()
	pass # Replace with function body.


func _on_back_button_pressed():
	var menu_scene = preload("res://menu_scene/menu_scene.tscn").instantiate()
	SceneTransition.change_scene(menu_scene)
	pass # Replace with function body.
