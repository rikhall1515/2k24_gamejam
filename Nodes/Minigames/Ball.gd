extends CharacterBody2D

@export var cooldownTime = 29
@export var Basespeed = Vector2(100.0, 10.0)
@export var speedMultiplier = 1


var speed: Vector2
var paused: bool = false

signal gameFail()
signal pauseGame()
signal resumeGame()

func _ready():
	velocity = Vector2(1, 1)
	speed = Basespeed

func _physics_process(delta):
	
	if(paused):
		return
		
	var collision = move_and_collide(velocity * speed * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		if (collision.get_normal().y == 0):
			speed = randomizeY()
			$HeavyHit.play()
		else:
			$LightHit.play()
		print(collision.get_normal())


func randomizeY():
	var randomY = Vector2(1, randf_range(3, 6) * (randi_range(0, 1) * 2 - 1)) 
	return Basespeed * speedMultiplier * randomY 
	


func _on_death_border_body_entered(body):
	print(body.name)
	if (body.name == name):
		paused = true
		gameFail.emit()
		pauseGame.emit()
		$"../CooldownTime".start()
		$"../../Cover/AnimationPlayer".play("Hide")


func _on_pong_changed_values(speedChange, _difficultyChange, _timerLength, cooldownLength):
	cooldownTime = cooldownLength
	$"../CooldownTime".wait_time = cooldownTime
	speed *= speedChange
	


func _on_cooldown_time_timeout():
	position = Vector2(0, 0)
	$"../Padddles".position.y = 0
	$"../../Cover/AnimationPlayer".play("Reveal")
	$"../CoverRevealTime".start()


func _on_cover_reveal_time_timeout():
	paused = false
	resumeGame.emit()
