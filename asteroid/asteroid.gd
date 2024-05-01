class_name Asteroid
extends Node2D

const SMALL = 1
const MEDIUM = 2
const LARGE = 4

const SHAPES = {
	0 : [Vector2(9., -25.), Vector2(25., -13.), Vector2(25., 12.), Vector2(14., 25.),
	Vector2(-11., 25.), Vector2(-25., 15.), Vector2(-20., -2.), Vector2(-18., -23.)],
	1 : [Vector2(2., -13.), Vector2(20., -19.), Vector2(11., 4.), Vector2(10., 25.),
	Vector2(-4., 15.), Vector2(-25., 15.), Vector2(-24., -8.), Vector2(-15., -22.)],
	2 : [Vector2(5., -24.), Vector2(24., -24.), Vector2(15., 0.), Vector2(25., 15.),
	Vector2(13., 25.), Vector2(-19., 18.), Vector2(-24., -7.), Vector2(-7., -13.)],
}

const MIN_SCALE = {
	SMALL: 0.25, 
	MEDIUM: 0.5,
	LARGE: 0.85
}

const MAX_SCALE = {
	SMALL: 0.45, 
	MEDIUM: 0.75,
	LARGE: 1.0
}

const MAX_SPEED = 100.0
const MIN_SPEED = 50.0
const MAX_ROTATION_SPEED = -0.05
const MIN_ROTATION_SPEED = 0.05
const MIN_SPAWNING_X = -5.0
const MAX_SPAWNING_X = 805.0
const MIN_SPAWNING_Y = -5.0
const MAX_SPAWNING_Y = 645.0

signal got_destroyed

var rng 
var rotation_speed : float
var velocity : Vector2
var shape : int
var scaling_factor : float
var size : int
var is_ready = false

func reset(level, spawn_position = null):
	size = level
	rng = RandomNumberGenerator.new()
	scaling_factor = rng.randf_range(MIN_SCALE[level], MAX_SCALE[level])
	scale = Vector2(scaling_factor, scaling_factor)
	rotation_speed = rng.randf_range(MIN_ROTATION_SPEED, MAX_ROTATION_SPEED)
	velocity.y = rng.randf_range(MIN_SPEED, MAX_SPEED)
	velocity.x = rng.randf_range(MIN_SPEED, MAX_SPEED)
	shape = rng.randi_range(0, SHAPES.size() - 1)
	if spawn_position == null:
		if velocity.x > velocity.y:
			position.y = rng.randf_range(MIN_SPAWNING_Y, MAX_SPAWNING_Y)
			position.x = MAX_SPAWNING_X if randi_range(0, 1) % 2 == 0 else MIN_SPAWNING_X  
		else:
			position.x = rng.randf_range(MIN_SPAWNING_X, MAX_SPAWNING_X)
			position.y = MAX_SPAWNING_Y if randi_range(0, 1) % 2 == 0 else MIN_SPAWNING_Y
		var x_middle = (MAX_SPAWNING_X + MIN_SPAWNING_X) / 2.
		var y_middle = (MAX_SPAWNING_Y + MIN_SPAWNING_Y) / 2.
		if position.x > x_middle:
			velocity.x = - velocity.x
		if position.y > y_middle:
			velocity.y = - velocity.y
	else:
		position = spawn_position
		velocity.x = velocity.x if randi_range(0, 1) % 2 == 0 else -velocity.x
		velocity.y = velocity.y if randi_range(0, 1) % 2 == 0 else -velocity.y
	if is_ready:
		reset_child_nodes()

func reset_child_nodes():
	$PolygonCenterArea.set_deferred("monitoring", true)
	$PolygonCenterArea.set_deferred("monitorable", true)
	$PolygonCollisionArea.set_deferred("monitoring", true)
	$PolygonCollisionArea.set_deferred("monitorable", true)

# Called when the node enters the scene tree for the first time.
func _ready():
	is_ready = true
	$PolygonCollisionArea/AsteroidPolygon.set_deferred("polygon", PackedVector2Array(SHAPES[shape]))
	$PolygonCenterArea.add_to_group("moving_body")
	$PolygonCollisionArea.connect("area_entered", on_polygon_collision_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rotate(rotation_speed)
	translate(velocity * delta)

func on_polygon_collision_area_entered(area : Area2D):
	if area.is_in_group("bullet"):
		got_destroyed.emit(self)
		area.get_parent().remove_shot()

func remove():
	$PolygonCenterArea.set_deferred("monitoring", false)
	$PolygonCenterArea.set_deferred("monitorable", false)
	$PolygonCollisionArea.set_deferred("monitoring", false)
	$PolygonCollisionArea.set_deferred("monitorable", false)
	velocity = Vector2(0., 0.)
	position = Vector2(-100., 100.)
