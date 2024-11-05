extends CanvasLayer

#Color
var green: Color = Color("6bbfa3");
var red: Color = Color(0.9,0,0,1);

#@onready triggers immediately when the object is "created"/"enters the node treee"
@onready var bullet_label: Label = $BulletCounter/VBoxContainer/Label;
@onready var grenade_label: Label = $GrenadeCounter/VBoxContainer/Label;
@onready var bullet_icon: TextureRect = $BulletCounter/VBoxContainer/BulletTextureRect;
@onready var grenade_icon: TextureRect = $GrenadeCounter/VBoxContainer/GrenadeTextureRect;
@onready var health_bar: TextureProgressBar = $MarginContainer/TextureProgressBar
@onready var health_label: Label = $MarginContainer/Label;

func _ready() -> void:
	Globals.connect("player_stats_changed", update_stats_text);
	#Globals.connect("health_changed", update_stats_text);
	#Globals.connect("bullet_count_changed", update_grenade_text);
	#Globals.connect("greande_count_changed", update_bullet_text);
	update_stats_text();

func update_stats_text():
	update_health_text();
	update_bullet_text();
	update_grenade_text();

func update_bullet_text():
	bullet_label.text = str(Globals.bullet_count);
	update_color(Globals.bullet_count, bullet_label, bullet_icon);
	#print("Bullet count: " + str(Globals.bullet_count));
	
func update_grenade_text():
	grenade_label.text = str(Globals.grenade_count);
	update_color(Globals.grenade_count, grenade_label, grenade_icon);
	#print("Grenade count: " + str(Globals.grenade_count));
	
func update_health_text():
	#print(Globals.player_health);
	health_bar.value = Globals.player_health;
	health_label.text = " " + str(Globals.player_health) + "%";
	#print("Player health: " + str(Globals.player_health));
	
#Updates the color for grenade and bullet icons
func update_color(amount: int, label: Label, icon: TextureRect) -> void:
	if amount > 0:
		label.modulate = green;
		icon.modulate = green;
	elif amount <= 0:
		label.modulate = red;
		icon.modulate = red;
