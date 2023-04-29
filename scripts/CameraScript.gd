extends Node3D

@export var player: Node3D

const ROTATION_RANGE_X = Vector2(-40, 22)

var mouse_sens = 0.3
var camera_anglev = 0

var invert_x_axis = true
var invert_y_axis = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotation.y += (1 if invert_x_axis else -1) * (deg_to_rad(-event.relative.x * mouse_sens))
		var changev = -event.relative.y * mouse_sens
		if camera_anglev + changev > ROTATION_RANGE_X.x and camera_anglev + changev < ROTATION_RANGE_X.y:
			camera_anglev += changev
			$Pivot.rotation.x += (1 if invert_y_axis else -1) * (deg_to_rad(changev))

func _process(delta):
	position = player.position

func get_y_rotation():
	return rotation.y

func get_direction():
	return -get_basis().z - Vector3.UP * $Pivot.get_basis().z

#func get_basis():
#	return get_global_transform().basis
