local E, L, V, P, G = unpack(ElvUI)
local addon, ns = ...

ElvUF.Tags.Events["pRole"] = "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE"
ElvUF.Tags.Methods["pRole"] = function(unit)
    local Role = UnitGroupRolesAssigned(unit)

    if Role == "HEALER" then
        return "|cff4baf4c+|r"
    elseif Role == "TANK" then
        return "|cffb56e45#|r"
    end

    return ""
end

local combat = "|cffff0000c|r"

ElvUF.Tags.Events["pTCombat"] =
    "UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_NAME_UPDATE"
ElvUF.Tags.Methods["pTCombat"] = function()
    if UnitAffectingCombat("target") then
        return combat
    end

    return ""
end

ElvUF.Tags.Events["pFCombat"] =
    "UNIT_MAXHEALTH UNIT_CONNECTION PLAYER_FLAGS_CHANGED UNIT_NAME_UPDATE"
ElvUF.Tags.Methods["pFCombat"] = function()
    if UnitAffectingCombat("focus") then
        return combat
    end

    return ""
end

E:AddTagInfo("pRole", ns.mName, L["T for Tank, H for Healer."], 4)
E:AddTagInfo("pTCombat", ns.mName, L["Target combat status."], 5)
E:AddTagInfo("pFCombat", ns.mName, L["Focus combat status"], 6)
