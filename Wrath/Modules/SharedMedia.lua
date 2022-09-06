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
    LSM:Register("font", "p1xel-ru", [[Interface\Addons\p1xelUI\Media\Fonts\iFlash_705.ttf]])
    LSM:Register("font", "p1xel-regular", [[Interface\Addons\p1xelUI\Media\Fonts\Barlow_SemiCondensed_SemiBold.ttf]])
    LSM:Register("font", "p1xel-bold", [[Interface\Addons\p1xelUI\Media\Fonts\Barlow_SemiCondensed_Black.ttf]])
    LSM:Register("font", "p1xel-combat", [[Interface\Addons\p1xelUI\Media\Fonts\Die_in_a_fire.otf]])

    LSM:Register("statusbar", "p1xel", [[Interface\Addons\p1xelUI\Media\Statusbar\statusbar.tga]])
end
