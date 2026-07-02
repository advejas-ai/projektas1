extends Camera2D

@export var follow_node_path: NodePath

var target: Node2D

func _ready() -> void:
	if follow_node_path:
		target = get_node(follow_node_path)

func _physics_process(_delta: float) -> void:
	if target:
		global_position = target.global_position
