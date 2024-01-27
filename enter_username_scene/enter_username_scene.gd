extends Node2D

@onready var line_edit = $LineEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	if Globals.username != "":
		line_edit.text = Globals.username
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	Globals.username = line_edit.text
	var gameplay_scene = preload("res://gameplay_scene/gameplay_scene.tscn").instantiate()
	SceneTransition.change_scene(gameplay_scene)
	pass # Replace with function body.
