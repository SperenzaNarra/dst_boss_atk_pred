local STRINGS = {
	{
		en = "Boss Attack Predictor",
		zh = "Boss预测器",
	},
	{
		en = "Predict boss attack/respown with displayed timer in a widget.\nAlso will display the time of Ruins Regeneration and Ancient Gateway Cooldown\n\nHas same features as Hound Attack Predictor, and additionally also predicts Rift cycles\n\nDon't Starve Together only",
		zh = "本插件功能是将DST纯净Boss会出现的时间显示在左上角的贴图上，或者任何你想放的角落\n有猎犬预测器的功能，并且有侦测裂隙循环的功能，能够自由开关闭其中的组件\n\n饥荒联机版专属",
	},
	{
		en = "Show Name",
		zh = "显示名称",
	},
	{
		en = "The predictor will show the name of warnings",
		zh = "预测器将显示威胁的名称",
	},
	{
		en = "Enabled",
		zh = "开启",
	},
	{
		en = "Disabled",
		zh = "关闭",
	},
	{
		en = "Priority type",
		zh = "优先策略",
	},
	{
		en = "Choose the priority of warnings",
		zh = "选择优先类型",
	},
	{
		en = "Earliest",
		zh = "时间优先",
	},
	{
		en = "Prioritize the earliest event",
		zh = "优先最先会发生的威胁",
	},
	{
		en = "Attack",
		zh = "袭击优先",
		disamb = "priority"
	},
	{
		en = "Prioritize Antlion, Bearger, and Deerclops",
		zh = "会优先狮蚁，熊獾，和独眼巨鹿",
	},
	{
		en = "Spawn",
		zh = "生成优先",
		disamb = "priority"
	},
	{
		en = "Prioritize Crabking, Dragonfly, Klaus, Malbatross, and Toadstool",
		zh = "会优先帝王蟹，龙蝇，克劳斯，邪天翁，和蟾蜍王",
	},
	{
		en = "Hound",
		zh = "猎犬",
	},
	{
		en = "Display Hound Widget",
		zh = "显示侦测猎犬组件",
	},
	{
		en = "Display Boss Widget",
		zh = "显示侦测Boss组件",
	},
	{
		en = "Rift",
		zh = "裂隙循环",
	},
	{
		en = "Display Rift Widget",
		zh = "显示侦测裂隙循环组件",
	},
	{
		en = "Widget Setting",
		zh = "组件设置",
	},
	{
		en = "Font Size",
		zh = "字体大小",
	},
	{
		en = "Padding",
		zh = "组件间距",
	},
	{
		en = "Distance Between Widgets",
		zh = "组件之间的距离",
	},
	{
		en = "X Pos",
		zh = "X 坐标",
	},
	{
		en = "Y Pos",
		zh = "Y 坐标",
	},
	{
		en = "Align",
		zh = "对齐",
	},
	{
		en = "Top Left",
		zh = "左上",
	},
	{
		en = "Top Right",
		zh = "右上",
	},
	{
		en = "Bottom Left",
		zh = "左下",
	},
	{
		en = "Bottom Right",
		zh = "右下",
	},
	{
		en = "Width",
		zh = "宽",
	},
	{
		en = "Height",
		zh = "高",
	},
	{
		en = "Antlion",
		zh = "狮蚁",
	},
	{
		en = "Attack",
		zh = "袭击",
		disamb = "title"
	},
	{
		en = "Display Antlion Rage Attack",
		zh = "显示狮蚁袭击时间",
	},
	{
		en = "Bearger",
		zh = "熊獾",
	},
	{
		en = "Display Bearger Attack Time",
		zh = "显示熊獾袭击时间",
	},
	{
		en = "Deerclops",
		zh = "独眼巨鹿",
	},
	{
		en = "Display Deerclops Attack Time",
		zh = "显示独眼巨鹿袭击时间",
	},
	{
		en = "Spawn",
		zh = "生成",
		disamb = "title"
	},
	{
		en = "Bee Queen",
		zh = "蜂后",
	},
	{
		en = "Display Bee Queen Hive Spawn Time",
		zh = "显示蜂后蜂巢生成时间",
	},
	{
		en = "Crab King",
		zh = "帝王蟹",
	},
	{
		en = "Display Crabking Spawn Time",
		zh = "显示帝王蟹生成时间",
	},
	{
		en = "Dragonfly",
		zh = "龙蝇",
	},
	{
		en = "Display Dragonfly Spawn Time",
		zh = "显示龙蝇生成时间",
	},
	{
		en = "Lord of the Fruit Flies",
		zh = "果蝇王",
	},
	{
		en = "Display Lord of the Fruit Flies Spawn Time",
		zh = "显示果蝇王袭击时间",
	},
	{
		en = "Malbatross",
		zh = "邪天翁",
	},
	{
		en = "Display Malbatross Spawn Time",
		zh = "显示邪天翁袭击时间",
	},
	{
		en = "Klaus",
		zh = "克劳斯",
	},
	{
		en = "Display Klaus Loot Stash Spawn Time",
		zh = "显示克劳斯赃物袋生成时间",
	},
	{
		en = "Toadstool",
		zh = "蟾蜍王",
	},
	{
		en = "Display Toadstool Spawn Time",
		zh = "显示蟾蜍王生成时间",
	},
	{
		en = "Nightmare Werepig",
		zh = "梦魇疯猪",
	},
	{
		en = "Display Nightmare Werepig Spawn Time",
		zh = "显示梦魇疯猪生成时间",
	},
	{
		en = "Scrappy Werepig",
		zh = "拾荒疯猪",
	},
	{
		en = "Display Scrappy Werepig Spawn Time",
		zh = "显示拾荒疯猪生成时间",
	},
	{
		en = "Gateway Cooldown",
		zh = "远古大门的冷却",
	},
	{
		en = "Display Ancient Gateway Cooldown Time",
		zh = "显示远古大门的冷却时间",
	},
	{
		en = "Ruins Reset",
		zh = "遗迹的重制",
	},
	{
		en = "Display Ruins Regeneration Time",
		zh = "显示遗迹的重制时间",
	},
}

