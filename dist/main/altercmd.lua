local env = env
GLOBAL.setfenv(1, GLOBAL)

local alterconsole = {}

local lastfound = -1

local function abs(n)
	if n < 0 then
		return -n
	else
		return n
	end
end

function alterconsole:c_findone(prefab)
	for k,v in pairs(Ents) do
		if v.prefab == prefab then
			return v
		end
	end

	return nil
end

function alterconsole:recalculatePostion(align, xPos, yPos)

	-- all value should be positive
	xPos = abs(xPos)
	yPos = abs(yPos)

	if align == "lefttop" then
		return xPos, -yPos, ANCHOR_LEFT, ANCHOR_TOP
	elseif align == "righttop" then
		return -xPos, -yPos, ANCHOR_RIGHT, ANCHOR_TOP
	elseif align == "leftbottom" then
		return xPos, yPos, ANCHOR_LEFT, ANCHOR_BOTTOM
	elseif align == "rightbottom" then
		return -xPos, yPos, ANCHOR_RIGHT, ANCHOR_BOTTOM
	end
	-- wrong align value
	assert(false)
end


local pos_counter = 0
function alterconsole:getPosition(align, xPos, yPos, padding)
	local res = xPos + padding * pos_counter
	pos_counter = pos_counter + 1

	if align == "lefttop" then
		return res, -yPos, ANCHOR_LEFT, ANCHOR_TOP
	elseif align == "righttop" then
		return -res, -yPos, ANCHOR_RIGHT, ANCHOR_TOP
	elseif align == "leftbottom" then
		return res, yPos, ANCHOR_LEFT, ANCHOR_BOTTOM
	elseif align == "rightbottom" then
		return -res, yPos, ANCHOR_RIGHT, ANCHOR_BOTTOM
	end
	-- wrong align value
	assert(false)
end

function alterconsole:resetPosition()
	pos_counter = 0
end

return alterconsole
