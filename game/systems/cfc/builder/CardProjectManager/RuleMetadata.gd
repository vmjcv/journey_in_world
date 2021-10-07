extends CardProjectMetadata
class_name RuleMetadata
# 规则卡牌：
# 示例：
# - 场景移动卡直接消耗：如果在大地图移动中，则会直接消耗移动卡
# - 视野控制：玩家只能得到两格内的视野范围

# 规则卡应包含根据信号触发的卡牌和特殊卡牌

var signal_name_array # 游戏的该脚本的触发时机
var custom_script # 调用的脚本名字，会调用相应脚本的触发协议，例如是MAP_OPERATE_END信号触发的，则会调用map_operate_end_main方法
const SIGNAL_NAME_ARRAY := "signal_name_array"
const CUSTOM_SCRIPT := "custom_script"

const definition_path := "res://systems/cfc/cards/rule/definition/"
const script_path := "res://systems/cfc/cards/rule/script/"

func _init(meta_data).(meta_data):
	apply_from_dict(meta_data)

# -------------------------------------------------------------------------------------------------
func make_definition_dict() -> Dictionary:
	return Utils.merge_dict(.make_definition_dict(),{
	})

func make_script_dict() -> Dictionary:
	return Utils.merge_dict(.make_script_dict(),{
		SIGNAL_NAME_ARRAY: signal_name_array,
		CUSTOM_SCRIPT: custom_script,
	})

# -------------------------------------------------------------------------------------------------
func apply_from_dict(meta_data: Dictionary) -> void:
	.apply_from_dict(meta_data)
	signal_name_array = meta_data[SIGNAL_NAME_ARRAY]
	custom_script = meta_data[CUSTOM_SCRIPT]


func clear():
	.clear()
	signal_name_array = null
	custom_script = null
