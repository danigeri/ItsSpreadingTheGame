extends Control

# 50, 25, 20, 5
# green, yellow, orange, red
@onready var marker = $Marker


func set_marker(percentage : float) -> void:
	marker.position.x = min(percentage, 100)

