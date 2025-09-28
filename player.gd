extends CharacterBody3D

# 移动速度
@export var walk_speed = 5.0
@export var run_speed = 9.0
@export var rotation_speed = 2.0 # 新增：角色旋转速度

# 跳跃速度
@export var jump_velocity = 4.5

# 获取重力值，通过 Godot 的项目设置来获取
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# 节点引用
@onready var camera_pivot = $SpringArm3D
@onready var animation_tree = $AnimationTree
@onready var character_model = $Sketchfab_Scene
@onready var anim_state = animation_tree.get("parameters/playback")

func _ready():
	animation_tree.active = true
	#call_deferred("_start_animation")

#func _start_animation():
	#anim_state.travel("WalkRunBlend")
##
#func _physics_process(delta):
	### 只更新 blend_position，不再 travel
	#animation_tree.set("parameters/WalkRunBlend/blend_position", 0.7)
	
func _physics_process(delta):
	# 处理重力
	if not is_on_floor():
		velocity.y -= gravity * delta

	# 处理跳跃
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		#anim_state.travel("Launching")
	
	# 获取输入方向
	# 获取旋转输入 (来自 A 和 D)
	var rotation_dir = Input.get_axis("rotation_right", "rotation_left")
	print("rotation_dir: ", rotation_dir)
	# 获取移动输入 (来自 W/S 和 Q/E)
	var move_dir = Input.get_vector("strafe_left", "strafe_right", "forward", "backward")
	print("move_dir: ", move_dir)
	
	# 1. 旋转角色 (使用 A 和 D)
	rotation.y += rotation_dir * rotation_speed * delta
	# 2. 移动角色 (使用 W/S 和 Q/E)
	# 移动方向是相对于角色的本地坐标系
	var final_direction = (transform.basis * Vector3(move_dir.x, 0, move_dir.y)).normalized()

	# 根据方向和速度更新角色的物理速度
	var current_speed = walk_speed
	if Input.is_action_pressed("run") or not is_on_floor():
		current_speed = run_speed

	if final_direction:
		velocity.x = final_direction.x * current_speed
		velocity.z = final_direction.z * current_speed
	else:
		# 平滑地停止
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	# 动画控制部分
	if is_on_floor():
		anim_state.travel("WalkRunBlend")
		var horizontal_velocity = Vector2(velocity.x, velocity.z).length()
		#print("Horizontal Velocity: ", horizontal_velocity)
		## 根据输入向量的长度驱动动画
		animation_tree.set("parameters/WalkRunBlend/blend_position", horizontal_velocity)

	var collision_info = move_and_slide()
	
	# 如果发生了碰撞，并且按下了交互键
	if collision_info and velocity.length() > 0:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			
			# 检查碰撞的物体是否是门
			if collider.has_method("open_door") and collider.has_method("close_door"):
				if collider.is_pushed_from(global_position):
					collider.close_door()
				else:
					collider.open_door()
