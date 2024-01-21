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
}

local nametostring = {
	antlion				= "Antlion",
	atrium_gate_cooldown="Gate Cooldown",
	atrium_gate_destable="Atrium Reset",
	bearger				= "Bearger",
	beequeenhive		= "Bee Queen",
	crabking_spawner	= "Crab King",
	deerclops			= "Deerclops",
	dragonfly_spawner	= "Dragonfly",
	fruitfly			= "Fruitfly",
	klaus				= "Klaus",
	malbatross			= "Malbatross",
	toadstool			= "Toadstool",
}

local nametoimage = {
	atrium_gate_cooldown	= "../tex/ancient_gatewaywidget.tex",
	antlion					= "../tex/antlionwidget.tex",
	atrium_gate_destable	= "../tex/atrium_resetwidget.tex",
	bearger					= "../tex/beargerwidget.tex",
	beequeenhive			= "../tex/beequeenhivewidget.tex",
	cave					= "../tex/cavewidget.tex",
	crabking_spawner		= "../tex/crabkingwidget.tex",
	deerclops				= "../tex/deerclopswidget.tex",
	depthworms				= "../tex/depthwormswidget.tex",
	dragonfly_spawner		= "../tex/dragonflywidget.tex",
	fruitfly				= "../tex/fruitflywidget.tex",
	klaus					= "../tex/klauswidget.tex",
	malbatross				= "../tex/malbatrosswidget.tex",
	master					= "../tex/masterwidget.tex",
	toadstool				= "../tex/toadstoolwidget.tex",
}

local nametoscript = {
	atrium_gate_cooldown	= "images/script/ancient_gatewaywidget.xml",
	antlion					= "images/script/antlionwidget.xml",
	atrium_gate_destable	= "images/script/atrium_resetwidget.xml",
	bearger					= "images/script/beargerwidget.xml",
	beequeenhive			= "images/script/beequeenhivewidget.xml",
	cave					= "images/script/cavewidget.xml",
	crabking_spawner		= "images/script/crabkingwidget.xml",
	deerclops				= "images/script/deerclopswidget.xml",
	depthworms				= "images/script/depthwormswidget.xml",
	dragonfly_spawner		= "images/script/dragonflywidget.xml",
	fruitfly				= "images/script/fruitflywidget.xml",
	klaus					= "images/script/klauswidget.xml",
	malbatross				= "images/script/malbatrosswidget.xml",
	master					= "images/script/masterwidget.xml",
	toadstool				= "images/script/toadstoolwidget.xml",
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