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