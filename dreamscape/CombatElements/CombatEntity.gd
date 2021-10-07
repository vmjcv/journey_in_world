class_name CombatEntity
extends VBoxContainer

const INCOMING_SIGNIFIER_SCENE = preload("res://addons/cfc/src/dreamscape/CombatElements/IncomingSignifier.tscn")

export(StreamTexture) var defence_texture: StreamTexture
export(StreamTexture) var character_art_texture: StreamTexture

signal effect_modified(entity,trigger,details)
signal entity_attacked(entity, amount, trigger, tags)
signal entity_damaged(entity, amount, trigger, tags)
signal entity_healed(entity, amount, trigger, tags)
signal entity_defended(entity, amount, trigger, tags)
signal entity_killed


onready var art := $Art
onready var collision_shape := $Art/Area2D/CollisionShape2D
onready var area2d := $Art/Area2D
onready var entity_texture :=  $Art/Texture
onready var highlight := $Art/Highlight
onready var _health_stats := $HBC
onready var health_label : Label = $HBC/Health
onready var name_label : Label = $Name
onready var defence_icon : TextureRect = $HBC/Defence/Icon
onready var defence_label : Label = $HBC/Defence/Amount
onready var active_effects := $ActiveEffects
onready var incoming := $CenterContainer/Incoming
onready var description_popup := $Description
onready var description_label := $Description/Label


var damage : int setget set_damage
var health : int setget set_health
var defence : int setget set_defence
var canonical_name: String
var type: String
var entity_type: String
var entity_size : Vector2
var character_art: String
var is_dead := false
var shader_progress := 0.0

# Holding all the details from the CombatEntity, in case
# we need to retrieve some extra ones, depending on the type
var _properties : Dictionary

# Typically used during
# an [execute_scripts()](ScriptingEngine#execute_scripts] task.
var temp_properties_modifiers := {}

func setup(entity_name: String, properties: Dictionary) -> void:
	canonical_name = entity_name
	name = entity_name
	health = properties['Health']
	type = properties['Type']
	damage = properties.get('Damage', 0)
	_properties = properties
	entity_size = Vector2(properties['_texture_size_x'],properties['_texture_size_y'])
	character_art = properties.get('_character_art', 'nobody')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	art.rect_min_size = entity_size
	collision_shape.shape.extents = entity_size / 2
	area2d.position = entity_size / 2
	name_label.text = canonical_name
	_update_health_label()
	active_effects.combat_entity = self
	highlight.rect_min_size = entity_size + Vector2(1,1)
	highlight.entity_art = entity_texture
	var turn: Turn = cfc.NMAP.board.turn
	for turn_signal in Turn.ALL_SIGNALS:
		# warning-ignore:return_value_discarded
		turn.connect(turn_signal, self, "_on_" + turn_signal)
	_set_texture(defence_icon, defence_texture)
	if _properties.has('_texture'):
		_set_texture(entity_texture, _properties["_texture"])
	elif character_art_texture:
		_set_texture(entity_texture, character_art_texture)

func _set_texture(node: Node, stream: StreamTexture) -> void:
		var new_texture = ImageTexture.new()
		new_texture.storage = ImageTexture.STORAGE_COMPRESS_LOSSLESS
		var _image = stream.get_data()
		new_texture.create_from_image(_image)
		node.texture = new_texture

func _process(delta: float) -> void:
	if is_dead and entity_texture.material as ShaderMaterial:
		shader_progress += delta
		entity_texture.material.set_shader_param(
				'progress', shader_progress)
		for node in [name_label, _health_stats, active_effects, incoming]:
			if node.modulate.a > 0:
				node.modulate.a = 0
		if shader_progress > 0.9:
			queue_free()

func set_defence(value) -> void:
	defence = value
	_update_health_label()

func set_damage(value) -> void:
	damage = value
	if damage >= health:
		die()
	else:
		_update_health_label()

func set_health(value) -> void:
	health = value
	_update_health_label()


