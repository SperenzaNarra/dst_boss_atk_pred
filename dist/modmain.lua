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
	Asset("ATLAS", "images/houndswidget/hounds.xml"),
	Asset("ATLAS", "images/houndswidget/depthworms.xml"),

	Asset("ATLAS", "images/bosseswidget/ancient_gateway.xml"),
	Asset("ATLAS", "images/bosseswidget/antlion.xml"),
	Asset("ATLAS", "images/bosseswidget/atrium_reset.xml"),
	Asset("ATLAS", "images/bosseswidget/bearger.xml"),
	Asset("ATLAS", "images/bosseswidget/beequeenhive.xml"),
	Asset("ATLAS", "images/bosseswidget/cave.xml"),
	Asset("ATLAS", "images/bosseswidget/crabking.xml"),
	Asset("ATLAS", "images/bosseswidget/deerclops.xml"),
	Asset("ATLAS", "images/bosseswidget/dragonfly.xml"),
	Asset("ATLAS", "images/bosseswidget/fruitfly.xml"),
	Asset("ATLAS", "images/bosseswidget/klaus.xml"),
	Asset("ATLAS", "images/bosseswidget/malbatross.xml"),
	Asset("ATLAS", "images/bosseswidget/master.xml"),
	Asset("ATLAS", "images/bosseswidget/toadstool.xml"),
	Asset("ATLAS", "images/bosseswidget/nightmare_werepig.xml"),
	Asset("ATLAS", "images/bosseswidget/scrappy_werepig.xml"),

	Asset("ATLAS", "images/riftswidget/lunar_0.xml"),
	Asset("ATLAS", "images/riftswidget/lunar_1.xml"),
	Asset("ATLAS", "images/riftswidget/lunar_2.xml"),
	Asset("ATLAS", "images/riftswidget/lunar_3.xml"),
	Asset("ATLAS", "images/riftswidget/shadow_0.xml"),
	Asset("ATLAS", "images/riftswidget/shadow_1.xml"),
	Asset("ATLAS", "images/riftswidget/shadow_2.xml"),
	Asset("ATLAS", "images/riftswidget/shadow_3.xml"),
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

