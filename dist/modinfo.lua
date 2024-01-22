name = "Boss Attack Predictor"

description = "Predict boss attack/respown with displayed timer in a widget.\nAlso will display the time of Ruins Regeneration and Ancient Gateway Cooldown\n\nHas same features as Hound Attack Predictor, and additionally also predicts Rift cycles\n\nDon't Starve Together only"
author = "Sperenza & YiFei Zhu"
version = "2.0.1"

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
		label = "Show Name",
		hover = "The predictor will show the name of warnings",
		options = {
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = false
	},
	{
		name = "prioritytype",
		label = "Priority type",
		hover = "Choose the priority of warnings",
		options = {
			{
				description = "Least",
				data = "leasttimefirst",
				hover = "Prioritize the most recent warning event"
			},
			{
				description = "Attack",
				data = "attacktimefirst",
				hover = "Prioritize Antlion, Bearger, and Deerclops"
			},
			{
				description = "Spawn",
				data = "spawntimefirst",
				hover = "Prioritize Crabking, Dragonfly, Klaus, Malbatross, and Toadstool",
			}
		},
		default = "leasttimefirst"
	},
	{
		name = "houndenable",
		label = "Hound",
		hover = "Display Hound Widget",
		options = {
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = true
	},
	{
		name = "bossenable",
		label = "Boss",
		hover = "Display Boss Widget",
		options = {
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = true
	},
	{
		name = "riftenable",
		label = "Rift",
		hover = "Display Rift Widget",
		options = {
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = true
	},
	AddTitle("Widget Setting"),
	{
		name = "fontsize",
		label = "Font Size",
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
		label = "Padding",
		hover = "Distance Between Widgets",
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
		default = 0
	},
	{
		name = "widget_xPos",
		label = "X Pos",
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
		default = 80
	},
	{
		name = "widget_yPos",
		label = "Y Pos",
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
		default = 80
	},
	{
		name = "widgetalign",
		label = "Align",
		options = {
			{description = "Left Top", data = "lefttop"},
			{description = "Right Top", data = "righttop"},
			{description = "Left Bottom", data = "leftbottom"},
			{description = "Right Bottom", data = "rightbottom"},
		},
		default = "lefttop"
	},
	{
		name = "widgetwidth",
		label = "Width",
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
		label = "Height",
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
	AddTitle("Attack"),
	{
		name = "antlion",
		label = "Antlion",
		hover = "Display Antlion Rage Attack",
		options = {
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = true
	},
	{
		name = "bearger",
		label = "Bearger",
		hover = "Display Bearger Spawn Time",
		options = {
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = true
	},
	{
		name = "deerclops",
		label = "Deerclops",
		hover = "Display Deerclops Spawn Time",
		options = {
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = true
	},
	AddTitle("Spawn"),
	{
		name = "beequeenhive",
		label = "Bee Queen",
		hover = "Display Bee Queen Hive Spawn Time",
		options = {
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = true
	},
	{
		name = "crabking_spawner",
		label = "Crab King",
		hover = "Display Crabking Spawn Time",
		options = {
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = true
	},
	{
		name = "dragonfly_spawner",
		label = "Dragonfly",
		hover = "Display Dragonfly Spawn Time",
		options = {
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = true
	},
	{
		name = "fruitfly",
		label = "Fruitfly",
		hover = "Display Fruitfly Spawn Time",
		options = {
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = false
	},
	{
		name = "malbatross",
		label = "Malbatross",
		hover = "Display Malbatross Spawn Time",
		options = {
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = true
	},
	{
		name = "klaus",
		label = "Klaus",
		hover = "Display Klaus Sack Spawn Time",
		options = {
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = true
	},

	{
		name = "toadstool",
		label = "Toadstool",
		hover = "Display Toadstool Spawn Time",
		options = {
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = true
	},
	{
		name = "atrium_gate_cooldown",
		label = "Gateway Cooldown",
		hover = "Display Ancient Gateway Cooldown Time",
		options = {
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = true
	},
	{
		name = "atrium_gate_destable",
		label = "Ruins Reset",
		hover = "Display Ruins Regeneration Time",
		options = {
			{description = "Enabled", data = true},
			{description = "Disabled", data = false},
		},
		default = true
	}
}
