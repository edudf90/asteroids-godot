extends Node2D

const MAX_SPEED = -180.0
const MIN_SPEED = 0.
const DECAY = 2.0
const MAX_SHOTS = 30
const SHOT_VELOCITY = Vector2(0., - 180.)
const SHOOTING_COOLDOWN = .25
const OFFSCREEN_POSITION = Vector2(-200., -200.)
const INITIAL_POSITION = Vector2(392., 330.)
const INITIAL_VELOCITY = Vector2(0., 0.)
const RESPAWN_TIME = 0.5

var flight_rotation : float
var velocity : Vector2
var speed : float
var player_alive : bool
var shots : Array = Array()
var shot_resource = preload("res://shot/shot.tscn")
var shooting_cooldown_over = true
var respawn_timer : Timer
var explosiont_timer

signal player_died

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.add_to_group("moving_body")
	$Area2D.add_to_group("player")
	$Area2D.connect("area_entered", handle_collision)
	$AnimationPlayer.connect("animation_finished", end_invincibility)
	player_alive = true
	explosiont_timer = Timer.new()
	add_child(explosiont_timer)
	explosiont_timer.connect("timeout", finished_exploding)
	respawn_timer = Timer.new()
	add_child(respawn_timer)
	respawn_timer.connect("timeout", respawn)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if player_alive:
		if Input.is_action_pressed("ui_up"):
			flight_rotation = rotation_degrees
			speed = MAX_SPEED
		else:
			if speed < MIN_SPEED:
				speed = min(speed + DECAY, MIN_SPEED)
		if Input.is_action_pressed("ui_left"):
			rotation_degrees += -3.0
		if Input.is_action_pressed("ui_right"):
			rotation_degrees += 3.0
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
		$ShootingCooldown.start(SHOOTING_COOLDOWN)

func _on_shooting_cooldown_timeout():
	$ShootingCooldown.stop()
	shooting_cooldown_over = true

func handle_collision(area : Area2D):
	if area.is_in_group("asteroid"):
		player_alive = false
		$Area2D.set_deferred("monitorable", false)
		$Area2D.set_deferred("monitoring", false)
		$Area2D/ShipPolygon.modulate = Color8(255, 255, 255, 0)
		$ExplosionDown.emitting = true
		$ExplosionRight.emitting = true
		$ExplosionLeft.emitting = true
		explosiont_timer.start(1.75)

func finished_exploding():
	$ExplosionDown.emitting = false
	$ExplosionRight.emitting = false
	$ExplosionLeft.emitting = false
	remove()
	player_died.emit()
	respawn_timer.start(RESPAWN_TIME)
	explosiont_timer.stop()

func remove():
	velocity = INITIAL_VELOCITY
	position = OFFSCREEN_POSITION
	$Area2D/ShipPolygon.modulate = Color8(255, 255, 255, 255)

func respawn():
	respawn_timer.stop()
	velocity = INITIAL_VELOCITY
	position = INITIAL_POSITION
	flight_rotation = 0
	speed = 0
	rotation_degrees = 0
	player_alive = true
	$AnimationPlayer.play("blink")

func end_invincibility(animation_name):
	$Area2D.set_deferred("monitorable", true)
	$Area2D.set_deferred("monitoring", true)
	$AnimationPlayer.stop()
