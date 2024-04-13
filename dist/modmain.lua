KnownModIndex = GLOBAL.KnownModIndex
local require = GLOBAL.require

local config =
{
	fontSize = GetModConfigData("fontsize")
}

local widgetwidth = GetModConfigData("widgetwidth")
local widgetheight = GetModConfigData("widgetheight")

local widget_xPos = GetModConfigData("widget_xPos")
local widget_yPos = GetModConfigData("widget_yPos")
local widget_padding = GetModConfigData("widgetpadding")

Assets =
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
local bosses = require "bosscmd"
local altercmd = require "altercmd"

local bossprioritytype = GetModConfigData("prioritytype")
local showname = GetModConfigData("showname")


-- hound
AddClassPostConstruct("widgets/controls", function(hud)
	print("Start to construct Hound Attack Predictor Widget")
	if not GetModConfigData("houndenable") then return end

	local width = widgetwidth
	local height = widgetheight
	local xPos, yPos, hAnchor, vAnchor = altercmd:getPosition(
		GetModConfigData("widgetalign"),
		widget_xPos, widget_yPos,
		width*2 + widget_padding)

	local container = hud:AddChild(Widget("RPGMonsterInfoContainer"))
	container:SetHAnchor(hAnchor)
	container:SetVAnchor(vAnchor)
	container:SetPosition(xPos, yPos, 0.0)
	container:SetClickable(false)
	container:SetScaleMode(GLOBAL.SCALEMODE_PROPORTIONAL)

	local houndbar = container:AddChild(HoundsWidget(config, width, height, container))

	houndbar:Show()

	local entity = GLOBAL.CreateEntity()
	entity:DoPeriodicTask(0.5, function()
		if GLOBAL.ThePlayer == nil then return end

		local secondsToAttack = GLOBAL.ThePlayer.player_classified.hound_time_to_attack

		local text = "No attack\npredicted!"

		if secondsToAttack ~= nil then
			if secondsToAttack < 0 then
				text = "Attack!"
			else
				local ttAttack = math.floor(secondsToAttack)
				local minutes = math.floor(ttAttack / 60)
				local seconds = ttAttack - (minutes * 60)

				if minutes == 0 then
					sAttack = seconds.." seconds"
				else
					if seconds <= 9 then
						seconds = "0"..seconds
					end
					sAttack = minutes.."m "..seconds
				end

				text = string.format("%s\n%.2f days", sAttack, ttAttack / GLOBAL.TUNING.TOTAL_DAY_TIME)
			end
		end

		houndbar:SetLabel(text)
	end)
	print("Hound Attack Predictor Widget is constructed")
end)

