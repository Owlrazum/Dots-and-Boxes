class_name Edge extends MeshInstance3D

func get_center_position(lh, rh) -> Vector3:
	return (lh.position + rh.position) / 2.0

func get_center_rotation(lh, rh) -> Vector3:
	return Basis.looking_at(rh.position - lh.position).get_euler()
