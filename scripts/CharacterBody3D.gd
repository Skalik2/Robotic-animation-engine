extends CharacterBody3D

@onready var head = $head
@onready var spot_light_3d = $head/SpotLight3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const mouse_sensitivity = 0.1

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var flashlight = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(event.relative.x * -mouse_sensitivity))
		head.rotate_x(deg_to_rad(event.relative.y * -mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x,deg_to_rad(-90),deg_to_rad(90))

func _physics_process(delta):

	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_key_pressed(KEY_1):
		Global.setCubeSpeed(1.5,4)
	if Input.is_key_pressed(KEY_2):
		Global.setCubeSpeed(3,8)
	if Input.is_key_pressed(KEY_3):
		Global.setCubeSpeed(6,16)
	if Input.is_key_pressed(KEY_4):
		Global.setCubeSpeed(12,32)
	if Input.is_key_pressed(KEY_0):
		Global.setCubeSpeed(0,0)
	if Input.is_key_pressed(KEY_F):
		if flashlight:
			spot_light_3d.position = spot_light_3d.position - Vector3(0,-20,0)
			flashlight = false
		else:
			spot_light_3d.position = spot_light_3d.position - Vector3(0,+20,0)
			flashlight = true

	var input_dir = Input.get_vector("lewo", "prawo", "przod", "tyl")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
