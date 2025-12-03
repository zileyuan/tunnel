extends Node3D

# 使用 @export 变量，你可以在检视器中直接编辑这些值。
@export var num_lights = 3 # 想要生成的灯光数量
@export var spacing = 10.0 # 每个灯光之间的间距（单位：米）
@export var light_y_position = 1.0 # 灯光的高度
@export var light_z_position = -2.3 # 灯光在 Z 轴上的位置
@export var light_range = 6.0
@export var light_energy = 5.0
@export var light_color = Color.WHITE

func new_light() -> OmniLight3D:
	var light = OmniLight3D.new()
	light.light_color = light_color
	light.light_energy = light_energy
	light.omni_range = light_range
	light.light_size = 0.3
	light.light_specular = 0.8
	light.shadow_enabled = true
	return light

func _ready():
	# 创建一个空的 Node3D 来作为所有生成灯光的父节点
	var lights_container = Node3D.new()
	lights_container.name = "Lights"
	add_child(lights_container)
	
	var zero_light = new_light()
	zero_light.position = Vector3(0, light_y_position, light_z_position)
	lights_container.add_child(zero_light)
	
	# 循环 num_lights 次来生成灯光
	# i 从 1 开始，避免在中心点（x=0）生成两次
	for i in range(1, num_lights + 1):
		# 1. 生成正向灯光
		var pos_light = new_light()
		pos_light.position = Vector3(i * spacing, light_y_position, light_z_position)
		lights_container.add_child(pos_light)
		
		# 2. 生成负向灯光
		var neg_light = new_light()
		neg_light.position = Vector3(-i * spacing, light_y_position, light_z_position)
		lights_container.add_child(neg_light)
