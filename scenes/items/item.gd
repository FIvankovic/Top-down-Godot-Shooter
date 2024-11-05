extends Area2D 

var rotation_speed: int = 5;
var options = ['ammo','grenade','health','ammo','ammo','ammo'];
var type = options[randi()%len(options)];

var direction: Vector2;
var distance: int = randi_range(150,250);

#Ref
@onready var item_glow: PointLight2D = $ItemGlow_PointLight2D;


func _ready() -> void:
	print(type);
	if type == 'ammo':
		$ItemSprite.modulate = Color(0,0,0.4,1);
		item_glow.modulate = Color(0,0,0.4,1);
	elif  type == 'grenade':
		$ItemSprite.modulate = Color(0.3,0,0,1);
		item_glow.modulate = Color(0.3,0,0,1);
	elif type == 'health':
		$ItemSprite.modulate = Color(0,0.3,0,1);
		item_glow.modulate = Color(0,0.3,0,1);
		
	#tween
	var target_position = position + direction * distance;
	var tween = create_tween();
	tween.set_parallel(true);
	tween.tween_property(self, "position", target_position, 0.5);
	tween.tween_property(self, "scale", Vector2(1,1), 0.3).from(Vector2(0,0));

func _process(delta: float) -> void:
	rotation += rotation_speed * delta;

func pickUp() -> void:
	$ItemPickup_SFX.play();
	$ItemSprite.hide();
	item_glow.hide();
	await  $ItemPickup_SFX.finished
	queue_free();

func _on_body_entered(_body: Node2D) -> void:
	if type == 'ammo':
		Globals.bullet_count += 5;
		pickUp();
	if type == 'grenade':
		Globals.grenade_count += 1;
		pickUp();
	if type == 'health':
		if Globals.player_health < 100:
			Globals.player_health += 10;
			pickUp();
