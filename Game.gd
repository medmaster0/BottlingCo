extends Node

export (PackedScene) var Grinder
export (PackedScene) var Conveyor
export (PackedScene) var Fruit
export (PackedScene) var Wine
export (PackedScene) var Worker
export (PackedScene) var Drop

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#global vars
var grinder
var grinder2
var background_color
var conveyors = [] #list containing all of the conveyor tiles


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
	var grinder_height = (randf()*0.5 + 0.25 ) * get_viewport().size.y
	var grinder_distance =  (0.6) * get_viewport().size.x
	grinder.position = Vector2(grinder_distance + 3 , grinder_height ) #add 3 to center the pixels...
	grinder2.position = Vector2(grinder_distance - 24 + 3 , grinder_height ) #Move it to the right (so it's flush)
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
	
	#Conveyor Belts
	var conveyor_color = Color(randf(), randf(), randf())
	#Positioning - near our grinder 
	#Positions in TileMap Coords!!
	var conveyor_height = $TileMap.world_to_map(  Vector2(0,grinder_height)   ).y
	var conveyor_distance = $TileMap.world_to_map(   Vector2(grinder_distance,0)   ).x
	var conveyor_length = 20
	for i in range(1,conveyor_length):
		var conveyor = Conveyor.instance()
		conveyor.position = $TileMap.map_to_world( Vector2(conveyor_distance+i, conveyor_height-2) )
		conveyor.get_child(0).modulate = conveyor_color
		#Also, play the animations
		conveyor.get_child(0).playing = true
		conveyor.get_child(1).playing = true
		add_child(conveyor)
		conveyors.append(conveyor)
	
	#Fruit
	var fruit = Fruit.instance()
	fruit.position = $TileMap.map_to_world( Vector2(conveyor_distance, conveyor_height - 3)  )
	fruit.get_child(0).modulate = Color(randf(), randf(), randf())
	fruit.get_child(1).modulate = generate_brown()
	add_child(fruit)	
	
	#Wine
	var wine = Wine.instance()
	wine.position = $TileMap.map_to_world( Vector2(conveyor_distance, conveyor_height + 6)  )
	wine.get_child(0).modulate = fruit.get_child(0).modulate
	wine.get_child(1).modulate = Color(randf(), randf(), randf())
	add_child(wine)
	
	#Worker
	var worker = Worker.instance()
	worker.position = $TileMap.map_to_world( Vector2(conveyor_distance, conveyor_height - 8)  )
	worker.get_child(1).modulate = Color(randf(), randf(), randf())
	add_child(worker)
	
	#Drop
	var drop = Drop.instance()
	drop.position = $TileMap.map_to_world( Vector2(conveyor_distance, conveyor_height + 3)  )
	drop.get_child(0).modulate = fruit.get_child(0).modulate
	add_child(drop)

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
	
	
#Returns a random shade of brown
func generate_brown():
	var brown_color #The color we will be returning
	
	var r = (0.2*randf()) + 0.6
	var g = r - (0.2*randf()) - (0.2)
	var b = randf()*g
	
	brown_color = Color(r,g,b)
	
	return(brown_color)
	
	
	
	
	
	
