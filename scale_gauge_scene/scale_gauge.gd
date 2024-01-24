extends Control

# 50, 25, 20, 5
# green, yellow, orange, red
@onready var marker = $Marker


func set_marker(percentage : float) -> void:
	marker.position.x = min(max(percentage, 0), 100)

