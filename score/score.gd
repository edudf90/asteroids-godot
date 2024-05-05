extends Node2D

const MILESTONE_LENGTH = 10000

var score : int
var milestones_hit : int

signal hit_milestone

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

func reset():
	score = 0
	milestones_hit = 0
	refresh_label()

func increment(value_to_increment : int):
	score += value_to_increment
	if score / MILESTONE_LENGTH > milestones_hit:
		milestones_hit += 1
		hit_milestone.emit()
	refresh_label()

func refresh_label():
	$Label.text = str(score)

func score_from_asteroid(asteroid : Asteroid):
	increment(asteroid.POINTS_AWARDED[asteroid.size])
