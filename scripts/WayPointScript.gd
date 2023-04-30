@tool
extends Node3D

enum WayPointType { Street, Other }

@export var type: WayPointType = WayPointType.Street : set = _set_type
@export var neighbor1: Node3D = null
@export var neighbor2: Node3D = null
@export var neighbor3: Node3D = null
@export var neighbor4: Node3D = null

var rand = RandomNumberGenerator.new()

const type_colors = {
	WayPointType.Street: Color(1.0, 0.0, 0.0),
	WayPointType.Other: Color(0.0, 0.0, 1.0),
}

func get_next_neighbor(from: Node3D):
	var all_neighbors = [ neighbor1, neighbor2, neighbor3, neighbor4 ].filter(func(n): return n != null)
	var neighbors = all_neighbors.filter(func(n): return n != from)
	
	if neighbors.size() == 0:
		if all_neighbors.size() == 1:
			return all_neighbors[0]
		else:
			return null
	else:
		return neighbors[rand.randi_range(0, neighbors.size() - 1)]

# Called when the node enters the scene tree for the first time.
func _ready():
	rand.randomize()

	if not Engine.is_editor_hint():
		hide()

	_set_type(type)

func _set_type(new_type: WayPointType):
	type = new_type
	for group in WayPointType:
		remove_from_group(group)
	add_to_group(WayPointType.keys()[type])
	print("add to group %s" % WayPointType.keys()[type])
	$Model.get_active_material(0).set_shader_parameter("Color", type_colors[new_type])
