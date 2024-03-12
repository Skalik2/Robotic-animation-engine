extends SkeletonIK3D
@onready var animYaskawa = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	start()
	animYaskawa.play("standby")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
