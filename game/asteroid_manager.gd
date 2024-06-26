class_name AsteroidManager
extends Node

const MAX_ASTEROIDS = 32

var asteroid_resource = preload("res://asteroid/asteroid.tscn")
var current_sum_asteroid_levels: int
var spawn_cooldown : Timer
var asteroids : Array
var dead_asteroids : Array

signal asteroid_destroyed

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
	var asteroid = get_asteroid_instance()
	var asteroid_size = decide_new_asteroid_size(asteroid)
	if asteroid == null || asteroid_size == 0:
		spawn_cooldown.start(5.)
		return
	set_asteroid(asteroid, asteroid_size, null)
	spawn_cooldown.start(3.)

func decide_new_asteroid_size(asteroid : Asteroid):
	var asteroid_size = 0
	if asteroid == null:
		return asteroid_size
	if current_sum_asteroid_levels + asteroid.LARGE <= MAX_ASTEROIDS:
		asteroid_size = asteroid.LARGE
	elif current_sum_asteroid_levels + asteroid.MEDIUM <= MAX_ASTEROIDS:
		asteroid_size = asteroid.MEDIUM
	elif current_sum_asteroid_levels + asteroid.SMALL <= MAX_ASTEROIDS:
		asteroid_size = asteroid.SMALL
	return asteroid_size

func despawn_asteroid(asteroid : Asteroid):
	var original_position = asteroid.position
	asteroid_destroyed.emit(asteroid)
	asteroid.remove()
	dead_asteroids.push_back(asteroid)
	current_sum_asteroid_levels -= asteroid.size
	if asteroid.size > asteroid.SMALL:
		var child1 = get_asteroid_instance()
		if child1 == null:
			return
		set_asteroid(child1, asteroid.size / 2, original_position)
		var child2 = get_asteroid_instance()
		if child2 == null:
			return
		set_asteroid(child2, asteroid.size / 2, original_position)

func get_asteroid_instance():
	if asteroids.size() < MAX_ASTEROIDS:
		var asteroid = asteroid_resource.instantiate()
		asteroid.connect("got_destroyed", despawn_asteroid)
		return asteroid
	if dead_asteroids.size() > 0:
		return dead_asteroids.pop_front()
	return null

func set_asteroid(asteroid : Asteroid, size : int, spawn_position):
	if size == asteroid.SMALL || size == asteroid.MEDIUM || size == asteroid.LARGE:
		current_sum_asteroid_levels += size
		asteroid.reset(size, spawn_position) 
		if asteroids.size() < MAX_ASTEROIDS:
			asteroids.push_back(asteroid)
			call_deferred("add_child", asteroid)
