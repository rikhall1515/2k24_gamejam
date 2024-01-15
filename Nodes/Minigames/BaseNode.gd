extends Node2D

#Directions for inputs that your game might use
enum Dir {ERR, UP, LEFT, DOWN, RIGHT, M1, M2, HOVER, DEHOVER, SELECT, DESELECT, SPACE}

#Timers for games that requre some inputs before shutting off, will gradually decrease by a divisor
#ie 1/1.1, some max reduction can be defined in the engine
@export var timerLength: float = 1
@export var cooldownLength: float = 1

#Will be incremented by a percentage, ie 1 -> 1.1
@export var speed: float = 1

#Will be incremented by integers, 1 -> 2
@export var difficulty: int = 1

signal changedValues(speedChange, difficultyChange, timerLength, cooldownLength)
signal gameFail()
signal pauseGame()
signal resumeGame()

func setSpeed(newSpeed):
	speed = newSpeed
	changedValues.emit(speed, difficulty, timerLength, cooldownLength)
	
func setTimerLength(newTimerLength):
	timerLength = newTimerLength
	changedValues.emit(speed, difficulty, timerLength, cooldownLength)

func setCooldownTime(newCooldown):
	cooldownLength = newCooldown
	changedValues.emit(speed, difficulty, timerLength, cooldownLength)
	
func setDifficulty(newDifficulty):
	difficulty = newDifficulty
	changedValues.emit(speed, difficulty, timerLength, cooldownLength)

func _on_game_fail(minigame: String):
	print(minigame + " has failed")
	gameFail.emit()


func _on_area_2d_mouse_entered():
	pass # Replace with function body.


func _on_area_2d_mouse_exited():
	pass # Replace with function body.
