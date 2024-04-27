class_name AsteroidGenerator
extends Node


var asteroid_resource = preload("res://asteroid/asteroid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var asteroid = asteroid_resource.instantiate()
	asteroid.reset(2)
	add_child(asteroid)
	var asteroid2 = asteroid_resource.instantiate()
	asteroid2.reset(2)
	add_child(asteroid2)
	var asteroid3 = asteroid_resource.instantiate()
	asteroid3.reset(2)
	add_child(asteroid3)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
