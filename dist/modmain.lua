local env = env
GLOBAL.setfenv(1, GLOBAL)

-- based on modimport, but cache results and actually return the result
local importcache = {}
env.import = function(modulename)
	modulename = "main/"..modulename..".lua"
	if importcache[modulename] ~= nil then
		return importcache[modulename].result
	end

	print("import: "..env.MODROOT..modulename)
	local result = kleiloadlua(env.MODROOT..modulename)
	if result == nil then
		error("Error in import: "..modulename.." not found!")
	elseif type(result) == "string" then
		error("Error in import: "..ModInfoname(modname).." importing "..modulename.."!\n"..result)
	else
		setfenv(result, env)
		result = result()
	end

	importcache[modulename] = { result = result }
	return result
end

local function GetModConfigDataLocal(optionname)
	-- If the mod is run by the player hosting a game, use local server config
	-- instead of local client config. This is because local server config is
	-- generally where people expect mods to be configured, but reading local
	-- client config when not hosting allows different player to customize
	-- differently according to their own preferences.
	local hosting = TheNet:GetIsHosting()
	return env.GetModConfigData(optionname, not hosting)
end

local config =
{
	fontSize = GetModConfigDataLocal("fontsize")
}

local widgetwidth = GetModConfigDataLocal("widgetwidth")
local widgetheight = GetModConfigDataLocal("widgetheight")

local widget_xPos = GetModConfigDataLocal("widget_xPos")
local widget_yPos = GetModConfigDataLocal("widget_yPos")
local widget_padding = GetModConfigDataLocal("widgetpadding")

env.Assets =
{
	Asset("ATLAS", "images/houndswidget.xml"),
	Asset("ATLAS", "images/depthwormswidget.xml"),

	Asset("ATLAS", "images/script/ancient_gatewaywidget.xml"),
	Asset("ATLAS", "images/script/antlionwidget.xml"),
	Asset("ATLAS", "images/script/atrium_resetwidget.xml"),
	Asset("ATLAS", "images/script/beargerwidget.xml"),
	Asset("ATLAS", "images/script/beequeenhivewidget.xml"),
	Asset("ATLAS", "images/script/cavewidget.xml"),
	Asset("ATLAS", "images/script/crabkingwidget.xml"),
	Asset("ATLAS", "images/script/deerclopswidget.xml"),
	Asset("ATLAS", "images/script/depthwormswidget.xml"),
	Asset("ATLAS", "images/script/dragonflywidget.xml"),
	Asset("ATLAS", "images/script/fruitflywidget.xml"),
	Asset("ATLAS", "images/script/klauswidget.xml"),
	Asset("ATLAS", "images/script/malbatrosswidget.xml"),
	Asset("ATLAS", "images/script/masterwidget.xml"),
	Asset("ATLAS", "images/script/toadstoolwidget.xml"),
	Asset("ATLAS", "images/script/nightmare_werepigwidget.xml"),
	Asset("ATLAS", "images/script/scrappy_werepigwidget.xml"),

	Asset("ATLAS", "images/script/lunar_rift_phase_0.xml"),
	Asset("ATLAS", "images/script/lunar_rift_phase_1.xml"),
	Asset("ATLAS", "images/script/lunar_rift_phase_2.xml"),
	Asset("ATLAS", "images/script/lunar_rift_phase_3.xml"),
	Asset("ATLAS", "images/script/shadow_rift_phase_0.xml"),
	Asset("ATLAS", "images/script/shadow_rift_phase_1.xml"),
	Asset("ATLAS", "images/script/shadow_rift_phase_2.xml"),
	Asset("ATLAS", "images/script/shadow_rift_phase_3.xml"),
}

local Widget = require "widgets/widget"
local HoundsWidget = require "widgets/houndswidget"
local BossesWidget = require "widgets/bosseswidget"
local RiftsWidget = require "widgets/riftswidget"
local bosses = env.import "bosscmd"
local bosses_table = env.import "tables/bosses"
local altercmd = env.import "altercmd"
local MODSTRINGS = env.import "strings"

local bossprioritytype = GetModConfigDataLocal("prioritytype")
local showname = GetModConfigDataLocal("showname")

