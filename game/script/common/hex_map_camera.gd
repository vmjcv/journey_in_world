extends Spatial

onready var swivel = $swivel
onready var stick = $swivel/stick
onready var main_camera = $swivel/stick/main_camera

var hex_metrics = HexStatic.HexMetrics.new()

var grid

export(float, 0.0, 1.0) var sensitivity = 0.25
var _mouse_position = Vector2(0.0, 0.0)
var _total_pitch = 0.0

var zoom = 1.0
export (float, 0.0, 1.0) var  zoom_delta = 0.02

var stick_min_zoom = 45
var stick_max_zoom = 250

var swivel_min_zoom = deg2rad(-45)
var swivel_max_zoom  = deg2rad(-90)

var _w = false
var _s = false
var _a = false
var _d = false
var _q = false
var _e = false


# Movement state
var _direction = Vector3(0.0, 0.0, 0.0)
var _velocity = Vector3(0.0, 0.0, 0.0)
var _acceleration = 30
var _deceleration = -10
var move_min_zoom = 400
var move_max_zoom  = 100
var _vel_multiplier = move_max_zoom
var rotation_speed = 2

func adjust_zoom(delta):
	zoom = clamp(zoom+delta,0.2,1)
	stick.translation.z = lerp(stick_max_zoom,stick_min_zoom,zoom)
	# var angle = lerp_angle(swivel_max_zoom,swivel_min_zoom,zoom)
	# swivel.rotation.x = angle
	print(Transform(main_camera.global_transform.basis))
	var rotation_axis = main_camera.to_global(main_camera.transform.basis.z).cross(Vector3.UP)
	swivel.global_rotate(rotation_axis,0.2)

	var cur_offset = Transform(main_camera.global_transform.basis).xform(stick.translation)
	print(cur_offset)
	stick.global_transform.origin = cur_offset + global_transform.origin

func _input(event):
	# Receives mouse motion
	if event is InputEventMouseMotion:
		_mouse_position = event.relative

	# Receives mouse button input
	if event is InputEventMouseButton:
		match event.button_index:
			BUTTON_RIGHT: # Only allows rotation if right click down
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if event.pressed else Input.MOUSE_MODE_VISIBLE)
			BUTTON_WHEEL_UP: # Increases max velocitydddddddddddddd
				adjust_zoom(zoom_delta)
				_vel_multiplier = lerp(move_min_zoom,move_max_zoom,zoom)
			BUTTON_WHEEL_DOWN: # Decereases max velocity
				adjust_zoom(-zoom_delta)
				_vel_multiplier =lerp(move_min_zoom,move_max_zoom,zoom)

	# Receives key input
	if event is InputEventKey:
		match event.scancode:
			KEY_W:
				_w = event.pressed
			KEY_S:
				_s = event.pressed
			KEY_A:
				_a = event.pressed
			KEY_D:
				_d = event.pressed
			KEY_Q:
				_q = event.pressed
			KEY_E:
				_e = event.pressed

func _process(delta):
	# _update_mouselook()
	_update_movement(delta)
	_update_rotation(delta)

# Updates camera movement
func _update_movement(delta):
	# Computes desired direction from key states
	_direction =swivel.transform.xform(Vector3(_d as float - _a as float,
						 0,
						 _s as float - _w as float))

	# Computes the change in velocity due to desired direction and "drag"
	# The "drag" is a constant acceleration on the camera to bring it's velocity to 0
	var offset = _direction.normalized() * _acceleration * _vel_multiplier * delta \
		+ _velocity.normalized() * _deceleration * _vel_multiplier * delta

	# Checks if we should bother translating the camera
	if _direction == Vector3.ZERO and offset.length_squared() > _velocity.length_squared():
		# Sets the velocity to 0 to prevent jittering due to imperfect deceleration
		_velocity = Vector3.ZERO
	else:
		# Clamps speed to stay within maximum value (_vel_multiplier)
		_velocity.x = clamp(_velocity.x + offset.x, -_vel_multiplier, _vel_multiplier)
		_velocity.y = 0
		_velocity.z = clamp(_velocity.z + offset.z, -_vel_multiplier, _vel_multiplier)
		var displacement = _velocity * delta
		#
		displacement = Transform(main_camera.global_transform.basis).xform(displacement)
		displacement.y = 0
		translate(displacement)
		translation = clamp_position(translation)


# Updates mouse look
func _update_rotation(delta):
	var rotation_direction = _q as float - _e as float
	main_camera.global_rotate(Vector3.UP,deg2rad(rotation_speed*rotation_direction))


func clamp_position(position):
	var x_max = (grid.chunk_count_x *hex_metrics.chunk_size_x - 0.5)*(2*hex_metrics.inner_radius)
	position.x = clamp(position.x,0,x_max)
	var z_max = (grid.chunk_count_z *hex_metrics.chunk_size_z-1)*(1.5*hex_metrics.outer_radius)
	position.z = clamp(position.z,0,z_max)
	# todo
	# �Ƿ���Ҫ�е���Ե�������������ĵ���ʾ
	return position
