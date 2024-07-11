class_name Face extends MeshInstance3D

func p1():
	material_override.set_shader_parameter("color", Color.BLUE)

func p2():
	material_override.set_shader_parameter("color", Color.RED)
