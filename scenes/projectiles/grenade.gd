extends RigidBody2D

#Variables
@export var speed: int = 700;
#var direction: Vector2 = Vector2.UP;
var explosion_active: bool = false;
var explosion_radius: int = 400;
var grenade_dmg: int = 10;

func _process(_delta: float) -> void:
	if explosion_active:
		#print('Grenade explodes.');
		var targets = get_tree().get_nodes_in_group("Container") + get_tree().get_nodes_in_group("Entity");
		for target in targets:
			var in_range = target.global_position.distance_to(global_position) < explosion_radius;
			if "hit" in target and in_range:
				target.hit(grenade_dmg);
				

func explode():
	$Explosion3.visible = true; #Enables the explosion visual effect - by default should be off
	$AnimationPlayer.play("explosion");
	explosion_active = true;
