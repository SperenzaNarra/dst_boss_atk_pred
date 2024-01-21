local Image = require "widgets/image"
local Text = require "widgets/text"
local Widget = require "widgets/widget"

Assets =
{
    Asset("ATLAS", "images/script/ancient_gatewaywidget.xml"),
    Asset("ATLAS", "images/script/antlionwidget.xml"),
    Asset("ATLAS", "images/script/atrium_resetwidget.xml"),
    Asset("ATLAS", "images/script/beargerwidget.xml"),
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
}
local BossesWidget = Class(Widget, function(self, userConfig, width, height, owner)
	Widget._ctor(self, "BossesWidget")

	self.owner = owner
	self.width = width
	self.height = height

	self:SetClickable(false)
	self:SetScale(1, 1, 1)

	self.bgimage = self:AddChild(Image())
	if TheWorld:HasTag("cave") then
		self.bgimage:SetTexture("images/script/cavewidget.xml", "../tex/cavewidget.tex")
	else
		self.bgimage:SetTexture("images/script/masterwidget.xml", "../tex/masterwidget.tex")
	end
    self.bgimage:ScaleToSize(self.width, self.height)
    self.bgimage:SetTint(1.0, 1.0, 1.0, 1.0)
    self.bgimage:SetBlendMode(1)

	self.label = self:AddChild(Text("stint-ucr", userConfig.fontSize, "No attack\npredicted!"))
	self.label:SetPosition(3.0, 0.0, 0.0)
	self.label:SetHAlign(ANCHOR_MIDDLE)
	self.label:SetVAlign(ANCHOR_MIDDLE)
end)

function BossesWidget:SetLabel(text)
	self.label:SetString(text)
end

function BossesWidget:SetTexture(xml, tex)
	self.bgimage:SetTexture(xml, tex)
end

function BossesWidget:SetTextureDefaultCave()
	self.bgimage:SetTexture("images/script/cavewidget.xml", "../tex/cavewidget.tex")
end

function BossesWidget:SetTextureDefaultMaster()
	self.bgimage:SetTexture("images/script/masterwidget.xml", "../tex/masterwidget.tex")
end

return BossesWidget
