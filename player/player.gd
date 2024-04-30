extends Node2D

const MAX_SPEED = -180.0
const MIN_SPEED = 0.
const DECAY = 2.0
const MAX_SHOTS = 30
const SHOT_VELOCITY = Vector2(0., - 180.)


var flight_rotation : float
var velocity : Vector2
var speed : float
var player_alive : bool
var shots : Array = Array()
var shot_resource = preload("res://shot/shot.tscn")
var shooting_cooldown_over = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.add_to_group("moving_body")
	player_alive = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		flight_rotation = rotation_degrees
		speed = MAX_SPEED
	else:
		if speed < MIN_SPEED:
			speed = min(speed + DECAY, MIN_SPEED)
	if Input.is_action_pressed("ui_left"):
		rotation_degrees += -2.0
	if Input.is_action_pressed("ui_right"):
		rotation_degrees += 2.0
	if player_alive:
		if Input.is_action_just_pressed("ui_accept"):
			shoot()
	velocity = Vector2(0.0, speed).rotated(deg_to_rad(flight_rotation))
	translate(velocity * delta)

func shoot():
	if shooting_cooldown_over:
		var shot
		if shots.size() < MAX_SHOTS:
			shot = shot_resource.instantiate()
			get_tree().get_first_node_in_group("game").add_child(shot)
		else:
			shot = shots.pop_front()
		var distance_to_top = Vector2(0., - 20.).rotated(deg_to_rad(rotation_degrees))
		var shot_velocity = SHOT_VELOCITY.rotated(deg_to_rad(rotation_degrees))
		var shot_position = position + distance_to_top
		shot.reset(shot_velocity, shot_position)
		shots.push_back(shot)
		shooting_cooldown_over = false
		$ShootingCooldown.start(0.5)


func _on_shooting_cooldown_timeout():
	$ShootingCooldown.stop()
	shooting_cooldown_over = true