-- bosses
AddClassPostConstruct("widgets/controls", function(hud)
	print("[boss attack predictor] Start to construct Bosses Attack Predictor Widget")
	if not GetModConfigData("bossenable") then return end

	local width = widgetwidth
	local height = widgetheight
	local xPos, yPos, hAnchor, vAnchor = altercmd:getPosition(
		GetModConfigData("widgetalign"),
		widget_xPos, widget_yPos,
		width*2 + widget_padding)

	print("[boss attack predictor] get widget width  " .. widgetwidth .. "px")
	print("[boss attack predictor] get widget height " .. widgetheight .. "px")
	print("[boss attack predictor] get widget xpos   " .. xPos .. "px")
	print("[boss attack predictor] get widget ypos   " .. yPos .. "px")

	local container = hud:AddChild(Widget("RPGMonsterInfoContainer"))
	container:SetHAnchor(hAnchor)
	container:SetVAnchor(vAnchor)
	container:SetPosition(xPos, yPos, 0.0)
	container:SetClickable(false)
	container:SetScaleMode(GLOBAL.SCALEMODE_PROPORTIONAL)

	local bossesbar = container:AddChild(BossesWidget(config, width, height, container))

	bossesbar:Show()

	local entity = GLOBAL.CreateEntity()
	local timerkeytable = bosses:GetTimerKeyTable()
	local nametoattacklast = nil

	entity:DoPeriodicTask(0.5, function()

		if GLOBAL.ThePlayer == nil then return end

		local secondsToAttack 	= nil
		local nametoattack 		= nil
		local text = "No Boss\nPredicted"
		local attackTimer = {}

		for key, val in pairs(bosses:GetTimerKeyTable()) do
			local target = key .. "_time_to_attack"
			attackTimer[key] = GLOBAL.ThePlayer.player_classified[target]
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
				if nametoattack == nil or (not bosses:GetAttackPriority(nametoattack)) or bosses:GetAttackPriority(name) then
					updatetimer(name, timer)
				end
			end

			if bossprioritytype == "spawntimefirst" then
				if nametoattack == nil or (not bosses:GetSpawnPriority(nametoattack)) or bosses:GetSpawnPriority(name) then
					updatetimer(name, timer)
				end
			end
		end

		if secondsToAttack ~= nil then
			local ttAttack = math.floor(secondsToAttack)
			local minutes = math.floor(ttAttack / 60)
			local seconds = ttAttack - (minutes * 60)

			if minutes == 0 then
				sAttack = seconds.." seconds"
			else
				if seconds <= 9 then
					seconds = "0"..seconds
				end
				sAttack = minutes.."m "..seconds
			end
			if nametoattacklast ~= nametoattack then
				bossesbar:SetTexture(bosses:GetScript(nametoattack), bosses:GetImage(nametoattack))
				nametoattacklast = nametoattack
			end
			if showname then
				text = string.format("%s\n%s\n%.2f days", bosses:ToString(nametoattack), sAttack, ttAttack / GLOBAL.TUNING.TOTAL_DAY_TIME)
			else
				text = string.format("%s\n%.2f days",  sAttack, ttAttack / GLOBAL.TUNING.TOTAL_DAY_TIME)
			end
		else
			if nametoattacklast ~= nil then
				if GLOBAL.TheWorld:HasTag("cave") then
					bossesbar:SetTextureDefaultCave()
				else
					bossesbar:SetTextureDefaultMaster()
				end
				nametoattacklast = nil
			end
		end

		bossesbar:SetLabel(text)
	end)
	print("Bosses Attack Predictor Widget is constructed")
end)

-- rift
AddClassPostConstruct("widgets/controls", function(hud)
	print("Start to construct Rift Predictor Widget")
	if not GetModConfigData("riftenable") then return end

	local width = widgetwidth
	local height = widgetheight
	local xPos, yPos, hAnchor, vAnchor = altercmd:getPosition(
		GetModConfigData("widgetalign"),
		widget_xPos, widget_yPos,
		width*2 + widget_padding)

	local container = hud:AddChild(Widget("RPGMonsterInfoContainer"))
	container:SetHAnchor(hAnchor)
	container:SetVAnchor(vAnchor)
	container:SetPosition(xPos, yPos, 0.0)
	container:SetClickable(false)
	container:SetScaleMode(GLOBAL.SCALEMODE_PROPORTIONAL)

	local riftbar = container:AddChild(RiftsWidget(config, width, height, container))

	riftbar:Show()

	local entity = GLOBAL.CreateEntity()
	entity:DoPeriodicTask(0.5, function()
		if GLOBAL.ThePlayer == nil then return end

		local secondsToNextPhase = GLOBAL.ThePlayer.player_classified.rift_time_to_next_phase
		local currentPhase = GLOBAL.ThePlayer.player_classified.rift_current_phase

		local affinity = "lunar"
		if GLOBAL.TheWorld:HasTag("cave") then
			affinity = "shadow"
		end

		local text = "No rifts\npredicted!"

		if secondsToNextPhase ~= nil then
			local ttAttack = math.floor(secondsToNextPhase)
			local minutes = math.floor(ttAttack / 60)
			local seconds = ttAttack - (minutes * 60)

			if minutes == 0 then
				sAttack = seconds.." seconds"
			else
				if seconds <= 9 then
					seconds = "0"..seconds
				end
				sAttack = minutes.."m "..seconds
			end

			local sTimeplus = ""
			if GLOBAL.ThePlayer.player_classified.rift_time_plus then
				sTimeplus = "+"
			end

			local sWave = ""
			local waveleft = GLOBAL.ThePlayer.player_classified.rift_wave_left
			if waveleft ~= nil then
				sWave = string.format("%d wave%s left\n", waveleft, waveleft ~= 1 and "s" or "")
			end

			text = string.format("%s%s%s\n%.2f%s days", sWave, sAttack, sTimeplus, ttAttack / GLOBAL.TUNING.TOTAL_DAY_TIME, sTimeplus)
		elseif currentPhase ~= 0 then
			text = "Expanding!"
		end

		riftbar:SetTexture(affinity, currentPhase)
		riftbar:SetLabel(text)
	end)
	print("Rift Predictor Widget is constructed")
end)