env.AddClassPostConstruct("widgets/controls", function(hud)
	local width = widgetwidth
	local height = widgetheight
	local xPos, yPos, xOffset, hAnchor, vAnchor = altercmd:getPosition(
		GetModConfigDataLocal("widgetalign"),
		widget_xPos, widget_yPos, width + widget_padding)

	local container = hud.containerroot:AddChild(Widget("RPGMonsterInfoContainer"))
	container:SetHAnchor(hAnchor)
	container:SetVAnchor(vAnchor)
	container:SetPosition(xPos, yPos, 0.0)
	container:SetScaleMode(SCALEMODE_PROPORTIONAL)
	container:SetScale(1, 1, 1)

	local locationIdx = 0

	-- hound
	local houndswidgetinit = function()
		if not GetModConfigDataLocal("houndenable") then return end

		local houndbar = container:AddChild(HoundsWidget(config, width, height, container))
		hud.houndswidget = houndbar
		houndbar:SetPosition(locationIdx * xOffset, 0.0, 0.0)
		houndbar:Show()
		locationIdx = locationIdx + 1

		local entity = CreateEntity()
		entity:DoPeriodicTask(0.5, function()
			if TheWorld == nil or TheWorld.net == nil then return end

			local secondsToAttack = TheWorld.net.boss_attack_predictor.hound_time_to_attack

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
	end

	-- bosses
	local bosseswidgetinit = function()
		if not GetModConfigDataLocal("bossenable") then return end

		local bossesbar = container:AddChild(BossesWidget(config, width, height, container))
		hud.bosseswidget = bossesbar
		bossesbar:SetPosition(locationIdx * xOffset, 0.0, 0.0)
		bossesbar:Show()
		locationIdx = locationIdx + 1

		local entity = CreateEntity()
		local timerkeytable = bosses_table.worldtimerkey
		local nametoattacklast = nil

		entity:DoPeriodicTask(0.5, function()
			if TheWorld == nil or TheWorld.net == nil then return end

			local secondsToAttack 	= nil
			local nametoattack 		= nil
			local text = MODSTRINGS.WIDGET.NO_BOSS
			local attackTimer = {}

			for key, val in pairs(bosses_table.worldtimerkey) do
				if GetModConfigDataLocal(key) then
					local target = key .. "_time_to_attack"
					attackTimer[key] = TheWorld.net.boss_attack_predictor[target]
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
	end

	-- rift
	local riftwidgetinit = function()
		if not GetModConfigDataLocal("riftenable") then return end

		local riftbar = container:AddChild(RiftsWidget(config, width, height, container))
		hud.riftswidget = riftbar
		riftbar:SetPosition(locationIdx * xOffset, 0.0, 0.0)
		riftbar:Show()
		locationIdx = locationIdx + 1

		local entity = CreateEntity()
		entity:DoPeriodicTask(0.5, function()
			if TheWorld == nil or TheWorld.net == nil then return end

			local secondsToNextPhase = TheWorld.net.boss_attack_predictor.rift_time_to_next_phase
			local currentPhase = TheWorld.net.boss_attack_predictor.rift_current_phase

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

				if TheWorld.net.boss_attack_predictor.rift_time_plus then
					text = sAttack .. "+\n" .. ttDays .. "+"
				else
					text = sAttack .. "\n" .. ttDays
				end

				local sWave = ""
				local waveleft = TheWorld.net.boss_attack_predictor.rift_wave_left
				if waveleft ~= nil then
					text = string.format(MODSTRINGS.WIDGET.RIFT_WAVE_LEFT, waveleft) .. "\n" .. text
				end
			elseif currentPhase ~= 0 then
				text = MODSTRINGS.WIDGET.RIFT_EXPANDING
			end

			riftbar:SetTexture(affinity, currentPhase)
			riftbar:SetLabel(text)
		end)
	end

	houndswidgetinit()
	bosseswidgetinit()
	riftwidgetinit()
end)

-- https://steamcommunity.com/sharedfiles/filedetails/?id=2885137047
-- Register the widgets against "UI Drag Zoom MirrorFlip" mod
local modCompat_DragZoomUI = function()
	TUNING.DRAGZOOMUIMOD = TUNING.DRAGZOOMUIMOD or {}
	TUNING.DRAGZOOMUIMOD.UIList = TUNING.DRAGZOOMUIMOD.UIList or {}

	local myModUIList = {
		["widgets/controls"] = {
			houndswidget = "houndswidget",
			bosseswidget = "bosseswidget",
			riftswidget = "riftswidget",
		}
	}

	local function mergeTable(self, from, first)
		if type(self) ~= "table" and type(from) ~= "table" then
			return
		end
		if first then
			from = deepcopy(from)
		end
		for k, v in pairs(from) do
			if not self[k] then
				self[k] = v
			elseif type(self[k]) == "table" and type(v) == "table" then
				mergeTable(self[k], v)
			end
		end
	end

	mergeTable(TUNING.DRAGZOOMUIMOD.UIList, myModUIList)
end
modCompat_DragZoomUI()

local AddWorldNetPostInit = function(fn)
	env.AddPrefabPostInitAny(function(inst)
		if TheWorld == nil then return end
		if inst ~= TheWorld.net then return end
		fn(inst)
	end)
end

AddWorldNetPostInit(function(inst)
	inst.boss_attack_predictor = {}
end)

-- for hounds
AddWorldNetPostInit(function(inst)
	inst.boss_attack_predictor.hound_time_to_attack = nil
	inst.boss_attack_predictor.net_hound_time_to_attack = net_int(inst.GUID, "hound_time_to_attack", "hound_time_to_attack_dirty")

	if not TheNet:IsDedicated() then
		inst:ListenForEvent("hound_time_to_attack_dirty", function(inst)
			inst.boss_attack_predictor.hound_time_to_attack = inst.boss_attack_predictor.net_hound_time_to_attack:value()
		end)
	end

	if not TheWorld.ismastersim then
		return
	end

	if TheWorld.components.hounded ~= nil then
		inst:DoPeriodicTask(0.5, function()
			inst.boss_attack_predictor.net_hound_time_to_attack:set(TheWorld.components.hounded:GetTimeToAttack())
		end)
	end
end)

-- for bosses
local predict_constructor = function(inst, name, key, isinst)
	local time_to_attack = name .. "_time_to_attack"
	local time_to_attack_dirty = time_to_attack .. "_dirty"
	local net_time_to_attack = "net_" .. name .. "_time_to_attack"

	inst.boss_attack_predictor[time_to_attack] = nil
	inst.boss_attack_predictor[net_time_to_attack] = net_int(inst.GUID, time_to_attack, time_to_attack_dirty)

	-- client
	if not TheNet:IsDedicated() then
		inst:ListenForEvent(time_to_attack_dirty, function(inst)
			local timeleft = inst.boss_attack_predictor[net_time_to_attack]:value()
			if timeleft == nil or timeleft < 0 then
				inst.boss_attack_predictor[time_to_attack] = nil
			else
				inst.boss_attack_predictor[time_to_attack] = timeleft
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
			inst.boss_attack_predictor[net_time_to_attack]:set(timeleft)
		else
			inst.boss_attack_predictor[net_time_to_attack]:set(-1)
		end
	end)
end

for key, val in pairs(bosses_table.worldtimerkey) do
	AddWorldNetPostInit(function(inst)
		predict_constructor(inst, key, val, bosses_table.nametotag[key].inst)
	end)
end

-- for rifts
AddWorldNetPostInit(function(inst)
	inst.boss_attack_predictor.rift_time_to_next_phase = nil
	inst.boss_attack_predictor.net_rift_time_to_next_phase = net_int(inst.GUID, "rift_time_to_next_phase", "rift_time_to_next_phase_dirty")
	inst.boss_attack_predictor.rift_time_plus = nil
	inst.boss_attack_predictor.net_rift_time_plus = net_bool(inst.GUID, "rift_time_plus", "rift_time_plus_dirty")
	inst.boss_attack_predictor.rift_current_phase = 0
	inst.boss_attack_predictor.net_rift_current_phase = net_int(inst.GUID, "rift_current_phase", "rift_current_phase_dirty")
	inst.boss_attack_predictor.rift_wave_left = nil
	inst.boss_attack_predictor.net_rift_wave_left = net_int(inst.GUID, "rift_wave_left", "rift_wave_left_dirty")

	if not TheNet:IsDedicated() then
		inst:ListenForEvent("rift_time_to_next_phase_dirty", function(inst)
			local timeleft = inst.boss_attack_predictor.net_rift_time_to_next_phase:value()
			if timeleft == nil or timeleft < 0 then
				inst.boss_attack_predictor.rift_time_to_next_phase = nil
			else
				inst.boss_attack_predictor.rift_time_to_next_phase = timeleft
			end
		end)
		inst:ListenForEvent("rift_time_plus_dirty", function(inst)
			inst.boss_attack_predictor.rift_time_plus = inst.boss_attack_predictor.net_rift_time_plus:value()
		end)
		inst:ListenForEvent("rift_current_phase_dirty", function(inst)
			inst.boss_attack_predictor.rift_current_phase = inst.boss_attack_predictor.net_rift_current_phase:value()
		end)
		inst:ListenForEvent("rift_wave_left_dirty", function(inst)
			local waveleft = inst.boss_attack_predictor.net_rift_wave_left:value()
			if waveleft == nil or waveleft < 0 then
				inst.boss_attack_predictor.rift_wave_left = nil
			else
				inst.boss_attack_predictor.rift_wave_left = waveleft
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
				inst.boss_attack_predictor.net_rift_current_phase:set(rift._stage)

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

				inst.boss_attack_predictor.net_rift_time_to_next_phase:set(timeleft)
				inst.boss_attack_predictor.net_rift_wave_left:set(waveleft)
				inst.boss_attack_predictor.net_rift_time_plus:set(timeplus)

				-- assume only one rift per world
				return
			end

			inst.boss_attack_predictor.net_rift_current_phase:set(0)
			inst.boss_attack_predictor.net_rift_wave_left:set(-1)

			timeleft = worldsettingstimer:GetTimeLeft(RIFTSPAWN_TIMERNAME)
			if timeleft == nil then
				inst.boss_attack_predictor.net_rift_time_to_next_phase:set(-1)
			else
				inst.boss_attack_predictor.net_rift_time_to_next_phase:set(timeleft)
				inst.boss_attack_predictor.net_rift_time_plus:set(false)
			end
		end)
	end
end)
