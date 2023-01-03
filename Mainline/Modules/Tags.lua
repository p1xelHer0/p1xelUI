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

  local COLOR_RESET = "|r"
  local COLOR_RED = E:RGBToHex(1, 0, 0)
  local COLOR_ORANGE = E:RGBToHex(1, 0.5, 0.25)
  local COLOR_WHITE = E:RGBToHex(1, 1, 1)

  local difficultyColor = function(unit, isBattlePet)
    local color = nil
    if isBattlePet then
      local petLevel = UnitBattlePetLevel(unit)
      local teamLevel = C_PetJournal.GetPetTeamAverageLevel()
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

    if classification == "worldboss" then
      text = COLOR_RED .. "B" .. COLOR_RESET
    elseif classification == "rareelite" then
      text = COLOR_RED .. "R+" .. COLOR_RESET
    elseif classification == "elite" then
      text = COLOR_ORANGE .. "+" .. COLOR_RESET
    elseif classification == "rare" then
      text = COLOR_ORANGE .. "R" .. COLOR_RESET
    elseif classification == "minus" then
      text = COLOR_WHITE .. "-" .. COLOR_RESET
    end

    return text
  end

  local p1xelLevel = function(unit)
    local levelText = nil
    local isBattlePet = E.Retail
      and (UnitIsWildBattlePet(unit) or UnitIsBattlePetCompanion(unit))

    local level = UnitEffectiveLevel(unit)
    if isBattlePet then
      levelText = UnitBattlePetLevel(unit)
    elseif level == UnitEffectiveLevel("player") then
      levelText = ""
    elseif level > 0 then
      levelText = level
    else
      levelText = "??"
    end

    local classification = shortClassification(unit)

    if levelText == "" and classification == "" then
      return ""
    end

    local color = difficultyColor(unit, isBattlePet)

    return color .. levelText .. COLOR_RESET .. classification .. COLOR_RESET .. " "
  end

  local tagLevel = "p1xelLevel"
  local tagLevelEvent =
    "UNIT_LEVEL UNIT_NAME_UPDATE PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED"
  ElvUF.Tags.Events[tagLevel] = tagLevelEvent
  ElvUF.Tags.Methods[tagLevel] = p1xelLevel

  local tagRoleEvent = "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE"

  local tagRole = "p1xelRole"
  ElvUF.Tags.Events[tagRole] = tagRoleEvent
  ElvUF.Tags.Methods[tagRole] = function(unit)
    local Role = UnitGroupRolesAssigned(unit)

    if Role == "HEALER" then
      return "|cFF4BAF4C+|r"
    elseif UnitInRaid(unit) then
      if GetPartyAssignment("MAINTANK", unit) then
        return "|cFFB56E45MT|r"
      end
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
    elseif UnitInRaid(unit) then
      if GetPartyAssignment("MAINTANK", unit) then
        return " |cFFB56E45MT|r"
      end
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
    elseif UnitInRaid(unit) then
      if GetPartyAssignment("MAINTANK", unit) then
        return "|cFFB56E45MT|r "
      end
    elseif Role == "TANK" then
      return "|cFFB56E45#|r "
    end

    return nil
  end

  E:AddTagInfo(
    tagRole,
    ns.mName,
    L["+ for Healer, # for Tank and MT for Main Tank"]
  )
  E:AddTagInfo(
    tagRoleLeft,
    ns.mName,
    L["+ for Healer, # for Tank and MT for Main Tank, padding on left side"]
  )
  E:AddTagInfo(
    tagRoleRight,
    ns.mName,
    L["+ for Healer, # for Tank and MT for Main Tank, padding on left side, padding on right side"]
  )


  local tagLeaderEvent = "PARTY_LEADER_CHANGED GROUP_ROSTER_UPDATE"

  local tagLeader = "p1xelLeader"
  ElvUF.Tags.Events[tagLeader] = tagLeaderEvent
  ElvUF.Tags.Methods[tagLeader] = function(unit)
    if UnitIsGroupLeader(unit) or UnitLeadsAnyGroup(unit) then
      return "|cFFE3AE00L|r"
    elseif UnitIsGroupAssistant(unit) then
      return "|cFFE3AE00A|r"
    elseif UnitInRaid(unit) then
      if GetPartyAssignment("MAINASSIST", unit) then
        return "|cFFE3AE00MA|r"
      end
    end

    return nil
  end

  local tagLeaderLeft = "p1xelLeader-left"
  ElvUF.Tags.Events[tagLeaderLeft] = tagLeaderEvent
  ElvUF.Tags.Methods[tagLeaderLeft] = function(unit)
    if UnitIsGroupLeader(unit) or UnitLeadsAnyGroup(unit) then
      return " |cFFE3AE00L|r"
    elseif UnitIsGroupAssistant(unit) then
      return " |cFFE3AE00A|r"
    elseif UnitInRaid(unit) then
      if GetPartyAssignment("MAINASSIST", unit) then
        return " |cFFE3AE00MA|r"
      end
    end

    return nil
  end

  local tagLeaderRight = "p1xelLeader-right"
  ElvUF.Tags.Events[tagLeaderRight] = tagLeaderEvent
  ElvUF.Tags.Methods[tagLeaderRight] = function(unit)
    if UnitIsGroupLeader(unit) or UnitLeadsAnyGroup(unit) then
      return "|cFFE3AE00L|r "
    elseif UnitIsGroupAssistant(unit) then
      return "|cFFE3AE00A|r "
    elseif UnitInRaid(unit) then
      if GetPartyAssignment("MAINASSIST", unit) then
        return "|cFFE3AE00MA|r "
      end
    end

    return nil
  end

  E:AddTagInfo(
    tagLeader,
    ns.mName,
    L["L for Leader, MA for Main Assist and A for Assist"]
  )
  E:AddTagInfo(
    tagLeaderLeft,
    ns.mName,
    L["L for Leader, MA for Main Assist and A for Assist, padding on left side"]
  )
  E:AddTagInfo(
    tagLeaderRight,
    ns.mName,
    L["L for Leader, MA for Main Assist and A for Assist, padding on right side"]
  )

  local tagPhaseEvent = "UNIT_PHASE"

  local tagPhase = "p1xelPhasing"
  ElvUF.Tags.Events[tagPhase] = tagPhaseEvent
  ElvUF.Tags.Methods[tagPhase] = function(unit)
    if
      UnitIsPlayer(unit) and UnitIsConnected(unit) and UnitPhaseReason(unit)
      or nil
    then
      return "|cFF40FFFF*" .. COLOR_RESET
    end

    return nil
  end

  E:AddTagInfo(tagPhase, ns.mName, L["* for Phase"])

  local tagCombatEvent = "PLAYER_REGEN_ENABLED PLAYER_REGEN_DISABLED"

  local tagCombat = "p1xelCombat"
  ElvUF.Tags.Events[tagCombat] = tagCombatEvent
  ElvUF.Tags.Methods[tagCombat] = function(unit)
    if UnitAffectingCombat(unit) then
      return COLOR_RED .. "×" .. COLOR_RESET
    end

    return nil
  end

  E:AddTagInfo(tagCombat, ns.mName, L["× for Combat"])

  local tagResurrectionEvent = "INCOMING_RESURRECT_CHANGED"

  local tagResurrection = "p1xelResurrection"
  ElvUF.Tags.Events[tagResurrection] = tagResurrectionEvent
  ElvUF.Tags.Methods[tagResurrection] = function(unit)
    if UnitHasIncomingResurrection(unit) then
      return "|cFFE6DB1F+|r"
    end

    return nil
  end

  E:AddTagInfo(tagResurrection, ns.mName, L["+ for Resurrection"])

  local tagReadyCheckEvent =
    "READY_CHECK READY_CHECK_CONFIRM READY_CHECK_FINISHED"

  local tagReadyCheck = "p1xelReadyCheck"
  ElvUF.Tags.Events[tagReadyCheck] = tagReadyCheckEvent
  ElvUF.Tags.Methods[tagReadyCheck] = function(unit)
    local status = GetReadyCheckStatus(unit)
    if status then
      if status == "ready" then
        return "|cFFFFFF00R|r"
      elseif status == "notready" then
        return "|cFFFF0000X|r"
      else
        return "|cFFE3AE00?|r"
      end
    end

    return nil
  end

  E:AddTagInfo(
    tagReadyCheck,
    ns.mName,
    L["R for Ready, X for not Ready, ? for In Progress"]
  )
end
