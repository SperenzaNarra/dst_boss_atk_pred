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

return alterconsole
