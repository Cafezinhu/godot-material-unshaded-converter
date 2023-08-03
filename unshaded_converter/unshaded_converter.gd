@tool
extends EditorPlugin

var dock

var folder_text: LineEdit

func _enter_tree() -> void:
	dock = load("res://addons/unshaded_converter/unshaded_converter.tscn").instantiate()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL, dock)
	
	var convert_button: Button = dock.get_node("Convert")
	convert_button.pressed.connect(convert)
	folder_text = dock.get_node("Folder/LineEdit")


func convert() -> void:
	var path = folder_text.text
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var file_path = path + file_name
			print("Converting ", file_path)
			var resource: StandardMaterial3D = load(file_path)
			resource.cull_mode = 0
			resource.shading_mode = 0
			ResourceSaver.save(resource, file_path)
			file_name = dir.get_next()
		print("All materials converted!")

func _exit_tree() -> void:
	remove_control_from_docks(dock)
	dock.free()