-- for hounds
AddPrefabPostInit("player_classified", function(inst)
	inst.hound_time_to_attack = nil
	inst.net_hound_time_to_attack = GLOBAL.net_int(inst.GUID, "hound_time_to_attack", "hound_time_to_attack_dirty")

	if not GLOBAL.TheNet:IsDedicated() then
		inst:ListenForEvent("hound_time_to_attack_dirty", function(inst)
			inst.hound_time_to_attack = inst.net_hound_time_to_attack:value()
		end)
	end

	if not GLOBAL.TheWorld.ismastersim then
		return
	end

	if GLOBAL.TheWorld.components.hounded ~= nil then
		inst:DoPeriodicTask(0.5, function()
			inst.net_hound_time_to_attack:set(GLOBAL.TheWorld.components.hounded:GetTimeToAttack())
		end)
	end
end)

-- for bosses
local predict_constructor = function(inst, name, key, isinst)

	local time_to_attack = name .. "_time_to_attack"
	local time_to_attack_dirty = time_to_attack .. "_dirty"
	local net_time_to_attack = "net_" .. name .. "_time_to_attack"

	inst[time_to_attack] = nil
	inst[net_time_to_attack] = GLOBAL.net_int(inst.GUID, time_to_attack, time_to_attack_dirty)

	-- client
	if not GLOBAL.TheNet:IsDedicated() then
		inst:ListenForEvent(time_to_attack_dirty, function(inst)
			local timeleft = inst[net_time_to_attack]:value()
			if timeleft == nil or timeleft < 0 then
				inst[time_to_attack] = nil
			else
				inst[time_to_attack] = timeleft
			end
		end)
	end

	if not GLOBAL.TheWorld.ismastersim then
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

for key, val in pairs(bosses:GetTimerKeyTable()) do
	if GetModConfigData(key) then
		AddPrefabPostInit("player_classified", function(inst)predict_constructor(inst, key, val, bosses:IsInst(key)) end)
	end
end

-- for rifts
AddPrefabPostInit("player_classified", function(inst)
	inst.rift_time_to_next_phase = nil
	inst.net_rift_time_to_next_phase = GLOBAL.net_int(inst.GUID, "rift_time_to_next_phase", "rift_time_to_next_phase_dirty")
	inst.rift_time_plus = nil
	inst.net_rift_time_plus = GLOBAL.net_bool(inst.GUID, "rift_time_plus", "rift_time_plus_dirty")
	inst.rift_current_phase = 0
	inst.net_rift_current_phase = GLOBAL.net_int(inst.GUID, "rift_current_phase", "rift_current_phase_dirty")
	inst.rift_wave_left = nil
	inst.net_rift_wave_left = GLOBAL.net_int(inst.GUID, "rift_wave_left", "rift_wave_left_dirty")

	if not GLOBAL.TheNet:IsDedicated() then
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

	if not GLOBAL.TheWorld.ismastersim then
		return
	end

	local RIFTSPAWN_TIMERNAME = "rift_spawn_timer"
	local worldsettingstimer = GLOBAL.TheWorld.components.worldsettingstimer
	local timeleft = nil

	if GLOBAL.TheWorld.components.riftspawner ~= nil then
		inst:DoPeriodicTask(0.5, function()
			local rifts = GLOBAL.TheWorld.components.riftspawner:GetRifts()

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

					local plantspawner = GLOBAL.TheWorld.components.lunarthrall_plantspawner
					if plantspawner ~= nil then
						waveleft = plantspawner.waves_to_release
					end
					if waveleft == nil then
						waveleft = -1
					elseif waveleft > 0 then
						if plantspawner._nextspawn ~= nil then
							timeleft = GLOBAL.GetTaskRemaining(plantspawner._nextspawn)
						end
						if timeleft < 0 and plantspawner._spawntask ~= nil then
							timeleft = GLOBAL.GetTaskRemaining(plantspawner._spawntask)
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
