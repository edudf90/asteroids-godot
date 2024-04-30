class_name AsteroidGenerator
extends Node

const MAX_ASTEROIDS = 32

var asteroid_resource = preload("res://asteroid/asteroid.tscn")
var current_sum_asteroid_levels: int
var spawn_cooldown : Timer
var asteroids : Array
var dead_asteroids : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_cooldown = Timer.new()
	add_child(spawn_cooldown)
	spawn_cooldown.timeout.connect(spawn_asteroid)
	spawn_cooldown.start(1.)
	asteroids = []
	current_sum_asteroid_levels = 0

func spawn_asteroid():
	spawn_cooldown.stop()
	var asteroid
	if asteroids.size() < MAX_ASTEROIDS:
		asteroid = asteroid_resource.instantiate()
	else:
		if dead_asteroids.size() > 0:
			asteroid = dead_asteroids.pop_front()
		else:
			spawn_cooldown.start(5.)
			return
	var asteroid_size = 0
	if current_sum_asteroid_levels + asteroid.LARGE <= MAX_ASTEROIDS:
		asteroid_size = asteroid.LARGE
	elif current_sum_asteroid_levels + asteroid.MEDIUM <= MAX_ASTEROIDS:
		asteroid_size = asteroid.MEDIUM
	elif current_sum_asteroid_levels + asteroid.SMALL <= MAX_ASTEROIDS:
		asteroid_size = asteroid.SMALL
	if asteroid_size == 0:
		spawn_cooldown.start(5.)
		return
	current_sum_asteroid_levels += asteroid_size
	asteroid.reset(asteroid_size)
	if asteroids.size() < MAX_ASTEROIDS:
		asteroids.push_back(asteroid)
		add_child(asteroid)
	spawn_cooldown.start(2.)

func despawn_asteroid():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
