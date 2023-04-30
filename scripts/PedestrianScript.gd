extends CharacterBody3D

var movement_speed: float = 4.0
@onready var navigation_agent: NavigationAgent3D = get_node("NavigationAgent3D")

var previous_way_point: Node3D = null
var target_way_point: Node3D = null

var rand = RandomNumberGenerator.new()

func _ready() -> void:
	rand.randomize()
	movement_speed = rand.randf_range(2.0, 4.0)

	navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	
	find_next_target()

func find_next_target():
	var way_points = get_tree().get_nodes_in_group("Street")

	if way_points.size() > 0:
		set_movement_target(way_points[0])

func set_movement_target(movement_target: Node3D):
	navigation_agent.set_target_position(movement_target.position)
	previous_way_point = target_way_point
	target_way_point = movement_target

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		if target_way_point != null:
			var to_way_point = target_way_point.get_next_neighbor(previous_way_point)
			if to_way_point != null:
				set_movement_target(to_way_point)
		return

	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var current_agent_position: Vector3 = global_position
	var new_velocity: Vector3 = (next_path_position - current_agent_position).normalized() * movement_speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()
