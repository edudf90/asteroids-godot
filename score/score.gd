extends Node2D

var score : int

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

func reset():
	score = 0
	refresh_label()

func increment(value_to_increment : int):
	score += value_to_increment
	refresh_label()

func refresh_label():
	$Label.text = str(score)

func score_from_asteroid(asteroid : Asteroid):
	increment(asteroid.POINTS_AWARDED[asteroid.size])
