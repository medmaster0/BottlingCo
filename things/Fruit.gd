extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var velocity = Vector2(0,0)
var gravity = 200
var init_position = Vector2(0,0)
var last_position = Vector2(0,0)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	#take note of initial position
	init_position = position
	last_position = position
	
	#specific velocity (to keep gameplay controllable)
	velocity = Vector2( 0, 64 )
	
	pass

var total_delta = 0
func _process(delta):
	
	#GRAVITY DOESN"T WORK WITH THIS HERE>...
	if($Area2D.get_overlapping_areas().size() == 0):
		velocity = Vector2(0, 64)
	
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	#total_delta = total_delta + delta
	
	#position.y = init_position.y+(velocity.y*total_delta)
	position.y = last_position.y+(velocity.y*delta) 
	velocity.y = velocity.y + gravity*delta
	position.x = last_position.x+(velocity.x*delta)
	last_position = position
	
	pass

#FINICCKY
#ONce it leaves an area (the conveyor), it goes back to fallin
func _on_Area2D_area_exited(area):
	
	#velocity = Vector2(0 , 32)
	
	pass # replace with function body
