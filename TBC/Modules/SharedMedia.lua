local _, p1xelUI = ...
local m = p1xelUI:CreateModule("SharedMedia")

local eventHandler = CreateFrame("Frame", nil, UIParent)
eventHandler:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, ...)
end)

function m:OnLoad()
    self:SetupMedia()
end

function m:SetupMedia()
    local LSM = LibStub("LibSharedMedia-3.0")

    if LSM == nil then
        return
    end

    LSM:Register("font", "p1xel", [[Interface\Addons\p1xelUI\Media\Fonts\PF_Tempesta_Seven.ttf]])
    LSM:Register("font", "p1xel-Large", [[Interface\Addons\p1xelUI\Media\Fonts\Homespun.ttf]])
    LSM:Register("font", "p1xel-Regular", [[Interface\Addons\p1xelUI\Media\Fonts\Barlow_SemiCondensed_SemiBold.ttf]])
    LSM:Register("font", "p1xel-Regular-Bold", [[Interface\Addons\p1xelUI\Media\Fonts\Barlow_SemiCondensed_Black.ttf]])

    LSM:Register("statusbar", "p1xel", [[Interface\Addons\p1xelUI\Media\Statusbar\statusbar.tga]])
end
