"""
Base class can be used as inherited scene
for player or enemy mechs.

Add child nodes to Appearance, Engine, Locomotion, etc.


"""

extends KinematicBody2D


export var health_max : float = 1000.0
var health : float = health_max

export var armor_max : float = 0.0
var armor : float = armor_max

export var knockback_resistance : float = 0.0 # 1.0 == no knockback from impacts


export var shield_max : float = 0.0
var shield : float = shield_max

var Damage_Types = Global.damage_types
# TODO: Should sync these up with Global.damage_types


enum States { INITIALIZING, READY, DYING, DEAD }
var State = States.INITIALIZING


var input_controller
export var is_human_player : bool = false


# Not sure what to do with these yet.
# Each mech will have plugins for a variety of functions
# could be slots, hardpoints, or whatever
# nodes that have their own functionality
export var primary_weapon : NodePath 
export var alternate_weapon : NodePath 
export var engine : NodePath
export var legs : NodePath
export var head : NodePath

# resistance is float: 0 to 1.
# applied to damage as (1-resistance) * damage
export var damage_resistances : Dictionary = {
	Damage_Types.IMPACT:0.0,
	Damage_Types.LASER:0.0,
	Damage_Types.FIRE:0.0,
	Damage_Types.SHOCK:0.0,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var systems = [
		$Engine,
		$Locomotion,
		$HeatSink,
		$Weapons,
		$Defences,
		$Health,
		$Summons,
		$Input,
		$TargetAcquisitionSensors,
	]

	for system in systems:
		for subsystem in system.get_children():
			if subsystem.has_method("init"):
				subsystem.init(self) # tell each module who the owner is.

	custom_ready()
	State = States.READY
	

func custom_ready():
	#override this in descendants
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if has_node("Locomotion"):
		var childNum = 1
		var velocity_multiplier = 1.0
		var velocity = Vector2.ZERO
		for child in $Locomotion.get_children():
			if child.has_method("get_velocity"):
				velocity += child.get_velocity(delta)
				velocity_multiplier += 1/childNum
				childNum += 1
		velocity = velocity / childNum  # normalize velocity
		velocity *= velocity_multiplier # add diminishing returns multiplier
		#warning-ignore:RETURN_VALUE_DISCARDED
		move_and_slide(velocity)


func begin_dying():
	State = States.DYING
	$CollisionShape2D.set_deferred("disabled", true)
	if has_node("AnimationPlayer") and $AnimationPlayer.has_animation("die"):
		#warning-ignore:RETURN_VALUE_DISCARDED
		$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
		$AnimationPlayer.play("die")
		$Health/DeathTimer.start()
		


func die_for_real_this_time():
	if has_node("Health/DecayTimer"):
		$Health/DecayTimer.start()

func disappear():
	queue_free()


func knockback(damage, impactVector):
	var knockbackVector = impactVector.normalized() * damage * knockback_resistance
	var fudgeFactor = 1.0 # modify this to make knockbacks feel good
	
	#warning-ignore:RETURN_VALUE_DISCARDED
	move_and_collide(knockbackVector * fudgeFactor)
	

func _on_hit(damage, impactVector, damageType):
	if State != States.READY:
		return
	
	# check damage resistance first.
	# then take damage of shields, then armor
	var resist = damage_resistances[damageType]
	damage = max(damage * (1.0-resist), 0.0)
	if damage > 0.0:
		
		knockback(damage, impactVector)
		health = max(health - damage, 0.0)
		update_health_bar()
	
		if health <= 0.0:
			begin_dying()
	
func update_health_bar():
	if $Health.has_node("TextureProgress"):
		$Health/TextureProgress.value = health/health_max


func _on_finished_dying():
	die_for_real_this_time()
	


func _on_DecayTimer_timeout():
	disappear()

func _on_animation_finished(_anim_name):
	pass
#	if anim_name == "die":
#		_on_finished_dying()


func _on_DeathTimer_timeout():
	_on_finished_dying()