-- hound
env.AddClassPostConstruct("widgets/controls", function(hud)
	if not GetModConfigDataLocal("houndenable") then return end

	local width = widgetwidth
	local height = widgetheight
	local xPos, yPos, hAnchor, vAnchor = altercmd:getPosition(
		GetModConfigDataLocal("widgetalign"),
		widget_xPos, widget_yPos,
		width*2 + widget_padding)

	local container = hud:AddChild(Widget("RPGMonsterInfoContainer"))
	container:SetHAnchor(hAnchor)
	container:SetVAnchor(vAnchor)
	container:SetPosition(xPos, yPos, 0.0)
	container:SetClickable(false)
	container:SetScaleMode(SCALEMODE_PROPORTIONAL)

	local houndbar = container:AddChild(HoundsWidget(config, width, height, container))

	houndbar:Show()

	local entity = CreateEntity()
	entity:DoPeriodicTask(0.5, function()
		if ThePlayer == nil then return end

		local secondsToAttack = ThePlayer.player_classified.hound_time_to_attack

		local text = MODSTRINGS.WIDGET.NO_HOUND

		if secondsToAttack ~= nil then
			if secondsToAttack < 0 then
				text = MODSTRINGS.WIDGET.HOUND_CURRENT
			else
				local sAttack
				local ttAttack = math.floor(secondsToAttack)
				local minutes = math.floor(ttAttack / 60)
				local seconds = ttAttack - (minutes * 60)

				if minutes == 0 then
					sAttack = string.format(MODSTRINGS.WIDGET.SEC_LEFT, seconds)
				else
					sAttack = string.format(MODSTRINGS.WIDGET.MIN_SEC_LEFT, minutes, seconds)
				end

				local ttDays = string.format(MODSTRINGS.WIDGET.DAYS_LEFT, ttAttack / TUNING.TOTAL_DAY_TIME)

				text = sAttack .. "\n" .. ttDays
			end
		end

		houndbar:SetLabel(text)
	end)
end)

-- bosses
env.AddClassPostConstruct("widgets/controls", function(hud)
	if not GetModConfigDataLocal("bossenable") then return end

	local width = widgetwidth
	local height = widgetheight
	local xPos, yPos, hAnchor, vAnchor = altercmd:getPosition(
		GetModConfigDataLocal("widgetalign"),
		widget_xPos, widget_yPos,
		width*2 + widget_padding)

	local container = hud:AddChild(Widget("RPGMonsterInfoContainer"))
	container:SetHAnchor(hAnchor)
	container:SetVAnchor(vAnchor)
	container:SetPosition(xPos, yPos, 0.0)
	container:SetClickable(false)
	container:SetScaleMode(SCALEMODE_PROPORTIONAL)

	local bossesbar = container:AddChild(BossesWidget(config, width, height, container))

	bossesbar:Show()

	local entity = CreateEntity()
	local timerkeytable = bosses_table.worldtimerkey
	local nametoattacklast = nil

	entity:DoPeriodicTask(0.5, function()
		if ThePlayer == nil then return end

		local secondsToAttack 	= nil
		local nametoattack 		= nil
		local text = MODSTRINGS.WIDGET.NO_BOSS
		local attackTimer = {}

		for key, val in pairs(bosses_table.worldtimerkey) do
			if GetModConfigDataLocal(key) then
				local target = key .. "_time_to_attack"
				attackTimer[key] = ThePlayer.player_classified[target]
			end
		end

		local updatetimer = function(name, timer)
			if timer ~= nil and (secondsToAttack == nil or secondsToAttack > timer) then
				nametoattack = name
				secondsToAttack = timer
			end
		end

		for name, timer in pairs(attackTimer) do
			if bossprioritytype == "leasttimefirst" then
				updatetimer(name, timer)
			end

			if bossprioritytype == "attacktimefirst" then
				if nametoattack == nil or (not bosses_table.nametoattacktimefirst[nametoattack]) or bosses_table.nametoattacktimefirst[name] then
					updatetimer(name, timer)
				end
			end

			if bossprioritytype == "spawntimefirst" then
				if nametoattack == nil or (not bosses_table.nametospawntimefirst[nametoattack]) or bosses_table.nametospawntimefirst[name] then
					updatetimer(name, timer)
				end
			end
		end

		if secondsToAttack ~= nil then
			local sAttack
			local ttAttack = math.floor(secondsToAttack)
			local minutes = math.floor(ttAttack / 60)
			local seconds = ttAttack - (minutes * 60)

			if minutes == 0 then
				sAttack = string.format(MODSTRINGS.WIDGET.SEC_LEFT, seconds)
			else
				sAttack = string.format(MODSTRINGS.WIDGET.MIN_SEC_LEFT, minutes, seconds)
			end

			local ttDays = string.format(MODSTRINGS.WIDGET.DAYS_LEFT, ttAttack / TUNING.TOTAL_DAY_TIME)

			text = sAttack .. "\n" .. ttDays
			if showname then
				text = bosses_table.nametostring[nametoattack] .. "\n" .. text
			end

			if nametoattacklast ~= nametoattack then
				bossesbar:SetTexture(bosses_table.nametoscript[nametoattack], bosses_table.nametoimage[nametoattack])
				nametoattacklast = nametoattack
			end
		else
			if nametoattacklast ~= nil then
				if TheWorld:HasTag("cave") then
					bossesbar:SetTextureDefaultCave()
				else
					bossesbar:SetTextureDefaultMaster()
				end
				nametoattacklast = nil
			end
		end

		bossesbar:SetLabel(text)
	end)
end)