-- pairs & ipairs are not defined in this context; see ModIndex:InitializeModInfo
local function values(t)
	local i = 0
	return function() i = i + 1; return t[i] end
end

local function t(str, disamb)
	-- See languages/loc.lua for valid language codes
	local fallbacktable = {
		zht="zh",
		zhr="zh",
	}

	if locale == nil or locale == "en" then return str end

	for entry in values(STRINGS) do
		if entry.en == str and entry.disamb == disamb then
			local curlocale = locale

			while curlocale ~= nil do
				if entry[curlocale] ~= nil then
					return entry[curlocale]
				end

				curlocale = fallbacktable[curlocale]
			end

			return str
		end
	end

	return str
end

name = t("Boss Attack Predictor")

description = t("Predict boss attack/respown with displayed timer in a widget.\nAlso will display the time of Ruins Regeneration and Ancient Gateway Cooldown\n\nHas same features as Hound Attack Predictor, and additionally also predicts Rift cycles\n\nDon't Starve Together only")
author = "Sperenza & YiFei Zhu"
version = "2.2.1"

api_version_dst = 10
priority = 0

dont_starve_compatible = false
dst_compatible = true
reign_of_giants_compatible = false
shipwrecked_compatible = false
server_filter_tags = {"boss attack predictor", "bosses", "boss", "attack", "predictor", "timer", "widget"}

all_clients_require_mod = true
client_only_mod = false

icon_atlas = "modicon.xml"
icon = "modicon.tex"

forumthread = ""

local function AddTitle(title)
	return {
		name = "null",
		label = title,
		options = {
				{ description = "", data = 0 }
		},
		default = 0,
	}
end

