extends Node3D

# 使用 @export 变量，你可以在检视器中直接编辑这些值。
@export var num_lights = 24 # 想要生成的灯光数量
@export var spacing = 10.0 # 每个灯光之间的间距（单位：米）
@export var light_y_position = 1.0 # 灯光的高度
@export var light_z_position = -2.3 # 灯光在 Z 轴上的位置
@export var light_range = 6.0
@export var light_energy = 5.0
@export var light_color = Color.WHITE

func _ready():
	# 创建一个空的 Node3D 来作为所有生成灯光的父节点
	var lights_container = Node3D.new()
	lights_container.name = "Lights"
	add_child(lights_container)
	
	var zero_light = OmniLight3D.new()
	zero_light.global_position = Vector3(0, light_y_position, light_z_position)
	zero_light.light_color = light_color
	zero_light.light_energy = light_energy
	zero_light.omni_range = light_range
	zero_light.light_size = 0.3
	zero_light.light_specular = 0.8
	zero_light.shadow_enabled = true
	lights_container.add_child(zero_light)
	# 循环 num_lights 次来生成灯光
	# i 从 1 开始，避免在中心点（x=0）生成两次
	for i in range(1, num_lights + 1):
		# 1. 生成正向灯光
		var pos_light = OmniLight3D.new()
		pos_light.global_position = Vector3(i * spacing, light_y_position, light_z_position)
		pos_light.light_color = light_color
		pos_light.light_energy = light_energy
		pos_light.omni_range = light_range
		pos_light.light_size = 0.3
		pos_light.light_specular = 0.8
		pos_light.shadow_enabled = true
		lights_container.add_child(pos_light)
		
		# 2. 生成负向灯光
		var neg_light = OmniLight3D.new()
		neg_light.global_position = Vector3(-i * spacing, light_y_position, light_z_position)
		neg_light.light_color = light_color
		neg_light.light_energy = light_energy
		neg_light.omni_range = light_range
		neg_light.light_size = 0.3
		neg_light.light_specular = 0.8
		neg_light.shadow_enabled = true
		lights_container.add_child(neg_light)
