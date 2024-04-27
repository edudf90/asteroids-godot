class_name PolygonBorderDrawer
extends Node

@export var collisionPolygon : CollisionPolygon2D

func draw():
	for index in range(collisionPolygon.polygon.size()):
		var source_vertex = collisionPolygon.polygon[index]
		var next_index = index + 1
		if index == collisionPolygon.polygon.size() - 1:
			next_index = 0
		var destination_vertex = collisionPolygon.polygon[next_index]
		collisionPolygon.draw_line(source_vertex, destination_vertex, Color.WHITE, -1.0, true)
