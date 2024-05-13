extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/NewGame.connect("pressed", new_game)
	$VBoxContainer/Quit.connect("pressed", quit)
	pass # Replace with function body.


func new_game():
	get_tree().change_scene_to_file("res://game/game.tscn")

func quit():
	get_tree().quit()
