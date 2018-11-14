extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#MY MOVEMENT VARIABLES
var velocity = Vector2(0,0)
var gravity = 0
#var init_position = Vector2(0,0)
var last_position = Vector2(-16,0) #also the starting position

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

var total_delta = 0
func _process(delta):
	
	
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	#total_delta = total_delta + delta

	position.y = last_position.y+(velocity.y*delta)
	position.x = last_position.x+(velocity.x*delta)
	last_position = position
	
	pass
