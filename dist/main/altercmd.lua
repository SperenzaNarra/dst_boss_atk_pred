local env = env
GLOBAL.setfenv(1, GLOBAL)

local alterconsole = {}

function alterconsole:c_findone(prefab)
	for k,v in pairs(Ents) do
		if v.prefab == prefab then
			return v
		end
	end

	return nil
end

function alterconsole:getPosition(align, xPos, yPos, padding)
	if align == "lefttop" then
		return xPos, -yPos, padding, ANCHOR_LEFT, ANCHOR_TOP
	elseif align == "righttop" then
		return -xPos, -yPos, -padding, ANCHOR_RIGHT, ANCHOR_TOP
	elseif align == "leftbottom" then
		return xPos, yPos, padding, ANCHOR_LEFT, ANCHOR_BOTTOM
	elseif align == "rightbottom" then
		return -xPos, yPos, -padding, ANCHOR_RIGHT, ANCHOR_BOTTOM
	end
	-- wrong align value
	assert(false)
end

return alterconsole
