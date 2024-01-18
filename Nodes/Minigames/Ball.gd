extends CharacterBody2D

@export var cooldownTime = 30
@export var Basespeed = Vector2(100.0, 10.0)
@export var speedMultiplier = 1
@export var Difficulty = 1
var maxDifficulty = 4

var speed

func _ready():
	velocity = Vector2(1, 1)
	speed = Basespeed

func _physics_process(delta):
	
	var collision = move_and_collide(velocity * speed * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		if (collision.get_normal().y == 0):
			speed = randomizeY()
		print(collision.get_normal())


func randomizeY():
	var randomY = Vector2(1, randf_range(3, 6) * (randi_range(0, 1) * 2 - 1)) 
	return Basespeed * speedMultiplier * randomY
	


func _on_death_border_body_entered(body):
	print(body.name)
	if (body.name == name):
		print("deth")
	pass # Replace with function body.
