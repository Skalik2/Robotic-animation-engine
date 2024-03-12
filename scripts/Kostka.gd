extends StaticBody3D

@onready var kostka = $"."
@onready var robot_2 = $"../robot2"
@onready var belt = $"../belt-long"
@onready var robot1Animation = $"../robot/Armature/Skeleton3D/SkeletonIK3D/AnimationPlayer"
@onready var cube_001 = $"../robot/Armature/Skeleton3D/Cube_001"
@onready var cylinder_006 = $"../robot/Armature/Skeleton3D/Cylinder_006-col/Cylinder_006"
@onready var belt_long_2 = $"../belt-long2"
@onready var animacjaKolorujaca = $"../maszyna-kolorujaca/AnimationPlayer"
@onready var kostkaKolorowa = $"../kostka"
@onready var anim2Robot2 = $"../robot2/Armature/Skeleton3D/SkeletonIK3D/AnimationPlayer2"
@onready var yaskawaGrabPart = $"../robotY/Armature_001/Skeleton3D/Plane_006/node3d/grabPart"
@onready var yaskawaRotationPart = $"../robotY/Armature_001/Skeleton3D/Plane_006/Plane_006"
@onready var robot1GrabPart = $"../robot/Armature/Skeleton3D/Cube_001/Node3D/grabPart"
@onready var robot2GrabPart = $"../robot2/Armature/Skeleton3D/Cube_001/Node3D/grabPart"
@onready var mesh_grab_part = $"../robot/Armature/Skeleton3D/Cube_001/Cube_001/GrabPart/MeshGrabPart"
@onready var robot1RotationPart = $"../robot/Armature/Skeleton3D/Cylinder_006-col"
@onready var robot2RotationPart = $"../robot2/Armature/Skeleton3D/Cylinder_006-col/Cylinder_006"


@onready var belt1koniec = $"../belt-long1/Koniec"
@onready var belt1start = $"../belt-long1/Start"
@onready var belt2start = $"../belt-long2/Start"
@onready var belt2koniec = $"../belt-long2/Stop"
@onready var belt3start = $"../belt-long3/Start"
@onready var belt3koniec = $"../belt-long3/Stop"
@onready var belt4start = $"../belt-long4/Start"
@onready var belt4koniec = $"../belt-long4/Stop"
@onready var belt5start = $"../belt-long5/Start"
@onready var belt5koniec = $"../belt-long5/Stop"

@onready var animBelt1 = $"../belt-long1/AnimationPlayer"
@onready var animBelt2 = $"../belt-long2/AnimationPlayer"
@onready var animBelt3 = $"../belt-long3/AnimationPlayer"
@onready var animBelt4 = $"../belt-long4/AnimationPlayer"
@onready var animBelt5 = $"../belt-long5/AnimationPlayer"
@onready var animYaskawa = $"../robotY/Armature_001/Skeleton3D/SkeletonIK3D/AnimationPlayer"

var onRobot = false
var maszynaKolorReady = false
var defaultSpeed = 0
var stage = 0

func changeSpeed():
	defaultSpeed = Global.cubeSpeed
	animBelt1.speed_scale = Global.beltSpeed
	animBelt3.speed_scale = Global.beltSpeed
	animBelt2.speed_scale = Global.beltSpeed
	animBelt4.speed_scale = Global.beltSpeed
	animBelt5.speed_scale = Global.beltSpeed

func onRobotFunc(object, robotPart):
	object.position = robotPart.global_position - Vector3(0, 0.3, 0)
	object.rotation = robotPart.rotation

func _ready():
	anim2Robot2.play("standby")
	changeSpeed()
	kostka.position = (belt1start.global_position)
	
func _process(delta):
	changeSpeed()
	if (stage == 0):
		if round(kostka.global_position) != round(belt1koniec.global_position):
			kostka.translate(Vector3(-defaultSpeed*delta, 0, 0))
		else:
			stage = 1
	elif (stage == 1):
		if !robot1Animation.is_playing():
			robot1Animation.play("left_swing 1-2")
			stage = 2
	elif (stage == 2):
		if !robot1Animation.is_playing():
			kostka.position = robot1GrabPart.global_position
			kostka.rotation = robot1GrabPart.global_rotation - Vector3(0, 0, 180)
			robot1Animation.play("left_swing 2-2")
			stage = 3
	elif (stage == 3):
		kostka.position = robot1GrabPart.global_position
		kostka.rotation = robot1RotationPart.global_rotation
		if !robot1Animation.is_playing():
			kostka.rotation = belt2start.rotation
			kostka.global_position = belt2start.global_position
			robot1Animation.play("left_swing return")
			stage = 4
	elif (stage == 4):	
		if round(kostka.global_position) != round(belt2koniec.global_position):
			kostka.translate(Vector3(0, 0, -defaultSpeed*delta))
		else:
			maszynaKolorReady = false
			animacjaKolorujaca.play("mlot_dol")
			stage = 5
	elif (stage == 5):
		if !animacjaKolorujaca.is_playing() and maszynaKolorReady == false:
				animacjaKolorujaca.play("mlot_gora")
				maszynaKolorReady = true
				kostkaKolorowa.global_position = belt3start.global_position
				kostka.position = belt3start.global_position - Vector3(0,20,0)
		if !animacjaKolorujaca.is_playing():
			stage = 6
	elif (stage == 6):
		if round(kostkaKolorowa.global_position) != round(belt3koniec.global_position):
			kostkaKolorowa.translate(Vector3(0.2* defaultSpeed*delta, 0, 0))
		else:
			anim2Robot2.play("180_rotation_get 1-2")
			stage = 7
	elif (stage == 7):
		if !anim2Robot2.is_playing():
			anim2Robot2.play("180_rotation_get 2-2")
			stage = 8
	elif (stage == 8):
		kostkaKolorowa.position = robot2GrabPart.global_position - Vector3(0.1, 0, 0)
		kostkaKolorowa.rotation = robot2RotationPart.global_rotation - Vector3(0,deg_to_rad(180),-deg_to_rad(90))
		if !anim2Robot2.is_playing():
			stage = 9
	elif (stage == 9):
		kostkaKolorowa.global_position = belt4start.global_position
		kostkaKolorowa.rotation = belt4start.global_rotation - Vector3(0,deg_to_rad(180),0)
		if !anim2Robot2.is_playing():
			anim2Robot2.play("180_rotation return")
			stage = 10
	elif (stage == 10):
		if round(kostkaKolorowa.global_position) != round(belt4koniec.global_position):
			kostkaKolorowa.translate(Vector3(-0.2* defaultSpeed*delta, 0, 0))
		else:
			animYaskawa.play("get 1-2")
			stage = 11
	elif (stage == 11):
		if !animYaskawa.is_playing():
			animYaskawa.play("get 2-2")
			stage = 12
	elif (stage == 12):
		kostkaKolorowa.position = yaskawaGrabPart.global_position - Vector3(0, 0.19, 0)
		kostkaKolorowa.rotation = yaskawaRotationPart.global_rotation
		if !animYaskawa.is_playing():
			animYaskawa.play("return")
			kostkaKolorowa.position = belt5start.global_position
			stage = 13
	elif (stage == 13):
		if round(kostkaKolorowa.global_position) != round(belt5koniec.global_position):
			kostkaKolorowa.translate(Vector3(0, 0, -0.2* defaultSpeed*delta))
		else:
			kostkaKolorowa.translate(Vector3(0, -20, 0))
			kostkaKolorowa.rotation = belt2start.rotation
			stage = 14
	elif (stage == 14):
		_ready()
		stage = 0
		
