extends CharacterBody3D

@export var rotation_speed = 25.0
@export var max_rotation = 100.0
@export var min_rotation = 0.0

const DOUBLE_CLICK_MAX_DELAY = 0.3  # 双击最大间隔时间（秒）
var last_click_time: float = 0.0    # 记录上一次“按下并释放”动作的时间

func _input(_event):
	if Input.is_action_pressed("interact"):
		var current_time = Time.get_ticks_msec() / 1000.0  # 当前时间（秒）
		var time_since_last_click = current_time - last_click_time
		if time_since_last_click < DOUBLE_CLICK_MAX_DELAY:
			$DoubleClickTimer.stop()
			open_door()
			last_click_time = 0.0
		else:
			$DoubleClickTimer.start(DOUBLE_CLICK_MAX_DELAY)
			last_click_time = current_time

func rotate_door(input_rotation_speed: float) -> void:
	# 门的当前旋转角度（以度为单位）
	var current_rotation = rad_to_deg(self.rotation.y)
	print("current_rotation: ", current_rotation)
	
	# 计算目标旋转角度
	var target_rotation = current_rotation + input_rotation_speed
	
	# 限制旋转角度
	if target_rotation > max_rotation:
		target_rotation = max_rotation
		
	if target_rotation < min_rotation:
		target_rotation = min_rotation
		
	print("target_rotation: ", target_rotation)
	
	# 启动补间动画
	var tween = create_tween()
	tween.tween_property(self, "rotation:y", deg_to_rad(target_rotation), 4)

func open_door():
	rotate_door(rotation_speed)

func close_door():
	rotate_door(-rotation_speed)
	
func is_pushed_from(pusher_position: Vector3) -> bool:
	var local_position = to_local(pusher_position)
	var local_y_angle_rad = atan2(local_position.x, local_position.z)
	var local_y_angle_deg = rad_to_deg(local_y_angle_rad)
	var current_rotation = rad_to_deg(self.rotation.y)
	return local_y_angle_deg < current_rotation

func _on_double_click_timer_timeout() -> void:
	close_door()
