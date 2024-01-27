extends Control

@onready var reaction1 = $Reaction1
@onready var reaction2 = $Reaction2
@onready var reaction3 = $Reaction3
@onready var reaction4 = $Reaction4

@onready var animation_player = $AnimationPlayer


func trigger_reaction(reaction_number : int) -> void:
	var reaction : Sprite2D
	var reaction_name := ""

	match reaction_number:
		1:
			reaction = reaction1
			reaction_name = "Reaction1"
		2:
			reaction = reaction2
			reaction_name = "Reaction2"
		3:
			reaction = reaction3
			reaction_name = "Reaction3"

	reaction.visible = true
	animation_player.play(reaction_name)
	await get_tree().create_timer(5.4).timeout
	reaction.visible = false


func death():
	animation_player.stop()
	reaction1.visible = false
	reaction2.visible = false
	reaction3.visible = false

	reaction4.visible = true

	animation_player.play("death")


