##A node used as the parent of other control nodes to display them in 3D.
@tool class_name Control3D extends MeshInstance3D

##The size of the [QuadMesh].
@export var size:Vector2 = Vector2(1, 1) :
	set(value):
		size = value
		mesh.size = value
		if force_viewport_aspect_ratio:
			set_viewport_size(value*viewport_resolution_scale)

##The resolution of the [SubViewport].
@export var viewport_resolution:Vector2 = Vector2(512, 512):
	set(value):
		viewport_resolution = value
		set_viewport_size(value)

##If set to true it overwrites the [SubViewport]s size with size*viewport_resolution_scale.
@export var force_viewport_aspect_ratio:bool = false
##Only used if force_viewport_aspect_ratio is set to true.
##Overwrites the [SubViewport]s size with size*viewport_resolution_scale.
@export var viewport_resolution_scale:int = 512:
	set(value):
		viewport_resolution_scale = value
		if force_viewport_aspect_ratio:
			set_viewport_size(size*value)

##Sets the billboard mode of the [QuadMesh].
@export_enum("Disabled", "Enabled", "Y-Billboard") var billboard_mode:int = 0 :
	set(value):
		billboard_mode = value
		mesh.surface_get_material(0).billboard_mode = value

##Refreshes the [SubViewport]s children. Meant only for use in the editor
@export var force_refresh_viewport:bool = false:
	set(value):
		refresh_viewport()

func _ready() -> void:
	var subViewport := SubViewport.new()
	subViewport.name = "SubViewport"
	subViewport.disable_3d = true
	set_viewport_size(viewport_resolution)
	if force_viewport_aspect_ratio: set_viewport_size(size*viewport_resolution_scale)
	add_child(subViewport, true)
	mesh = QuadMesh.new()
	mesh.size = size
	var mat := StandardMaterial3D.new()
	mat.albedo_texture = $SubViewport.get_texture()
	mat.billboard_mode = billboard_mode
	mat.shading_mode = mat.SHADING_MODE_UNSHADED
	mesh.surface_set_material(0, mat)
	if Engine.is_editor_hint(): return
	for child in get_children():
		if child is Control:
			remove_child(child)
			$SubViewport.add_child(child)

##Gets all of the [SubViewport]s child nodes
func get_control_nodes(include_internal: bool = false) -> Array[Node]:
	return $SubViewport.get_children(include_internal)

##Deletes all of the [SubViewport]s children
func clear_viewport():
	for child in get_control_nodes():
		child.queue_free()

##Adds all [Control] node children to the [SubViewport]
func add_control_to_viewport():
	for child in get_children():
		if child is Control:
			var new = child.duplicate()
			$SubViewport.add_child(new)

##Sets the size of the [SubViewport]
func set_viewport_size(s:Vector2):
	$SubViewport.size = s

##Calls clears the [SubViewport]s children then adds the new [Control] nodes
func refresh_viewport():
	clear_viewport()
	add_control_to_viewport()
