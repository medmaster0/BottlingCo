extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export (PackedScene) var Conveyor

#MY MOVEMENT VARIABLES
var velocity = Vector2(0,0)
var gravity = 0
#var init_position = Vector2(0,0)
var last_position = Vector2(16,16) #also the starting position

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


func _on_Area2D_area_entered(area):
	
	#Ignore collisions with conveyor (the conveyor will change this wine object...)
	if area.get_parent().get_filename() == Conveyor.get_path():
		return
	
	#Change the color to whatever the area was
	$Sprite.modulate = area.get_parent().get_child(0).modulate #The Drop's Sprite
	
	#Move the drop offscreen for the time being
	#Also need to do the last_position variable...
	area.get_parent().last_position = Vector2(-300,30)
	
	#Also, start falling
	velocity.y = 64
	
	pass # replace with function body


func _on_Area2D_area_exited(area):
	pass # replace with function body


