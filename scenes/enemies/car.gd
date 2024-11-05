extends PathFollow2D

#Stats

var turret_dmg: int = 20;
var car_health: int = 20;

#Boolean
var player_nearby: bool = false;

@onready var turret: Node2D = $Turret;
@onready var line1: Line2D = $Turret/RayCast2D/Line2D;
@onready var line2: Line2D = $Turret/RayCast2D2/Line2D;
@onready var gunfire1: Sprite2D = $Turret/GunFire1_Sprite2D;
@onready var gunfire2: Sprite2D = $Turret/GunFire2_Sprite2D;

var target_in_range: Node2D;

func _ready() -> void:
	line2.add_point($Turret/RayCast2D2.target_position)
	line2.width = 0;
	line1.width = 0;
	

func fire():
	if player_nearby:
		if "hit" in target_in_range and target_in_range != null:
			target_in_range.hit(turret_dmg);
			gunfire1.modulate.a = 1;
			gunfire2.modulate.a = 1;
			var tween = create_tween();
			tween.set_parallel();
			tween.tween_property(gunfire1, "modulate",0,randf_range(0.1,0.5));
			tween.tween_property(gunfire2, "modulate",0,randf_range(0.1,0.5));
	

func _process(delta: float) -> void:
	progress_ratio += 0.02 * delta;
	if player_nearby:
		turret.look_at(Globals.player_position);
		

func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	player_nearby = true;
	target_in_range = body;
	$AnimationPlayer.play("laser_load");


func _on_attack_area_2d_body_exited(_body: Node2D) -> void:
	player_nearby = false;
	target_in_range = null;
	var tween = create_tween();
	tween.set_parallel();
	tween.tween_property(line1, "width",0, randf_range(0.1,0.5));
	tween.tween_property(line2, "width",0, randf_range(0.1,0.5));
	await tween.finished
	$AnimationPlayer.stop();
	
