extends Area2D

@export var x_shift = 0.0
@export var y_shift = 0.0
@export var rec_width = 0.0
@export var rec_height = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.shape.size.y = rec_height
	$CollisionShape2D.shape.size.x = rec_width
	pass # Replace with function body.



func _on_area_entered(area):
	if area.is_in_group("moving_body"):
		area.get_parent().position.x += x_shift
		area.get_parent().position.y += y_shift
	pass # Replace with function body.
