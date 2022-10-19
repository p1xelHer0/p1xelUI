local _, p1xelUI = ...
local m = p1xelUI:CreateModule("Tags")

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

    local difficultyColor = function(unit)
        local color = nil
        if isBattlePet then
            local petLevel = UnitBattlePetLevel(unit)
            local teamLevel = C_PetJournal_GetPetTeamAverageLevel()
            if teamLevel < petLevel or teamLevel > petLevel then
                color = GetRelativeDifficultyColor(teamLevel, petLevel)
            else
                color = QuestDifficultyColors.difficult
            end
        else
            color = GetCreatureDifficultyColor(UnitEffectiveLevel(unit))
        end

	return E:RGBToHex(color.r, color.g, color.b)
    end

    local shortClassification = function(unit)
        local text = ""
        local classification = UnitClassification(unit)
        local RED = E:RGBToHex(1, 0, 0)
        local ORANGE = E:RGBToHex(1, 0.5, 0.25)
        local WHITE = E:RGBToHex(1, 1, 1)

        if classification == 'worldboss'  then
            text = RED..'B|r'
        elseif classification == 'rareelite'  then
            text =  RED..'R+|r'
        elseif classification == 'elite'  then
            text = ORANGE..'+|r'
        elseif classification == 'rare' then
            text = ORANGE..'R|r'
        elseif classification == 'minus'  then
            text = WHITE..'-|r'
        end

        return text
    end

    local p1xelLevel = function(unit)
        local levelText = nil
        local isBattlePet = E.Retail and (UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit))

        local level = UnitEffectiveLevel(unit)
        if isBattlePet then
            levelText = UnitBattlePetLevel(unit)
        elseif level == UnitEffectiveLevel('player') then
            levelText = ''
        elseif level > 0 then
            levelText = level
        else
            levelText = '??'
        end

        local classification = shortClassification(unit)

        if levelText == '' and classification == '' then
          return ''
        end

        local color = difficultyColor(unit)

        return color..levelText..'|r'..classification..'|r '
    end

    local tagLevel = "p1xelLevel"
    local tagLevelEvent = "UNIT_LEVEL UNIT_NAME_UPDATE PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED"
    ElvUF.Tags.Events[tagLevel] = tagLevelEvent
    ElvUF.Tags.Methods[tagLevel] = p1xelLevel

    local tagRoleEvent = "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE"

    local tagRole = "p1xelRole"
    ElvUF.Tags.Events[tagRole] = tagRoleEvent
    ElvUF.Tags.Methods[tagRole] = function(unit)
        local Role = UnitGroupRolesAssigned(unit)

        if Role == "HEALER" then
            return "|cFF4BAF4C+|r"
        elseif Role == "TANK" then
            return "|cFFB56E45#|r"
        end

        return nil
    end

    local tagRoleLeft = "p1xelRole-left"
    ElvUF.Tags.Events[tagRoleLeft] = tagRoleEvent
    ElvUF.Tags.Methods[tagRoleLeft] = function(unit)
        local Role = UnitGroupRolesAssigned(unit)

        if Role == "HEALER" then
            return " |cFF4BAF4C+|r"
        elseif Role == "TANK" then
            return " |cFFB56E45#|r"
        end

        return nil
    end

    local tagRoleRight = "p1xelRole-right"
    ElvUF.Tags.Events[tagRoleRight] = tagRoleEvent
    ElvUF.Tags.Methods[tagRoleRight] = function(unit)
        local Role = UnitGroupRolesAssigned(unit)

        if Role == "HEALER" then
            return "|cFF4BAF4C+|r "
        elseif Role == "TANK" then
            return "|cFFB56E45#|r "
        end

        return nil
    end

    E:AddTagInfo(tagRole, ns.mName, L["# for Tank, + for Healer and blank for DPS"], 4)
    E:AddTagInfo(tagRoleLeft, ns.mName, L["# for Tank, + for Healer and blank for DPS, padding on left side"], 4)
    E:AddTagInfo(tagRoleRight, ns.mName, L["# for Tank, + for Healer and blank for DPS, padding on right side"], 4)

    local tagRaidRoleEvent = "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE"

    local tagRaidRole = "p1xelRaidRole"
    ElvUF.Tags.Events[tagRaidRole] = tagRaidRoleEvent
    ElvUF.Tags.Methods[tagRaidRole] = function(unit)
        if UnitInRaid(unit) then
            if GetPartyAssignment('MAINTANK', unit) then
                return "|cFFB56E45MT|r"
            elseif GetPartyAssignment('MAINASSIST', unit) then
                return "|cFFB56E45MA|r"
            end
        end

        return nil
    end

    local tagRaidRoleLeft = "p1xelRaidRole-left"
    ElvUF.Tags.Events[tagRaidRoleLeft] = tagRaidRoleEvent
    ElvUF.Tags.Methods[tagRaidRoleLeft] = function(unit)
        if UnitInRaid(unit) then
            if GetPartyAssignment('MAINTANK', unit) then
                return " |cFFB56E45MT|r"
            elseif GetPartyAssignment('MAINASSIST', unit) then
                return " |cFFB56E45MA|r"
            end
        end

        return nil
    end

    local tagRaidRoleRight = "p1xelRaidRole-right"
    ElvUF.Tags.Events[tagRaidRoleRight] = tagRaidRoleEvent
    ElvUF.Tags.Methods[tagRaidRoleRight] = function(unit)
        if UnitInRaid(unit) then
            if GetPartyAssignment('MAINTANK', unit) then
                return "|cFFB56E45MT|r "
            elseif GetPartyAssignment('MAINASSIST', unit) then
                return "|cFFB56E45MA|r "
            end
        end

        return nil
    end

    E:AddTagInfo(tagRaidRole, ns.mName, L["MT for Main Tank, MA for Main Assist"], 4)
    E:AddTagInfo(tagRaidRoleLeft, ns.mName, L["MT for Main Tank, MA for Main Assist, padding on left side"], 4)
    E:AddTagInfo(tagRaidRoleRight, ns.mName, L["MT for Main Tank, MA for Main Assist, padding on right side"], 4)


    local tagLeaderEvent = "PARTY_LEADER_CHANGED GROUP_ROSTER_UPDATE"

    local tagLeader = "p1xelLeader"
    ElvUF.Tags.Events[tagLeader] = tagLeaderEvent
    ElvUF.Tags.Methods[tagLeader] = function(unit)
        if (UnitIsGroupLeader(unit) or UnitLeadsAnyGroup(unit)) then
          return "|cFFE3AE00L|r"
        end

        return nil
    end


    local tagLeaderLeft = "p1xelLeader-left"
    ElvUF.Tags.Events[tagLeaderLeft] = tagLeaderEvent
    ElvUF.Tags.Methods[tagLeaderLeft] = function(unit)
        if (UnitIsGroupLeader(unit) or UnitLeadsAnyGroup(unit)) then
          return " |cFFE3AE00L|r"
        end

        return nil
    end

    local tagLeaderRight = "p1xelLeader-right"
    ElvUF.Tags.Events[tagLeaderRight] = tagLeaderEvent
    ElvUF.Tags.Methods[tagLeaderRight] = function(unit)
        if (UnitIsGroupLeader(unit) or UnitLeadsAnyGroup(unit)) then
          return "|cFFE3AE00L|r "
        end

        return nil
    end

    E:AddTagInfo(tagLeader, ns.mName, L["L for Leader"], 4)
    E:AddTagInfo(tagLeaderLeft, ns.mName, L["L for Leader, padding on left side"], 4)
    E:AddTagInfo(tagLeaderRight, ns.mName, L["L for Leader, padding on right side"], 4)

    local tagAssistEvent = "PARTY_LEADER_CHANGED GROUP_ROSTER_UPDATE"

    local tagAssist = "p1xelAssist"
    ElvUF.Tags.Events[tagAssist] = tagAssistEvent
    ElvUF.Tags.Methods[tagAssist] = function(unit)
        if UnitIsGroupAssistant(unit) then
          return "|cFFE3AE00A|r"
        end

        return nil
    end

    local tagAssistLeft = "p1xelAssist-left"
    ElvUF.Tags.Events[tagAssistLeft] = tagAssistEvent
    ElvUF.Tags.Methods[tagAssistLeft] = function(unit)
        if UnitIsGroupAssistant(unit) then
          return " |cFFE3AE00A|r"
        end

        return nil
    end

    local tagAssistRight = "p1xelAssist-right"
    ElvUF.Tags.Events[tagAssistRight] = tagAssistEvent
    ElvUF.Tags.Methods[tagAssistRight] = function(unit)
        if UnitIsGroupAssistant(unit) then
          return "|cFFE3AE00A|r "
        end

        return nil
    end

    E:AddTagInfo(tagAssist, ns.mName, L["A for Assist"], 4)
    E:AddTagInfo(tagAssistLeft, ns.mName, L["A for Assist, padding on left side"], 4)
    E:AddTagInfo(tagAssistRight, ns.mName, L["A for Assist, padding on right side"], 4)

    local tagPhaseEvent = "UNIT_PHASE"

    local tagPhase = "p1xelPhasing"
    ElvUF.Tags.Events[tagPhase] = tagPhaseEvent
    ElvUF.Tags.Methods[tagPhase] = function(unit)
        if UnitIsPlayer(unit) and UnitIsConnected(unit) and UnitPhaseReason(unit) or nil then
            return " |cFF40FFFF*|r"
        end

        return nil
    end

    E:AddTagInfo(tagPhase, ns.mName, L["* for Phase"], 4)

    local tagCombatEvent = "PLAYER_REGEN_ENABLED PLAYER_REGEN_DISABLED"

    local tagCombat = "p1xelCombat"
    ElvUF.Tags.Events[tagCombat] = tagCombatEvent
    ElvUF.Tags.Methods[tagCombat] = function(unit)
        if UnitAffectingCombat(unit) then
            return "|cFFFF0000×|r"
        end

        return nil
    end

    E:AddTagInfo(tagCombat, ns.mName, L["× for Combat"], 4)

    local tagResurrectionEvent = "INCOMING_RESURRECT_CHANGED"

    local tagResurrection = "p1xelResurrection"
    ElvUF.Tags.Events[tagResurrection] = tagResurrectionEvent
    ElvUF.Tags.Methods[tagResurrection] = function(unit)
        if UnitHasIncomingResurrection(unit) then
            return "|cFFE6DB1F+|r"
        end

        return nil
    end

    E:AddTagInfo(tagResurrection, ns.mName, L["+ for Resurrection"], 4)
end
