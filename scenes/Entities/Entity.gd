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

export var human_velocity_advantage = 2.25
export var speed_fudge_factor = 1.0 # apply to every type of conveyance for every mech

var Damage_Types = Global.damage_types
# TODO: Should sync these up with Global.damage_types


enum States { INITIALIZING, READY, DYING, DEAD }
var State = States.INITIALIZING


var input_controller
export var is_human_player : bool = false
export var team : int = -1 setget set_team, get_team
var targetting_cursor


# Not sure what to do with these yet.
# Each mech will have plugins for a variety of functions
# could be slots, hardpoints, or whatever
# nodes that have their own functionality

#export var primary_weapon : NodePath 
#export var alternate_weapon : NodePath 

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
		$Debug,
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

func set_team(newTeam):
	team = newTeam

func get_team():
	return team
	

func scene_finished():
	if Global.current_scene.State == Global.current_scene.States.FINISHED:
		return true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if scene_finished():
		return
	
	if State == States.READY:
		move(delta)
	
func move(delta):
	# locomotion parts need to provide the actual velocity
	# they'll check with input_controller directly
	
	# multiple sets of legs should give diminishing returns, using the "Harmonic Series"
	if has_node("Locomotion"):
		var childNum = 1
		var velocity_multiplier = 0.0
		var velocity = Vector2.ZERO
		for child in $Locomotion.get_children():
			if child.has_method("get_velocity"):
				velocity += child.get_velocity(delta)
				velocity_multiplier += 1/childNum
				childNum += 1
		velocity = velocity / childNum  # normalize velocity
		velocity *= velocity_multiplier # add diminishing returns multiplier
		#warning-ignore:RETURN_VALUE_DISCARDED
		
		
		# fudge factor for humans?
		if is_human_player:
			velocity *= human_velocity_advantage
		velocity *= speed_fudge_factor # exposed in inspector for game tuning
		
		move_and_slide(velocity)


func begin_dying():
	State = States.DYING
	$CollisionShape2D.set_deferred("disabled", true)
	
	var animation_player = $DefaultAnimationPlayer
	if has_node("AnimationPlayer") and $AnimationPlayer.has_animation("die"):
		animation_player = get_node("AnimationPlayer")
	animation_player.play("die")
	$Health/DeathTimer.start()
		


func die_for_real_this_time():
	if has_node("Health/DecayTimer"):
		$Health/DecayTimer.start()

func disappear():
	queue_free()


func knockback(damage, impactVector, damageType):
	var types = Global.damage_types
	var knockback_modifiers = {
		types.IMPACT:5.0,
		types.LASER:0.2,
		types.FIRE:0.3,
		types.SHOCK:1.0,
	}
	var damageKnockback = damage * knockback_modifiers[damageType]
	var knockbackVector = impactVector.normalized() * damageKnockback * (1-knockback_resistance)
	var fudgeFactor = 25.0 # modify this to make knockbacks feel good
	
	#warning-ignore:RETURN_VALUE_DISCARDED
	move_and_slide(knockbackVector * fudgeFactor)
	

func _on_hit(damage, impactVector, damageType):
	if State != States.READY:
		return
	
	# check damage resistance first.
	# then take damage of shields, then armor
	var resist = damage_resistances[damageType]
	damage = max(damage * (1.0-resist), 0.0)
	if damage > 0.0:

		if shield > 0.0:
			print("Shield took " + str(damage))
			shield -= damage
		else:
			knockback(damage, impactVector, damageType)
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




func _on_DeathTimer_timeout():
	_on_finished_dying()
