extends CharacterBody2D

@export var difficulty = 1
var maxDifficulty = 4
var paused: bool = false

const SPEED = 10000.0

func _physics_process(delta):
	if (paused):
		return
	
	var direction = Input.get_axis("Up", "Down")
	if direction:
		velocity.y = direction * SPEED * delta
	else:
		velocity.y = 0

	move_and_slide()


func _on_pong_changed_values(_speedChange, difficultyChange, _timerLength, _cooldownLength):
	difficulty = difficultyChange



func _on_ball_pause_game():
	paused = true


func _on_ball_resume_game():
	paused = false
