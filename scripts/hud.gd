extends Control

@onready var cooldown_bar: ProgressBar = $CooldownBar
@onready var label: Label = $Label

var player: CharacterBody2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	if not player:
		return

	var cooldown_left: float = player.cooldown_time_left
	var dash_cooldown: float = player.dash_cooldown
	var ratio: float = 1.0 - (cooldown_left / dash_cooldown) if dash_cooldown > 0 else 1.0
	cooldown_bar.value = ratio * 100.0

	if ratio >= 1.0:
		label.text = "DASH READY"
	else:
		label.text = "DASH %.1fs" % cooldown_left
