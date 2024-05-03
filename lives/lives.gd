extends Node2D

const STARTING_LIVES = 3

var lives

signal no_lives_left

func _ready():
	reset()

func reset():
	lives = STARTING_LIVES
	refresh_label()

func increment():
	lives += 1
	refresh_label()

func decrement():
	if lives == 0:
		no_lives_left.emit()
	else:
		lives -= 1
		refresh_label()

func refresh_label():
	$Label.text = " X " + str(lives)
