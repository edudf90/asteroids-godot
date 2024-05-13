extends Label

const SCORE_TEXT = "SCORE: "

var score

# Called when the node enters the scene tree for the first time.
func _ready():
	score = ScoreManager.score
	text = SCORE_TEXT + str(score)