func die() -> void:
	is_dead = true
	emit_signal("entity_killed")
	entity_texture.material = ShaderMaterial.new()
	entity_texture.material.shader = CFConst.REMOVE_FROM_GAME_SHADER


func modify_damage(amount: int, dry_run := false, tags := ["Manual"], trigger = null) -> int:
	if not dry_run:
		if amount > 0 and "Attack" in tags:
			emit_signal("entity_attacked", self, amount, trigger, tags)
		elif amount < 0:
			emit_signal("entity_healed", self, amount, trigger, tags)
		if defence > 0 and ("Attack" in tags or "Blockable" in tags):
			if amount >= defence:
				amount -= defence
				defence = 0
			else:
				defence -= amount
				amount = 0
		damage += amount
		if amount > 0:
			emit_signal("entity_damaged", self, amount, trigger, tags)
		if damage < 0:
			damage = 0
		if damage >= health:
			die()
		_update_health_label()
	return(CFConst.ReturnCode.CHANGED)

func receive_defence(amount: int, dry_run := false, tags := ["Manual"], trigger: CombatEntity = null) -> int:
	if not dry_run:
		if amount > 0:
			emit_signal("entity_defended", self, amount, trigger, tags)
		defence += amount
		_update_health_label()
	return(CFConst.ReturnCode.CHANGED)

func get_class() -> String:
	return("CombatEntity")

func show_predictions(value: int) -> void:
	var incoming_node = INCOMING_SIGNIFIER_SCENE.instance()
	incoming.add_child(incoming_node)
	incoming_node.get_node("Label").text = str(value)

func clear_predictions() -> void:
	for node in incoming.get_children():
		node.queue_free()

# The entities do not have starting health which decreases as they take damage
# Rather they have a damage meter which increases until it hits their max health.
func _update_health_label() -> void:
	health_label.text = str(damage) + '/' + str(health)
	defence_label.text = str(defence)

func get_property(property_name: String):
	return(_properties.get(property_name))

func _on_Defence_mouse_entered() -> void:
	var description_text := "{defence_name}: It is removed before {health} is accumulated."\
			+ "\nIt is removed at the start of the {entity}'s turn"
	_show_description_popup(description_text, defence_label)

func _on_Health_mouse_entered() -> void:
	var description_text := "{health} (accumulated/total): {damage_taken_verb}"\
			+ " from {enemy} {opponent_actions}."
	_show_description_popup(description_text, health_label)

func _show_description_popup(description_text: String, popup_anchor: Node) -> void:
	var format = Terms.COMMON_FORMATS[entity_type].duplicate()
	description_label.bbcode_text = description_text.format(format).format(Terms.get_bbcode_formats(18))
	description_popup.visible = true
	description_popup.rect_size = Vector2(0,0)
	description_popup.rect_global_position = popup_anchor.rect_global_position + Vector2(20,-description_label.rect_size.y)


func _on_CombatSingifier_mouse_exited() -> void:
	description_popup.visible = false


func _on_Description_mouse_exited() -> void:
	description_popup.visible = false


func _on_Art_mouse_exited() -> void:
	description_popup.visible = false


func _on_Art_mouse_entered() -> void:
	var art_text := "Character art by: " + character_art
	_show_description_popup(art_text, art)


func _on_player_turn_started(_turn: Turn) -> void:
	if entity_type == Terms.PLAYER:
		var fortify = active_effects.get_effect(Terms.ACTIVE_EFFECTS.fortify.name)
		if fortify:
			fortify.stacks -= 1
		else:
			set_defence(0)


func _on_player_turn_ended(_turn: Turn) -> void:
	pass


func _on_enemy_turn_started(_turn: Turn) -> void:
	if entity_type == Terms.ENEMY:
		var fortify = active_effects.get_effect(Terms.ACTIVE_EFFECTS.fortify.name)
		if fortify:
			fortify.stacks -= 1
		else:
			set_defence(0)


func _on_enemy_turn_ended(_turn: Turn) -> void:
	pass
