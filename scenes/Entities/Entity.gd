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

export var iframes_time : float = 0.25
export var human_iframes_multiplier : float = 3.0

export var human_velocity_advantage = 2.25
export var speed_fudge_factor = 1.0 # apply to every type of conveyance for every mech

var Damage_Types = Global.damage_types
# TODO: Should sync these up with Global.damage_types


enum States { INITIALIZING, READY, PAUSED, INVULNERABLE, FLYING, DYING, DEAD }
var State = States.INITIALIZING setget set_state, get_state

# prevent returning to ready afer dying and becoming invulnerable.
var PreviousStates = [] # push/pop states so we can come back to them after yields and timer signals


var input_controller
export var is_human_player : bool = false
export var team : int = -1 setget set_team, get_team
var targetting_cursor

var previous_velocity : Vector2 = Vector2.ZERO
var knockback_vector : Vector2 = Vector2.ZERO

var moving_last_frame : bool = false

# Not sure what to do with these yet.
# Each mech will have plugins for a variety of functions
# could be slots, hardpoints, or whatever
# nodes that have their own functionality

#export var primary_weapon : NodePath 
#export var alternate_weapon : NodePath 

export var engine : NodePath
export var legs : NodePath
export var head : NodePath

var shield_parts = [] # list of parts that should light up (blue) when shields take damage


# resistance is float: 0 to 1.
# applied to damage as (1-resistance) * damage
export var damage_resistances : Dictionary = {
	Damage_Types.IMPACT:0.0,
	Damage_Types.LASER:0.0,
	Damage_Types.FIRE:0.0,
	Damage_Types.SHOCK:0.0,
}

