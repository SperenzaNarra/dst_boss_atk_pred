local env = env
GLOBAL.setfenv(1, GLOBAL)

local MODSTRINGS = env.import "strings"

local worldtimerkey = {
	bearger 	= "bearger_timetospawn",
	deerclops 	= "deerclops_timetoattack",
	klaus 		= "klaussack_spawntimer",
	fruitfly 	= "lordfruitfly_spawntime",
	malbatross 	= "malbatross_timetospawn",
	-- cave
	toadstool   = "toadstool_respawntask",

	-- insttimerkey
	antlion				= "rage",
	beequeenhive		= "hivegrowth",
	dragonfly_spawner 	= "regen_dragonfly",
	crabking_spawner	= "regen_crabking",
	-- cave
	atrium_gate_cooldown= "cooldown",
	atrium_gate_destable= "destabilizing",

	-- days_to_spawn
	nightmare_werepig	= "daywalkerspawner",
	scrappy_werepig		= "forestdaywalkerspawner",
}

local nametotag = {
	antlion				= {cave=false,master=true, inst=true},
	atrium_gate			= {cave=true, master=false,inst=true},
	atrium_gate_cooldown= {cave=true, master=false,inst=true},
	atrium_gate_destable= {cave=true, master=false,inst=true},
	bearger				= {cave=false,master=true, inst=false},
	beequeenhive		= {cave=false,master=true, inst=true},
	crabking_spawner	= {cave=false,master=true, inst=true},
	deerclops			= {cave=false,master=true, inst=false},
	dragonfly_spawner	= {cave=false,master=true, inst=true},
	fruitfly			= {cave=true, master=true, inst=false},
	klaus				= {cave=false,master=true, inst=false},
	malbatross			= {cave=false,master=true, inst=false},
	toadstool			= {cave=true, master=false,inst=false},
	nightmare_werepig	= {cave=true, master=false,inst=false},
	scrappy_werepig		= {cave=false, master=true,inst=false},
}


local nametoattacktimefirst = {
	antlion				= true,
	atrium_gate			= false,
	atrium_gate_cooldown= false,
	atrium_gate_destable= true,
	bearger				= true,
	beequeenhive		= false,
	crabking_spawner	= false,
	deerclops			= true,
	dragonfly_spawner	= false,
	fruitfly			= false,
	klaus				= false,
	malbatross			= false,
	toadstool			= false,
	nightmare_werepig	= false,
	scrappy_werepig		= false,
}

local nametospawntimefirst = {
	antlion				= false,
	atrium_gate			= false,
	atrium_gate_cooldown= false,
	atrium_gate_destable= true,
	bearger				= false,
	beequeenhive		= true,
	crabking_spawner	= true,
	deerclops			= false,
	dragonfly_spawner	= true,
	fruitfly			= false,
	klaus				= true,
	malbatross			= true,
	toadstool			= true,
	nightmare_werepig	= true,
	scrappy_werepig		= true,
}

local nametostring = {
	antlion				= STRINGS.NAMES.ANTLION,
	atrium_gate_cooldown= MODSTRINGS.BOSSES.ATRIUM_GATE_COOLDOWN,
	atrium_gate_destable= MODSTRINGS.BOSSES.ATRIUM_GATE_DESTABLE,
	bearger				= STRINGS.NAMES.BEARGER,
	beequeenhive		= STRINGS.NAMES.BEEQUEEN,
	crabking_spawner	= STRINGS.NAMES.CRABKING,
	deerclops			= STRINGS.NAMES.DEERCLOPS,
	dragonfly_spawner	= STRINGS.NAMES.DRAGONFLY,
	fruitfly			= MODSTRINGS.BOSSES.FRUITFLY,
	klaus				= STRINGS.NAMES.KLAUS,
	malbatross			= STRINGS.NAMES.MALBATROSS,
	toadstool			= STRINGS.NAMES.TOADSTOOL,
	nightmare_werepig	= STRINGS.NAMES.DAYWALKER,
	scrappy_werepig		= STRINGS.NAMES.DAYWALKER2,
}

local nametoimage = {
	atrium_gate_cooldown	= "ancient_gateway.tex",
	antlion					= "antlion.tex",
	atrium_gate_destable	= "atrium_reset.tex",
	bearger					= "bearger.tex",
	beequeenhive			= "beequeenhive.tex",
	cave					= "cave.tex",
	crabking_spawner		= "crabking.tex",
	deerclops				= "deerclops.tex",
	depthworms				= "depthworms.tex",
	dragonfly_spawner		= "dragonfly.tex",
	fruitfly				= "fruitfly.tex",
	klaus					= "klaus.tex",
	malbatross				= "malbatross.tex",
	master					= "master.tex",
	toadstool				= "toadstool.tex",
	nightmare_werepig		= "nightmare_werepig.tex",
	scrappy_werepig			= "scrappy_werepig.tex",
}

local nametoscript = {
	atrium_gate_cooldown	= "images/bosseswidget/ancient_gateway.xml",
	antlion					= "images/bosseswidget/antlion.xml",
	atrium_gate_destable	= "images/bosseswidget/atrium_reset.xml",
	bearger					= "images/bosseswidget/bearger.xml",
	beequeenhive			= "images/bosseswidget/beequeenhive.xml",
	cave					= "images/bosseswidget/cave.xml",
	crabking_spawner		= "images/bosseswidget/crabking.xml",
	deerclops				= "images/bosseswidget/deerclops.xml",
	depthworms				= "images/bosseswidget/depthworms.xml",
	dragonfly_spawner		= "images/bosseswidget/dragonfly.xml",
	fruitfly				= "images/bosseswidget/fruitfly.xml",
	klaus					= "images/bosseswidget/klaus.xml",
	malbatross				= "images/bosseswidget/malbatross.xml",
	master					= "images/bosseswidget/master.xml",
	toadstool				= "images/bosseswidget/toadstool.xml",
	nightmare_werepig		= "images/bosseswidget/nightmare_werepig.xml",
	scrappy_werepig			= "images/bosseswidget/scrappy_werepig.xml",
}

return {
	worldtimerkey 			= worldtimerkey,
	nametotag 				= nametotag,
	nametoattacktimefirst 	= nametoattacktimefirst,
	nametospawntimefirst 	= nametospawntimefirst,
	nametostring 			= nametostring,
	nametoimage 			= nametoimage,
	nametoscript 			= nametoscript
}
