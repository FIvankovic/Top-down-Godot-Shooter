extends Area2D

@export var speed: int = 1000; #Export places the value into the inspector
var direction: Vector2 = Vector2.UP; # Default position
var projectile_dmg: int = 2;

#_ready triggers immediately when the object is "created"/"enters the node treee"
func _ready() -> void:
	$LaserLifespan.start();

#_process runs each frame
func _process(delta: float) -> void:
	position += direction * speed * delta;


func _on_body_entered(body: Node2D) -> void:
	print("Laser collided:");
	print(body);
	
	#Check if the hit target has the hit() function in it
	if "hit" in body:
		body.hit(projectile_dmg);
	queue_free(); #Remove projectile from level on collision

#Kill the laser
func _on_laser_lifespan_timeout() -> void:
	queue_free();
