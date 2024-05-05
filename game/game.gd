extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("game")
	$Lives.connect("no_lives_left", end_game)
	$AsteroidManager.connect("asteroid_destroyed", $Score.score_from_asteroid)
	$Player.connect("player_died", $Lives.decrement)
	$Score.connect("hit_milestone", $Lives.increment)
	pass # Replace with function body.

func end_game():
	print("game over")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
