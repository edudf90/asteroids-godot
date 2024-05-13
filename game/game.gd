extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("game")
	$Lives.connect("no_lives_left", end_game)
	$AsteroidManager.connect("asteroid_destroyed", $Score.score_from_asteroid)
	$Player.connect("player_died", $Lives.decrement)
	$Score.connect("hit_milestone", $Lives.increment)
	$Score.reset()
	$Lives.reset()

func end_game():
	ScoreManager.score = $Score.score
	get_tree().change_scene_to_file("res://game_over_screen/game_over_screen.tscn")
