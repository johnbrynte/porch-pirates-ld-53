extends RigidBody3D

#const GRAVITY = 20
const GRAVITY_SCALE = 3
const LINEAR_DRAG = 0.2
const ANGULAR_DRAG = 4

#@export var model: Resource = null

func _ready():
	gravity_scale = GRAVITY_SCALE
	linear_damp = LINEAR_DRAG
	angular_damp = ANGULAR_DRAG
#	var obj = model.instantiate()
#	obj.position = Vector3.ZERO
#	$model.add_child(obj)

func shoot(dir: Vector3, force: float):
	apply_impulse(dir * force)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	var space_state = get_world_3d().direct_space_state
#	# use global coordinates, not local to node
#	var query = PhysicsRayQueryParameters3D.create(Vector3.ZERO, Vector3.DOWN)
#	var result = space_state.intersect_ray(query)
#
#	if result == null:
#		apply_central_force(Vector3.DOWN * GRAVITY)