-- rift
env.AddClassPostConstruct("widgets/controls", function(hud)
	if not GetModConfigDataLocal("riftenable") then return end

	local width = widgetwidth
	local height = widgetheight
	local xPos, yPos, hAnchor, vAnchor = altercmd:getPosition(
		GetModConfigDataLocal("widgetalign"),
		widget_xPos, widget_yPos,
		width*2 + widget_padding)

	local container = hud:AddChild(Widget("RPGMonsterInfoContainer"))
	container:SetHAnchor(hAnchor)
	container:SetVAnchor(vAnchor)
	container:SetPosition(xPos, yPos, 0.0)
	container:SetClickable(false)
	container:SetScaleMode(SCALEMODE_PROPORTIONAL)

	local riftbar = container:AddChild(RiftsWidget(config, width, height, container))

	riftbar:Show()

	local entity = CreateEntity()
	entity:DoPeriodicTask(0.5, function()
		if ThePlayer == nil then return end

		local secondsToNextPhase = ThePlayer.player_classified.rift_time_to_next_phase
		local currentPhase = ThePlayer.player_classified.rift_current_phase

		local affinity = "lunar"
		if TheWorld:HasTag("cave") then
			affinity = "shadow"
		end

		local text = MODSTRINGS.WIDGET.NO_RIFT

		if secondsToNextPhase ~= nil then
			local sAttack
			local ttAttack = math.floor(secondsToNextPhase)
			local minutes = math.floor(ttAttack / 60)
			local seconds = ttAttack - (minutes * 60)

			if minutes == 0 then
				sAttack = string.format(MODSTRINGS.WIDGET.SEC_LEFT, seconds)
			else
				sAttack = string.format(MODSTRINGS.WIDGET.MIN_SEC_LEFT, minutes, seconds)
			end

			local ttDays = string.format(MODSTRINGS.WIDGET.DAYS_LEFT, ttAttack / TUNING.TOTAL_DAY_TIME)

			text = sAttack .. "\n" .. ttDays

			if ThePlayer.player_classified.rift_time_plus then
				text = sAttack .. "+\n" .. ttDays .. "+"
			else
				text = sAttack .. "\n" .. ttDays
			end

			local sWave = ""
			local waveleft = ThePlayer.player_classified.rift_wave_left
			if waveleft ~= nil then
				text = string.format(MODSTRINGS.WIDGET.RIFT_WAVE_LEFT, waveleft) .. "\n" .. text
			end
		elseif currentPhase ~= 0 then
			text = MODSTRINGS.WIDGET.RIFT_EXPANDING
		end

		riftbar:SetTexture(affinity, currentPhase)
		riftbar:SetLabel(text)
	end)
end)

-- reset positions
-- AddClassPostConstruct has guarenteed invocation order
env.AddClassPostConstruct("widgets/controls", function(hud)
	altercmd:resetPosition()
end)


-- for hounds
env.AddPrefabPostInit("player_classified", function(inst)
	inst.hound_time_to_attack = nil
	inst.net_hound_time_to_attack = net_int(inst.GUID, "hound_time_to_attack", "hound_time_to_attack_dirty")

	if not TheNet:IsDedicated() then
		inst:ListenForEvent("hound_time_to_attack_dirty", function(inst)
			inst.hound_time_to_attack = inst.net_hound_time_to_attack:value()
		end)
	end

	if not TheWorld.ismastersim then
		return
	end

	if TheWorld.components.hounded ~= nil then
		inst:DoPeriodicTask(0.5, function()
			inst.net_hound_time_to_attack:set(TheWorld.components.hounded:GetTimeToAttack())
		end)
	end
end)

