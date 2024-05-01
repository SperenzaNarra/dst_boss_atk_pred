local Image = require "widgets/image"
local Text = require "widgets/text"
local Widget = require "widgets/widget"

local RiftsWidget = Class(Widget, function(self, userConfig, width, height, owner)
	Widget._ctor(self, "RiftsWidget")

	self.owner = owner
	self.width = width
	self.height = height

	self:SetClickable(false)
	self:SetScale(1, 1, 1)

	self.bgimage = self:AddChild(Image())
	if TheWorld:HasTag("cave") then
		self.bgimage:SetTexture("images/riftswidget/shadow_0.xml", "shadow_0.tex")
	else
		self.bgimage:SetTexture("images/riftswidget/lunar_0.xml", "lunar_0.tex")
	end
	self.bgimage:ScaleToSize(self.width, self.height)
	self.bgimage:SetTint(1.0, 1.0, 1.0, 1.0)
	self.bgimage:SetBlendMode(BLENDMODE.AlphaBlended)

	self.label = self:AddChild(Text("stint-ucr", userConfig.fontSize, "No rifts\npredicted!"))
	self.label:SetPosition(3.0, 0.0, 0.0)
	self.label:SetHAlign(ANCHOR_MIDDLE)
	self.label:SetVAlign(ANCHOR_MIDDLE)
end)

function RiftsWidget:SetLabel(text)
	self.label:SetString(text)
end

function RiftsWidget:SetTexture(affinity, phase)
	local name = affinity.."_"..phase;
	self.bgimage:SetTexture("images/riftswidget/"..name..".xml", ""..name..".tex")
end

return RiftsWidget
