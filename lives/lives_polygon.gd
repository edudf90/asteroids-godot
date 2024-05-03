extends Polygon2D


func _draw():
	for index in range(polygon.size()):
		var source_vertex = polygon[index]
		var next_index = index + 1
		if index == polygon.size() - 1:
			next_index = 0
		var destination_vertex = polygon[next_index]
		draw_line(source_vertex, destination_vertex, Color.WHITE, -1.0, true)
