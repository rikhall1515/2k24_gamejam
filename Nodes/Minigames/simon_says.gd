extends Node2D

enum Dir {ERR, UP, LEFT, DOWN, RIGHT, M1, M2, HOVER, DEHOVER, SELECT, DESELECT, SPACE}

@export var simonBaseLength: int = 2

@export var BaseCooldown: float #This number of seconds will always happen
@export var AdditionalCooldown: float #This will be affected by the basenode

@export var BaseTimer: float #This number of seconds will always happen
@export var AdditionalTimer: float #This will be affected by the basenode

var sequence = []
var currentDisplay: int = 0
var currentGuess: int = 0
var nextSimon: bool = true
var replay: bool = true
var difficulty = 1


signal gameFail(name)



# Called when the node enters the scene tree for the first time.
func _ready():
	_on_simon_says_changed_values(1, 1, 1, 1)
	randomizeSimon()
	displayNextSimon()


func randomizeSimon():
	sequence.resize(simonBaseLength + difficulty)
	currentDisplay = 0
	currentGuess = 0
	for i in (simonBaseLength + difficulty):
		sequence[i] = randi_range(Dir.UP, Dir.RIGHT)

func displayNextSimon():
	if currentDisplay >= sequence.size():
		$ReplayIdleBlinkTimer.start()
		$Timout.start()
		return
	$IdleBlinkTimer.start()
	match sequence[currentDisplay]:
		Dir.UP:
			$UpLight/AnimationPlayer.play("BlinkIdle")
			$UpLight/Tone1.play()
		Dir.LEFT:
			$LeftLight/AnimationPlayer.play("BlinkIdle")
			$RightLight/Tone2.play()
		Dir.DOWN:
			$DownLight/AnimationPlayer.play("BlinkIdle")
			$DownLight/Tone3.play()
		Dir.RIGHT:
			$RightLight/AnimationPlayer.play("BlinkIdle")
			$LeftLight/Tone4.play()
		_:
			print("ERROR, Invalid Simon Button")
	currentDisplay += 1


func simonInput(location, event):
	if event is InputEventMouseButton:
		var button: InputEventMouseButton = event as InputEventMouseButton
		if button.pressed:
			match location:
				Dir.UP:
					$UpLight/AnimationPlayer.play("BlinkPressed")
					$UpLight/Tone1.play()
				Dir.LEFT:
					$LeftLight/AnimationPlayer.play("BlinkPressed")
					$RightLight/Tone2.play()
				Dir.DOWN:
					$DownLight/AnimationPlayer.play("BlinkPressed")
					$DownLight/Tone3.play()
				Dir.RIGHT:
					$RightLight/AnimationPlayer.play("BlinkPressed")
					$LeftLight/Tone4.play()
				_:
					print("ERROR, Invalid Simon Button")
			if location == sequence[currentGuess]:
				currentGuess += 1
				$ReplayIdleBlinkTimer.start()
				$IdleBlinkTimer.stop()
				currentDisplay = 0
			else:
				randomizeSimon()
				gameFail.emit("SimonSays")
				$ReplayIdleBlinkTimer.stop()
				$IdleBlinkTimer.start()

			if currentGuess >= sequence.size():
				randomizeSimon()
				print("Success")
				$ReplayIdleBlinkTimer.stop()
				$Timout.stop()
				$Cooldown.start()
				$"../Sprite2D/AnimationPlayer".play("Hide")


	

func _on_right_input_event(_viewport, event, _shape_idx):	
	simonInput(Dir.RIGHT, event)

func _on_left_input_event(_viewport, event, _shape_idx):
	simonInput(Dir.LEFT, event)

func _on_up_input_event(_viewport, event, _shape_idx):
	simonInput(Dir.UP, event)

func _on_down_input_event(_viewport, event, _shape_idx):
	simonInput(Dir.DOWN, event)

func _on_idle_blink_timer_timeout():
	displayNextSimon()
	
func _on_replay_idle_blink_timer_timeout():
	currentDisplay = 0
	displayNextSimon()
	


func _on_cooldown_timeout():
	print("Cooldown done")
	$"../Sprite2D/AnimationPlayer".play("Reveal")
	$HideRevealTimer.start()

func _on_hide_reveal_timer_timeout():
	displayNextSimon()
	$Timout.start()


func _on_simon_says_changed_values(_speedChange, difficultyChange, timerLength, cooldownLength):
	$Timout.wait_time = BaseTimer + timerLength * AdditionalTimer
	$Cooldown.wait_time = BaseCooldown + cooldownLength * AdditionalCooldown
	difficulty = difficultyChange

func _on_timout_timeout():
	gameFail.emit("SimonSays")
