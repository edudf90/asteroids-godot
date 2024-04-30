extends Node2D

const LIFESPAN = 4.

var velocity : Vector2
var is_ready = false

func reset(velocity, position):
	self.velocity = velocity
	self.position = position
	if is_ready:
		reset_child_nodes()

func reset_child_nodes():
	$Lifespan.start(LIFESPAN)
	$Area2D/CollisionShape2D.disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	is_ready = true
	$Area2D.add_to_group("moving_body")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	translate(velocity * delta)
	

func _on_lifespan_timeout():
	remove_shot()

func remove_shot():
	$Lifespan.stop()
	self.velocity = Vector2(0., 0.)
	self.position = Vector2(-50., -50.)
	$Area2D/CollisionShape2D.disabled = true
