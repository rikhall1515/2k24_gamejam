extends Node2D

var inShop: bool = false
var gamePaused: bool = true
var allowShop: = false

var timeSurvived: int = 0
var timeSurvivedDecimals: float = 0

var countDown: float = 3

func _ready():
	$UIRoot/Countdown.set_size(Vector2(200, 200), false)





func _process(delta):
	if Input.is_action_just_pressed("Bind Control Group 1"):
		transitionShop()
	if gamePaused:
		return
		
	timeSurvivedDecimals += delta
	if timeSurvivedDecimals > 1:
		timeSurvivedDecimals -= 1
		timeSurvived += 1
		allowShop = true
		$UIRoot/TimeSurvived.text = "Time Survived: " + str(timeSurvived)
	if timeSurvived % 30 == 0 && allowShop:
		transitionShop()
	




func transitionShop():
	if inShop:
		$Camera2D/AnimationPlayer.play("ShopToGame")
		print("To shop")
	else:
		$Camera2D/AnimationPlayer.play("GameToShop")
		print("To game")
	allowShop = false
	
	inShop = !inShop
	gamePaused = !gamePaused



func _on_start_game_button_pressed():
	$Camera2D/AnimationPlayer.play("MenuToGame")
	gamePaused = false
