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
var conveyors2 = [] #second conveyor belt (made up of a list of single tiles)

var label_color #the color of all the labels (and herbs)
var fruit #the fruit scene // object
var drop #the wine-drop scene // object
#The position of the conveyor... wil later be random. 
#Important to know for positioning
var conveyor_height 
var conveyor_distance 
var conveyor_length 
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
	grinder.position = Vector2(grinder_distance + 3 + 4 , grinder_height ) #add 3 to center the pixels...
	grinder2.position = Vector2(grinder_distance - 24 + 3 + 4 , grinder_height ) #Move it to the right (so it's flush)
	#Also want to flip the direction of grinder2
	grinder2.get_child(1).set_flip_h(true)
	grinder2.get_child(0).set_flip_h(true)
	#Also position the hitbox
	$GrinderHitBox.position = (grinder2.position + grinder.position)/2.0
	
	

	#Now set the proper colors
	var grinder_color = Color(randf(), randf(), randf())
	grinder.get_child(1).modulate = grinder_color
	grinder2.get_child(1).modulate = grinder_color
	
	#Color TileMaps
	$TileMapPrim.self_modulate = Color(randf(), randf(), randf())
	$TileMapSeco.self_modulate = Color(randf(), randf(), randf())
	
	#Set up background
	background_color = Color(randf(), randf(), randf())
	$CanvasLayer/Background.scale = get_viewport().size
	$CanvasLayer/Background.set_modulate( background_color )
	
	#Conveyor Belts
	var conveyor_color = Color(randf(), randf(), randf())
	#Positioning - near our grinder 
	#Positions in TileMap Coords!!
	conveyor_height = $TileMapPrim.world_to_map(  Vector2(0,grinder_height)   ).y
	conveyor_distance = $TileMapPrim.world_to_map(   Vector2(grinder_distance,0)   ).x
	conveyor_length = 20
	for i in range(1,conveyor_length):
		var conveyor = Conveyor.instance()
		conveyor.position = $TileMapPrim.map_to_world( Vector2(conveyor_distance+i, conveyor_height-2) )
		conveyor.get_child(0).modulate = conveyor_color
		#Also, play the animations
		conveyor.get_child(0).playing = true
		conveyor.get_child(1).playing = true
		add_child(conveyor)
		conveyors.append(conveyor)
	#SECOND CONVEYOR BELT	 
	#Positioning - underneath grinder
	#Positions in TileMap Coords!!
	var conveyor_height2 = $TileMapPrim.world_to_map(  Vector2(0,grinder_height+160)   ).y #x: 0 doesn't matter
	var conveyor_distance2 = $TileMapPrim.world_to_map(   Vector2(grinder_distance-160,0)   ).x #y: 0 doesn't matter
	var conveyor_length2 = 20
	for i in range(1,conveyor_length2):
		var conveyor = Conveyor.instance()
		conveyor.position = $TileMapPrim.map_to_world( Vector2(conveyor_distance2+i, conveyor_height2-2) )
		conveyor.get_child(0).modulate = conveyor_color
		#Also, play the animations
		conveyor.get_child(0).playing = true
		conveyor.get_child(1).playing = true
		#DIFFERENCE FOR BOTToM CONVEYOR BELT
		#Disable Hitbox
		#conveyor.get_child(2).get_child(0).disabled = true
		#Reverse Direction
		conveyor.get_child(0).flip_h = true
		conveyor.get_child(1).flip_h = true
		#Change direction it sends items (which is opposite)
		conveyor.direction_velocity.x = -1*conveyor.direction_velocity.x
		add_child(conveyor)
		conveyors2.append(conveyor)
	
	#Fruit
	fruit = Fruit.instance()
	fruit.position = $TileMapPrim.map_to_world( Vector2(conveyor_distance+3, conveyor_height - 9)  )
	fruit.get_child(0).modulate = Color(randf(), randf(), randf())
	fruit.get_child(1).modulate = generate_brown()
	add_child(fruit)	
	
	#Wine
	var wine = Wine.instance()
	wine.last_position = $TileMapPrim.map_to_world( Vector2(conveyor_distance, conveyor_height + 6)  )
	label_color = Color(randf(), randf(), randf())
	wine.get_child(0).modulate = Color(0,0,0,0)
	wine.get_child(1).modulate = label_color
	add_child(wine)
	
	#Worker
	var worker = Worker.instance()
	worker.position = $TileMapPrim.map_to_world( Vector2(conveyor_distance+10, conveyor_height - 7)  )
	#worker.get_child(1).modulate = Color(randf(), randf(), randf())
	$TileMapPrim.add_child(worker)
	
	#Platform and silhouette
	for i in range(10):
		$TileMapPrim.set_cell( conveyor_distance+i+6, conveyor_height-7, 0   ) #the birkcs
		$TileMapSeco.set_cell( conveyor_distance+i+6, conveyor_height-7, 1   ) #the bricks
	$TileMapPrim.set_cell(conveyor_distance+12,conveyor_height-8,3 ) #the silhouette
	
	#Drop
	drop = Drop.instance()
	drop.position = $TileMapPrim.map_to_world( Vector2(conveyor_distance, conveyor_height + 3)  )
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
	

#Only supports fruit entering here...
func _on_GrinderHitBox_area_entered(area):
	
	#Reset the fruit position
	area.get_parent().position = $TileMapPrim.map_to_world( Vector2(conveyor_distance+3, conveyor_height - 9)  )
	area.get_parent().last_position = area.get_parent().position
	
	#Move drop into position
	drop.position = (grinder2.position + grinder.position)/2.0
	drop.last_position = drop.position
	
	#Also set velocity of drop
	drop.velocity = Vector2( 0, 64 )
	
	pass # replace with function body


func _on_GrinderHitBox_area_exited(area):
	
	pass # replace with function body
