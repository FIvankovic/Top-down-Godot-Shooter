extends Node2D
class_name LevelParent;

var laser_scene: PackedScene = preload("res://scenes/projectiles/laser.tscn");
var laser_enemy_scene: PackedScene = preload("res://scenes/projectiles/laser_enemy.tscn");
var grenade_scene: PackedScene = preload("res://scenes/projectiles/grenade.tscn");
var item_scene: PackedScene = preload("res://scenes/items/item.tscn");
#var user_interface: CanvasLayer = $UI;

func _ready() -> void:
	for container in get_tree().get_nodes_in_group('Container'):
		container.connect("open", _on_container_opened);
	for scout in get_tree().get_nodes_in_group('Scouts'):
		scout.connect("shoot", _on_scout_laser);
		

func _on_container_opened(pos, direction):
	print("Container opened.")
	var item = item_scene.instantiate();
	item.position = pos;
	item.direction = direction;
	$Items.call_deferred('add_child', item);
	

func create_shot_projectile(pos: Vector2, direction: Vector2, source: String) -> void:
	#print("Shoot from level.");
	var laser;
	if source == "ally":
		laser = laser_scene.instantiate() as Area2D;
		laser.projectile_dmg = 2;
	else:
		laser = laser_enemy_scene.instantiate() as Area2D;
		laser.projectile_dmg = 10;

	# Normalize the direction to ensure consistency
	#direction = direction.normalized()
	#pos = pos.clamp(Vector2(10000, 10000));

	
	print("Direction: ", direction)
	print("Position: ", pos)
	laser.position = pos;
	laser.rotation_degrees = rad_to_deg(direction.angle()) + 90;
	laser.direction = direction;
	$ProjectilesNode.add_child(laser); #Spawns projectiles under a specific node to not clutter

#Player Functions
func _on_player_shoot_input_pressed(pos, direction, source) -> void:
	create_shot_projectile(pos,direction, source);

#Player shoots grenade inside lvl
func _on_player_grenade_input_pressed(pos, direction) -> void:
	#print("Grenade from level.");
	var grenade = grenade_scene.instantiate() as RigidBody2D;
	grenade.position = pos;
	grenade.linear_velocity = direction * grenade.speed;
	$ProjectilesNode.add_child(grenade);

#Scouts Functions
func _on_scout_laser(pos,direction, source: String) -> void:
	#print("Scout shooting projectile from lvl.");
	create_shot_projectile(pos,direction,source);
