extends Node2D

@export var testing: bool = false


var inShop: bool = false
var gamePaused: bool = true
var allowShop: bool = false

var lives: int = 5
var timeSurvived: int = 0
var timeSurvivedDecimals: float = 0
var countDown: float = 3



var minigames: Array[Node2D]
var minigameCount = 0
var minigameNextLocation: Array[Vector2]

var minigameList = [ #Instantate minigames through this list
	preload("res://Nodes/Minigames/pong.tscn"),
	preload("res://Nodes/Minigames/simon_says.tscn")
]


func _ready():
	$UIRoot/Countdown.set_size(Vector2(200, 200), false)
	#Creating spiral, fuck defining any code for an AxA size cube, 4x4 it is
	minigameNextLocation.append(Vector2(1, 2))
	minigameNextLocation.append(Vector2(2, 2))
	minigameNextLocation.append(Vector2(2, 1))
	minigameNextLocation.append(Vector2(1, 1))
	minigameNextLocation.append(Vector2(0, 1))
	minigameNextLocation.append(Vector2(0, 2))
	minigameNextLocation.append(Vector2(0, 3))
	minigameNextLocation.append(Vector2(1, 3))
	minigameNextLocation.append(Vector2(2, 3))
	minigameNextLocation.append(Vector2(3, 3))
	minigameNextLocation.append(Vector2(3, 2))
	minigameNextLocation.append(Vector2(3, 1))
	minigameNextLocation.append(Vector2(3, 0))
	minigameNextLocation.append(Vector2(2, 0))
	minigameNextLocation.append(Vector2(1, 0))
	minigameNextLocation.append(Vector2(0, 0))
	
	if(testing):
		for game in minigameList.size():
			addMinigame(game)
			print(game)


func _process(delta):
	if Input.is_action_just_pressed("Bind Control Group 1"):
		transitionShop()
	if gamePaused:
		return
		
	timeSurvivedDecimals += delta
	if timeSurvivedDecimals > 1:
		--timeSurvivedDecimals
		++timeSurvived
		allowShop = true
		$UIRoot/TimeSurvived.text = "Time Survived: " + str(timeSurvived)
	if timeSurvived % 30 == 0 && allowShop:
		transitionShop()
	




func transitionShop():
	if inShop:
		$Camera2D/AnimationPlayer.play("ShopToGame")
		print("To Game")
		for game in minigames:
			game.emit_signal("resumeGame")
	else:
		$Camera2D/AnimationPlayer.play("GameToShop")
		print("To Shop")
		for game in minigames:
			game.emit_signal("pauseGame")
	allowShop = false
	

	inShop = !inShop
	gamePaused = !gamePaused


func addMinigame(gameID):
	if(minigames.size() > 16):
		print("ERROR, Tried to add another minigame when the list is full")
		return
	minigames.append(minigameList[gameID].instantiate())
	add_child(minigames[minigames.size() - 1])
	minigames[minigames.size() - 1].position = minigameNextLocation[minigames.size() - 1] * 265
	minigames[minigames.size() - 1].connect("gameFail", _on_game_fail, 0)
	



func _on_game_fail():
	--lives

func _on_start_game_button_pressed():
	$Camera2D/AnimationPlayer.play("MenuToGame")
	gamePaused = false