onready var systems = [
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

var ticks : int = 0



signal started_walking
signal stopped_walking
signal died


# Called when the node enters the scene tree for the first time.
func _ready():



	custom_ready() # must happen before systems are initialized, if you expect custom addon subsystems to be included
	
	for system in systems:
		for subsystem in system.get_children():
			if subsystem.has_method("init"):
				subsystem.init(self) # tell each module who the owner is.
			if subsystem.has_method("_on_started_walking"):
				#warning-ignore:RETURN_VALUE_DISCARDED
				connect("started_walking", subsystem, "_on_started_walking")
			if subsystem.has_method("_on_stopped_walking"):
				#warning-ignore:RETURN_VALUE_DISCARDED
				connect("stopped_walking", subsystem, "_on_stopped_walking")
			if subsystem.has_method("_on_mech_died"):
				#warning-ignore:RETURN_VALUE_DISCARDED
				connect("died", subsystem, "_on_mech_died")
	

	set_state(States.READY)
	
	setup_iframes()

func setup_iframes():
	if self.is_human_player:
		iframes_time *= human_iframes_multiplier
	$Defences/iframesTimer.set_wait_time(iframes_time)

func trigger_iframes(flashColor):
	$Defences/iframesTimer.start()
	set_state(States.INVULNERABLE)

	# this should be a shader. who wants to write a shader?
	self.set_modulate(flashColor)
	

	
func custom_ready():
	#override this in descendants
	pass

func set_state(newState):
	PreviousStates.push_back(State)
	State = newState
	
func get_state():
	return State
	
func resume_previous_state():
	State = PreviousStates.pop_back()


func set_team(newTeam):
	team = newTeam

func get_team():
	return team
	
func get_velocity():
	return previous_velocity

func scene_finished():
	if Global.current_scene.State == Global.current_scene.States.FINISHED:
		return true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if scene_finished():
		return
	
	if State in [ States.READY, States.INVULNERABLE]:
		move(delta)
	
func move(delta):
	if get_state() == States.DYING:
		if !self.is_human_player:
			#warning-ignore:RETURN_VALUE_DISCARDED
			move_and_slide(knockback_vector)
			return
		else:
			return
	
	# locomotion parts need to provide the actual velocity
	# they'll check with input_controller directly
	
	# Here we're using Invulnerable as a surrogate marker for "just got hit", hence requires knockback.
	# It would be preferable to have a knockback flag or a knockback state.
	if !self.is_human_player and get_state() == States.INVULNERABLE:
		#warning-ignore:RETURN_VALUE_DISCARDED
		move_and_slide(knockback_vector)
	
	# multiple sets of legs should give diminishing returns, using the "Harmonic Series"
	if has_node("Locomotion"):
		var activeLocomotionPartsCounted = 1
		var velocity_multiplier = 0.0
		var velocity = Vector2.ZERO
		for child in $Locomotion.get_children():
			if child.has_method("get_velocity"):
				velocity += child.get_velocity(delta)
				velocity_multiplier += 1/activeLocomotionPartsCounted # harmonic series diminishing returns
				activeLocomotionPartsCounted += 1
		velocity = velocity / activeLocomotionPartsCounted  # normalize velocity
		velocity *= velocity_multiplier # add diminishing returns multiplier

		# fudge factor for humans?
		if is_human_player:
			velocity *= human_velocity_advantage
		velocity *= speed_fudge_factor # exposed in inspector for game tuning
		change_walking_animation_if_required(velocity)
		previous_velocity = velocity

		#warning-ignore:RETURN_VALUE_DISCARDED
		move_and_slide(velocity)


func change_walking_animation_if_required(velocity):
	var moving_this_frame = input_controller.is_any_movement_key_pressed()
	if moving_last_frame != moving_this_frame:
		if moving_this_frame:
			emit_signal("started_walking", velocity)
		else:
			emit_signal("stopped_walking", velocity)
	moving_last_frame = moving_this_frame
	
# was slow to stop moving. maybe number needed to be higher
#	if previous_velocity.length_squared() < 1000.0 and velocity.length_squared() > 1000.0:
#		emit_signal("started_walking", velocity)
#	elif previous_velocity.length_squared() > 1000.0 and velocity.length_squared() < 1000.0:
#		emit_signal("stopped_walking", velocity)


	

func begin_dying():
	for system in systems:
		for subsystem in system.get_children():
			if subsystem is MechPart:
				subsystem.disabled = true
	set_state(States.DYING)
	$CollisionShape2D.set_deferred("disabled", true)
	
	var animation_player = $DefaultAnimationPlayer
	if has_node("AnimationPlayer") and $AnimationPlayer.has_animation("die"):
		animation_player = get_node("AnimationPlayer")
	animation_player.play("die")
	$Health/DeathTimer.start()
	$DeathNoise.play()
	if Global.user_prefs["particles"]:
		$ShrapnelParticles.emitting = true
		$SmokeParticles.emitting = true
	emit_signal("died")
		


func die_for_real_this_time():
	if has_node("Health/DecayTimer"):
		$Health/DecayTimer.start()

func disappear():
	queue_free()


func spawn_shrapnel(impactVector):
	if has_node("ShrapnelParticles"):
		if Global.user_prefs["particles"]:
			$ShrapnelParticles.direction = impactVector
			$ShrapnelParticles.emitting = true

func spawn_smoke(_impactVector):
	if has_node("SmokeParticles"):
		if Global.user_prefs["particles"]:
			$SmokeParticles.emitting = true

func knockback(damage, impactVector, damageType):
	var types = Global.damage_types
	var knockback_modifiers = {
		types.IMPACT:5.0,
		types.LASER:0.2,
		types.FIRE:0.3,
		types.SHOCK:1.0,
	}
	var damageKnockback = damage * knockback_modifiers[damageType]
	#var knockbackVector = impactVector.normalized() * damageKnockback * (1-knockback_resistance)
	var knockbackVector = impactVector * damageKnockback * (1-knockback_resistance)

	var fudgeFactor = 1.0 # modify this to make knockbacks feel good
	
	#warning-ignore:RETURN_VALUE_DISCARDED
	knockback_vector = knockbackVector * fudgeFactor
	move_and_slide(knockback_vector)
	

func _on_hit(damage, impactVector, damageType):
	if not Global.current_scene.is_active():
		# prevent hits after fight is won
		return
		
	if State != States.READY: #INVULNERABLE Can't be hurt
		return
	
	# /begin haiku
	# in a perfect world with unlimited time, 
	# we'd check each subsystem in defenses node,
	# to let them soak damage first.
	# sadly, we don't have unlimited time.
	# so all damage comes to Entity
	# /end haiku
	
	# check damage resistance first.
	# then take damage of shields, then armor
	var resist = damage_resistances[damageType]
	damage = max(damage * (1.0-resist), 0.0)
	if damage > 0.0:
		if shield > 0.0:
			var remainingDamage = damage - shield
			shield = max(shield - damage, 0)
			if remainingDamage > 0:
				_on_hit(remainingDamage, impactVector, damageType)
			else: # shield took all the damage
				for currentShield in shield_parts:
					if currentShield.has_method("flash"):
						currentShield.flash(impactVector)
				trigger_iframes(Color.aqua)


		else:
			if damageType == Global.damage_types.IMPACT:
				spawn_shrapnel(impactVector)
			elif damageType in [ Global.damage_types.LASER, Global.damage_types.FIRE ]:
				spawn_smoke(impactVector)
			knockback(damage, impactVector, damageType)
			health = max(health - damage, 0.0)
			update_health_bar()
		
			if health <= 0.0:
				begin_dying()
			else:
				trigger_iframes(Color.red)
	
func update_health_bar():
	if $Health.has_node("TextureProgress"):
		$Health/TextureProgress.value = health/health_max


func simplify_all_textures(currentNode):

	var squareTexture = ImageTexture.new()
	var image = Image.new()
	image.load("res://_common/Materials/SmallWhiteSquare.png")
	squareTexture.create_from_image(image)

	for child in currentNode.get_children():
			if child.is_class("Sprite"):
				child.set_texture(squareTexture)
			# recursion danger
			simplify_all_textures(child)

func _on_finished_dying():
	die_for_real_this_time()
	


func _on_DecayTimer_timeout():
	disappear()




func _on_DeathTimer_timeout():
	_on_finished_dying()


func _on_iframesTimer_timeout():
	if get_state() != States.DYING:
		resume_previous_state()
	set_modulate(Color.white)



func _on_debug_mode_requested():
	simplify_all_textures(self)
	
	
	
