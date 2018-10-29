extends Node

export (PackedScene) var Grinder
export (PackedScene) var Conveyor

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#global vars
var grinder
var grinder2
var background_color
var conveyor
var conveyor2


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	randomize()
	
	#Create the Grinder
	grinder = Grinder.instance()
	add_child(grinder)
	grinder2 = Grinder.instance()
	add_child(grinder2)
	#Move to right third of screen (dir)
	#And a random ppoint in the top (10% to 60%) of the height of the screen
	var grinder_height = (randf()*0.5 + 0.1 ) * get_viewport().size.y
	var grinder_distance =  (0.6) * get_viewport().size.x
	grinder.position = Vector2(grinder_distance , grinder_height )
	grinder2.position = Vector2(grinder_distance - 24 , grinder_height ) #Move it to the right (so it's flush)
	#Also want to flip the direction of grinder2
	grinder2.get_child(1).set_flip_h(true)
	grinder2.get_child(0).set_flip_h(true)

	#Now set the proper colors
	var grinder_color = Color(randf(), randf(), randf())
	grinder.get_child(1).modulate = grinder_color
	grinder2.get_child(1).modulate = grinder_color
	
	#Set up background
	background_color = Color(randf(), randf(), randf())
	$CanvasLayer/Background.scale = get_viewport().size
	$CanvasLayer/Background.set_modulate( background_color )
	
	#Conveoyr Belts
	var conveyor_color = Color(randf(), randf(), randf())
	#$Conveyor.position = Vector2(500,500)
	conveyor = Conveyor.instance()
	#conveyor.get_child(0).offset = Vector2(500,500) #WORKS!
	#conveyor.get_child(0).get_child(0).position = Vector2(500,grinder_height) #Also WORKS!
	#conveyor.position = Vector2(500,grinder_height)
	conveyor.position = $TileMap.map_to_world(Vector2(20,20))
	conveyor.modulate = conveyor_color
	add_child(conveyor)
	
	#Second conveyvey
	conveyor2 = Conveyor.instance()
	conveyor2.position = $TileMap.map_to_world(Vector2(21,20))
	conveyor2.modulate = conveyor_color
	add_child(conveyor2)
	
	
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	
	#rotate the grinder (CCW) based on how much time has passed
	var angular_vel = -200
	var angular_pos = angular_vel * delta + grinder.rotation_degrees
	grinder.rotation_degrees = angular_pos
	grinder2.rotation_degrees = -angular_pos
	
	#Scroll the conveyors
	#conveyor.get_child(0).get_child(0).motion_scale = Vector2(0.5,0.5)
	
	pass
