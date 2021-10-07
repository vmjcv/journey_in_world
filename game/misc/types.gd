extends Node


enum ColorBlindnessMode {
	DEFAULT,
	GREEN,
}

enum GameLanguage {
	EN,
	ZH,
}

enum UserInterfaceSize {
	DEFAULT,
	BIG,
}

enum GameSpeed {
	DEFAULT,
	SMALL,
	MIDDLE,
	BIG,
}

enum Resolution {
	SMALL,
	DEFAULT,
	MIDDLE,
	BIG,
	BIG_BIG,
}
enum DisplayMode {
	BORDER,
	FULLSCREEN,
	BORDERLESS,
}

enum CardPreview {
	SCALING,
	VIEWPORT,
	SCALING_VIEWPORT,
}

# 战斗内快捷键
var Actions:Array = ["Card1", "Card2", "Card3", "Card4", "Card5","ToggleGameSpeed","UseCard",
"CancelUseCard","Setting","Left","Right","Up","Down","ShowCards","ShowDrawCards",
"ShowDiscardCards","ShowShortcutKey","ShowMap"]


# 因为可能存在删除状态的情况存在，所以直接使用名字来作为键，先只添加要用的游戏状态
var game_status = {
	"MAP_OPERATE_END":"MAP_OPERATE_END",# 地图操作结束，用于移动卡消耗
	"GAME_START":"GAME_START",# 游戏开始后调用，用于触发视野控制的设置代码
}
