extends CharacterBody3D

@export var rotation_speed = 25.0
@export var max_rotation = 100.0
@export var min_rotation = 0.0

func _input(event):
	# 检查是否为鼠标左键点击
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			close_door()
			print("close_door!")
		if event.button_index == MOUSE_BUTTON_RIGHT:
			open_door()
			print("open_door!")
	if Input.is_action_pressed("interact"):
		open_door()

func open_door():
	# 门的当前旋转角度（以度为单位）
	var current_rotation = rad_to_deg(self.rotation.y)
	print("current_rotation: ", current_rotation)
	
	# 计算目标旋转角度
	var target_rotation = current_rotation + rotation_speed
	
	# 限制旋转角度
	if target_rotation > max_rotation:
		target_rotation = max_rotation
		
	if target_rotation < min_rotation:
		target_rotation = min_rotation
		
	print("target_rotation: ", target_rotation)
	
	# 启动补间动画
	var tween = create_tween()
	tween.tween_property(self, "rotation:y", deg_to_rad(target_rotation), 4)

func close_door():
	# 门的当前旋转角度（以度为单位）
	var current_rotation = rad_to_deg(self.rotation.y)
	print("current_rotation: ", current_rotation)
	
	# 计算目标旋转角度
	var target_rotation = current_rotation - rotation_speed
	
	# 限制旋转角度
	if target_rotation > max_rotation:
		target_rotation = max_rotation
		
	if target_rotation < min_rotation:
		target_rotation = min_rotation
		
	print("target_rotation: ", target_rotation)
	
	# 启动补间动画
	var tween = create_tween()
	tween.tween_property(self, "rotation:y", deg_to_rad(target_rotation), 4)
	
func is_pushed_from(pusher_position: Vector3) -> bool:
	var local_position = to_local(pusher_position)
	var local_y_angle_rad = atan2(local_position.x, local_position.z)
	var local_y_angle_deg = rad_to_deg(local_y_angle_rad)
	var current_rotation = rad_to_deg(self.rotation.y)
	return local_y_angle_deg < current_rotation
