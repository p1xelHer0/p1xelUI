local _, p1xelUi = ...
local m = p1xelUi:CreateModule("Tags")

local _, ns = ...

local eventHandler = CreateFrame("Frame", nil, UIParent)
eventHandler:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, ...)
end)

function m:OnLoad()
    self:ElvUITags()
end

function m:ElvUITags()
    local E, L = unpack(ElvUI)

    local roleTag = "p1xelRole"
    ElvUF.Tags.Events[roleTag] = "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE"
    ElvUF.Tags.Methods[roleTag] = function(unit)
        local Role = UnitGroupRolesAssigned(unit)

        if Role == "HEALER" then
            return "|cff4baf4c+|r "
        elseif Role == "TANK" then
            return "|cffb56e45#|r "
        end

        return ""
    end

    E:AddTagInfo(roleTag, ns.mName, L["T for Tank, H for Healer."], 4)
end
