extends Resource
class_name Identifiers

enum Dir {ERR, UP, LEFT, DOWN, RIGHT, M1, M2, HOVER, DEHOVER, SELECT, DESELECT, SPACE, CTRL}


@export var enebletimer: bool
@export var timerlength: float
@export var cooldowntime: float
@export var speed: float

signal changedValues()
signal gameFail()

func changeSpeed(newSpeed):
	speed = newSpeed
