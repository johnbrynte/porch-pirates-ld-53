extends RigidBody3D

const GRAVITY = 20

func shoot(dir: Vector3, force: float):
	apply_impulse(dir * force)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	apply_central_force(Vector3.DOWN * GRAVITY)
