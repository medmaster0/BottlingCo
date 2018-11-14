extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var direction_velocity = Vector2(-32,0)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

#Stop falling body (gravity and vy), 
#and set new direction vx
func _on_Area2D_area_entered(area):
	
	print(area.get_filename())
	
	area.get_parent().gravity = 0
	area.get_parent().velocity = direction_velocity
	
	pass # replace with function body