-- for bosses
local predict_constructor = function(inst, name, key, isinst)
	local time_to_attack = name .. "_time_to_attack"
	local time_to_attack_dirty = time_to_attack .. "_dirty"
	local net_time_to_attack = "net_" .. name .. "_time_to_attack"

	inst[time_to_attack] = nil
	inst[net_time_to_attack] = net_int(inst.GUID, time_to_attack, time_to_attack_dirty)

	-- client
	if not TheNet:IsDedicated() then
		inst:ListenForEvent(time_to_attack_dirty, function(inst)
			local timeleft = inst[net_time_to_attack]:value()
			if timeleft == nil or timeleft < 0 then
				inst[time_to_attack] = nil
			else
				inst[time_to_attack] = timeleft
			end
		end)
	end

	if not TheWorld.ismastersim then
		return
	end

	-- server
	local forcefind = true

	inst:DoPeriodicTask(60.0, function()
		bosses:FindBossEntity(name)
		forcefind = false
	end)

	inst:DoPeriodicTask(0.5, function()
		if forcefind then
			bosses:FindBossEntity(name)
			forcefind = false
		end

		local timeleft = bosses:GetTimeLeft(name)

		if timeleft ~= nil then
			inst[net_time_to_attack]:set(timeleft)
		else
			inst[net_time_to_attack]:set(-1)
		end
	end)
end

for key, val in pairs(bosses_table.worldtimerkey) do
	env.AddPrefabPostInit("player_classified", function(inst)
		predict_constructor(inst, key, val, bosses_table.nametotag[key].inst)
	end)
end

-- for rifts
env.AddPrefabPostInit("player_classified", function(inst)
	inst.rift_time_to_next_phase = nil
	inst.net_rift_time_to_next_phase = net_int(inst.GUID, "rift_time_to_next_phase", "rift_time_to_next_phase_dirty")
	inst.rift_time_plus = nil
	inst.net_rift_time_plus = net_bool(inst.GUID, "rift_time_plus", "rift_time_plus_dirty")
	inst.rift_current_phase = 0
	inst.net_rift_current_phase = net_int(inst.GUID, "rift_current_phase", "rift_current_phase_dirty")
	inst.rift_wave_left = nil
	inst.net_rift_wave_left = net_int(inst.GUID, "rift_wave_left", "rift_wave_left_dirty")

	if not TheNet:IsDedicated() then
		inst:ListenForEvent("rift_time_to_next_phase_dirty", function(inst)
			local timeleft = inst.net_rift_time_to_next_phase:value()
			if timeleft == nil or timeleft < 0 then
				inst.rift_time_to_next_phase = nil
			else
				inst.rift_time_to_next_phase = timeleft
			end
		end)
		inst:ListenForEvent("rift_time_plus_dirty", function(inst)
			inst.rift_time_plus = inst.net_rift_time_plus:value()
		end)
		inst:ListenForEvent("rift_current_phase_dirty", function(inst)
			inst.rift_current_phase = inst.net_rift_current_phase:value()
		end)
		inst:ListenForEvent("rift_wave_left_dirty", function(inst)
			local waveleft = inst.net_rift_wave_left:value()
			if waveleft == nil or waveleft < 0 then
				inst.rift_wave_left = nil
			else
				inst.rift_wave_left = waveleft
			end
		end)
	end

	if not TheWorld.ismastersim then
		return
	end

	local RIFTSPAWN_TIMERNAME = "rift_spawn_timer"
	local worldsettingstimer = TheWorld.components.worldsettingstimer
	local timeleft = nil

	if TheWorld.components.riftspawner ~= nil then
		inst:DoPeriodicTask(0.5, function()
			local rifts = TheWorld.components.riftspawner:GetRifts()

			for rift, rift_prefab in pairs(rifts) do
				inst.net_rift_current_phase:set(rift._stage)

				timeleft = rift.components.timer:GetTimeLeft("trynextstage")
				if timeleft == nil then
					timeleft = rift.components.timer:GetTimeLeft("close")
				end

				local waveleft = -1
				local timeplus = false
				if timeleft == nil then
					timeleft = -1

					local plantspawner = TheWorld.components.lunarthrall_plantspawner
					if plantspawner ~= nil then
						waveleft = plantspawner.waves_to_release
					end
					if waveleft == nil then
						waveleft = -1
					elseif waveleft > 0 then
						if plantspawner._nextspawn ~= nil then
							timeleft = GetTaskRemaining(plantspawner._nextspawn)
						end
						if timeleft < 0 and plantspawner._spawntask ~= nil then
							timeleft = GetTaskRemaining(plantspawner._spawntask)
							timeplus = true
						end
					end
				end

				inst.net_rift_time_to_next_phase:set(timeleft)
				inst.net_rift_wave_left:set(waveleft)
				inst.net_rift_time_plus:set(timeplus)

				-- assume only one rift per world
				return
			end

			inst.net_rift_current_phase:set(0)
			inst.net_rift_wave_left:set(-1)

			timeleft = worldsettingstimer:GetTimeLeft(RIFTSPAWN_TIMERNAME)
			if timeleft == nil then
				inst.net_rift_time_to_next_phase:set(-1)
			else
				inst.net_rift_time_to_next_phase:set(timeleft)
				inst.net_rift_time_plus:set(false)
			end
		end)
	end
end)
