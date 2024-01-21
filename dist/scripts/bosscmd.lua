local bosses = require "tables/bosses"
local altercmd = require "altercmd"

local bossconsole = {}
local bosscache = {}

function bossconsole:GetTimerKeyTable()
	return bosses.worldtimerkey
end

function bossconsole:GetTimerKey(name)
	return bosses.worldtimerkey[name]
end

function bossconsole:GetTags(name)
	return bosses.nametotag[name]
end

function bossconsole:IsCave(name)
	return bosses.bosses.nametotag[name].cave
end

function bossconsole:IsMaster(name)
	return bosses.nametotag[name].master
end

function bossconsole:IsInst(name)
	return bosses.nametotag[name].inst
end

function bossconsole:ToString(name)
	return bosses.nametostring[name]
end

function bossconsole:GetImage(name)
	return bosses.nametoimage[name]
end

function bossconsole:GetScript(name)
	return bosses.nametoscript[name]
end

function bossconsole:GetAttackPriority(name)
	return bosses.nametoattacktimefirst[name]
end

function bossconsole:GetSpawnPriority(name)
	return bosses.nametospawntimefirst[name]
end

function bossconsole:FindBossEntity(name)
	if bosses.nametotag[name].inst then
		if bosscache[name] == nil or Ents[bosscache[name].GUID] == nil then
			bosscache[name] = altercmd:c_findone(name)
		end
	end
end

function bossconsole:GetTimeLeft(name)
	local tags = bosses.nametotag[name]
	local key = bosses.worldtimerkey[name]
	local iscave = TheWorld:HasTag("cave")
	local target = nil

	if (iscave and not tags.cave) or (not iscave and not tags.master) then
		return nil
	end

	-- special case
	if name == "atrium_gate_cooldown" or name == "atrium_gate_destable" then
		name = "atrium_gate"
	end

	-- get entity
	if tags.inst then
		target = bosscache[name]
	else
		target = TheWorld
	end

	--[[
		// From worldsettingstimer.lua
		function WorldSettingsTimer:IsPaused(name)
			return self:TimerExists(name) and (not self:TimerEnabled(name) or self.timers[name].paused)
		end
	]]--

	if target == nil then
		return nil
	end

	if name == "beequeenhive" then
		if target.components.timer ~= nil and not target.components.timer:IsPaused(key) then
			return target.components.timer:GetTimeLeft(key)
		end
	else
		-- default
		if target.components.worldsettingstimer ~= nil and not target.components.worldsettingstimer:IsPaused(key) then
			return target.components.worldsettingstimer:GetTimeLeft(key)
		end
	end

	return nil
end





return bossconsole
