extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_polygon_shape():
	var polygon = []
	polygon.push_back(Vector2(0,0))
	for ray in $Sensors.get_children():
		if ray is RayCast2D and ray.is_colliding():
			var collisionPoint = self.to_local(ray.get_collision_point())
			polygon.push_back(collisionPoint)
		else:
			polygon.push_back(ray.get_cast_to())
	$BlastImage.set_polygon(polygon)
	$CollisionPolygon2D.set_polygon(polygon)