configuration_options = {
	{
		name = "showname",
		label = t("Show Name"),
		hover = t("The predictor will show the name of warnings"),
		options = {
			{description = t("Enabled"), data = true},
			{description = t("Disabled"), data = false},
		},
		default = false
	},
	{
		name = "prioritytype",
		label = t("Priority type"),
		hover = t("Choose the priority of warnings"),
		options = {
			{
				description = t("Earliest"),
				data = "leasttimefirst",
				hover = t("Prioritize the earliest event"),
			},
			{
				description = t("Attack", "priority"),
				data = "attacktimefirst",
				hover = t("Prioritize Antlion, Bearger, and Deerclops"),
			},
			{
				description = t("Spawn", "priority"),
				data = "spawntimefirst",
				hover = t("Prioritize Crabking, Dragonfly, Klaus, Malbatross, and Toadstool"),
			}
		},
		default = "leasttimefirst"
	},
	{
		name = "houndenable",
		label = t("Hound"),
		hover = t("Display Hound Widget"),
		options = {
			{description = t("Enabled"), data = true},
			{description = t("Disabled"), data = false},
		},
		default = true
	},
	{
		name = "bossenable",
		label = t("Boss"),
		hover = t("Display Boss Widget"),
		options = {
			{description = t("Enabled"), data = true},
			{description = t("Disabled"), data = false},
		},
		default = true
	},
	{
		name = "riftenable",
		label = t("Rift"),
		hover = t("Display Rift Widget"),
		options = {
			{description = t("Enabled"), data = true},
			{description = t("Disabled"), data = false},
		},
		default = true
	},
	AddTitle(t("Widget Setting")),
	{
		name = "fontsize",
		label = t("Font Size"),
		options = {
			{description = "10", data=10},
			{description = "11", data=11},
			{description = "12", data=12},
			{description = "13", data=13},
			{description = "14", data=14},
			{description = "15", data=15},
			{description = "16", data=16},
			{description = "17", data=17},
			{description = "18", data=18},
			{description = "19", data=19},
			{description = "20", data=20},
		},
		default = 17
	},
	{
		name = "widgetpadding",
		label = t("Padding"),
		hover = t("Distance Between Widgets"),
		options = {
			{description = "0",   data=0},
			{description = "10",  data=10},
			{description = "20",  data=20},
			{description = "30",  data=30},
			{description = "40",  data=40},
			{description = "50",  data=50},
			{description = "60",  data=60},
			{description = "70",  data=70},
			{description = "80",  data=80},
			{description = "90",  data=90},
			{description = "100", data=100},
		},
		default = 30
	},
	{
		name = "widget_xPos",
		label = t("X Pos"),
		options = {
			{description = "0",   data=0},
			{description = "10",  data=10},
			{description = "20",  data=20},
			{description = "30",  data=30},
			{description = "40",  data=40},
			{description = "50",  data=50},
			{description = "60",  data=60},
			{description = "70",  data=70},
			{description = "80",  data=80},
			{description = "90",  data=90},
			{description = "100", data=100},
			{description = "110", data=110},
			{description = "120", data=120},
			{description = "130", data=130},
			{description = "140", data=140},
			{description = "150", data=150},
			{description = "160", data=160},
			{description = "170", data=170},
			{description = "180", data=180},
			{description = "190", data=190},
			{description = "200", data=200},
			{description = "210", data=210},
			{description = "220", data=220},
			{description = "230", data=230},
			{description = "240", data=240},
			{description = "250", data=250},
			{description = "260", data=260},
			{description = "270", data=270},
			{description = "280", data=280},
			{description = "290", data=290},
		},
		default = 100
	},
	{
		name = "widget_yPos",
		label = t("Y Pos"),
		options = {
			{description = "0",   data=0},
			{description = "10",  data=10},
			{description = "20",  data=20},
			{description = "30",  data=30},
			{description = "40",  data=40},
			{description = "50",  data=50},
			{description = "60",  data=60},
			{description = "70",  data=70},
			{description = "80",  data=80},
			{description = "90",  data=90},
			{description = "100", data=100},
			{description = "110", data=110},
			{description = "120", data=120},
			{description = "130", data=130},
			{description = "140", data=140},
			{description = "150", data=150},
			{description = "160", data=160},
			{description = "170", data=170},
			{description = "180", data=180},
			{description = "190", data=190},
			{description = "200", data=200},
			{description = "210", data=210},
			{description = "220", data=220},
			{description = "230", data=230},
			{description = "240", data=240},
			{description = "250", data=250},
			{description = "260", data=260},
			{description = "270", data=270},
			{description = "280", data=280},
			{description = "290", data=290},
		},
		default = 100
	},
	{
		name = "widgetalign",
		label = t("Align"),
		options = {
			{description = t("Top Left"), data = "lefttop"},
			{description = t("Top Right"), data = "righttop"},
			{description = t("Bottom Left"), data = "leftbottom"},
			{description = t("Bottom Right"), data = "rightbottom"},
		},
		default = "lefttop"
	},
	{
		name = "widgetwidth",
		label = t("Width"),
		options = {
			{description = "40", data=40},
			{description = "50", data=50},
			{description = "60", data=60},
			{description = "70", data=70},
			{description = "80", data=80},
			{description = "90", data=90},
			{description = "100", data=100},
			{description = "110", data=110},
			{description = "120", data=120},
		},
		default = 80
	},
	{
		name = "widgetheight",
		label = t("Height"),
		options = {
			{description = "40", data=40},
			{description = "50", data=50},
			{description = "60", data=60},
			{description = "70", data=70},
			{description = "80", data=80},
			{description = "90", data=90},
			{description = "100", data=100},
			{description = "110", data=110},
			{description = "120", data=120},
		},
		default = 80
	},
	AddTitle(t("Attack", "title")),
	{
		name = "antlion",
		label = t("Antlion"),
		hover = t("Display Antlion Rage Attack"),
		options = {
			{description = t("Enabled"), data = true},
			{description = t("Disabled"), data = false},
		},
		default = true
	},
	{
		name = "bearger",
		label = t("Bearger"),
		hover = t("Display Bearger Attack Time"),
		options = {
			{description = t("Enabled"), data = true},
			{description = t("Disabled"), data = false},
		},
		default = true
	},
	{
		name = "deerclops",
		label = t("Deerclops"),
		hover = t("Display Deerclops Attack Time"),
		options = {
			{description = t("Enabled"), data = true},
			{description = t("Disabled"), data = false},
		},
		default = true
	},
	AddTitle(t("Spawn", "title")),
	{
		name = "beequeenhive",
		label = t("Bee Queen"),
		hover = t("Display Bee Queen Hive Spawn Time"),
		options = {
			{description = t("Enabled"), data = true},
			{description = t("Disabled"), data = false},
		},
		default = true
	},
	{
		name = "crabking_spawner",
		label = t("Crab King"),
		hover = t("Display Crabking Spawn Time"),
		options = {
			{description = t("Enabled"), data = true},
			{description = t("Disabled"), data = false},
		},
		default = true
	},
	{
		name = "dragonfly_spawner",
		label = t("Dragonfly"),
		hover = t("Display Dragonfly Spawn Time"),
		options = {
			{description = t("Enabled"), data = true},
			{description = t("Disabled"), data = false},
		},
		default = true
	},
	{
		name = "fruitfly",
		label = t("Lord of the Fruit Flies"),
		hover = t("Display Lord of the Fruit Flies Spawn Time"),
		options = {
			{description = t("Enabled"), data = true},
			{description = t("Disabled"), data = false},
		},
		default = false
	},
	{
		name = "malbatross",
		label = t("Malbatross"),
		hover = t("Display Malbatross Spawn Time"),
		options = {
			{description = t("Enabled"), data = true},
			{description = t("Disabled"), data = false},
		},
		default = true
	},
	{
		name = "klaus",
		label = t("Klaus"),
		hover = t("Display Klaus Loot Stash Spawn Time"),
		options = {
			{description = t("Enabled"), data = true},
			{description = t("Disabled"), data = false},
		},
		default = true
	},
	{
		name = "toadstool",
		label = t("Toadstool"),
		hover = t("Display Toadstool Spawn Time"),
		options = {
			{description = t("Enabled"), data = true},
			{description = t("Disabled"), data = false},
		},
		default = true
	},
	{
		name = "nightmare_werepig",
		label = t("Nightmare Werepig"),
		hover = t("Display Nightmare Werepig Spawn Time"),
		options = {
			{description = t("Enabled"), data = true},
			{description = t("Disabled"), data = false},
		},
		default = true
	},
	{
		name = "scrappy_werepig",
		label = t("Scrappy Werepig"),
		hover = t("Display Scrappy Werepig Spawn Time"),
		options = {
			{description = t("Enabled"), data = true},
			{description = t("Disabled"), data = false},
		},
		default = true
	},
	{
		name = "atrium_gate_cooldown",
		label = t("Gateway Cooldown"),
		hover = t("Display Ancient Gateway Cooldown Time"),
		options = {
			{description = t("Enabled"), data = true},
			{description = t("Disabled"), data = false},
		},
		default = true
	},
	{
		name = "atrium_gate_destable",
		label = t("Ruins Reset"),
		hover = t("Display Ruins Regeneration Time"),
		options = {
			{description = t("Enabled"), data = true},
			{description = t("Disabled"), data = false},
		},
		default = true
	}
}
