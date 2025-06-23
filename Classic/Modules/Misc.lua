local _, p1xelUI = ...
local M = p1xelUI:CreateModule("Misc")

local moduleEventHandler = CreateFrame("Frame", nil, UIParent)
moduleEventHandler:SetScript("OnEvent", function(self, event, ...)
  return self[event](self, ...)
end)

function M:OnLoad()
  self:Misc()
  self:SetupBuffs()
  self:SetupNamePlates()
  self:SetupGameTooltip()
  self:SetupRaidFrames()
  self:SetupMinimap()
  self:MouseOverElements()
  self:MoveNovaWorldBuffs()
  self:Tooltip()
end

function M:Misc()
  -- QuickJoinToastButton:Hide(0)
  UIErrorsFrame:Hide()
end

function M:SetupBuffs()
  local function MoveBuffs()
    local buffX = 607
    local buffY = 387
    BuffFrame:ClearAllPoints()
    BuffFrame:SetPoint("CENTER", buffX, buffY)
    BuffFrame:SetScale(1.05)

    TemporaryEnchantFrame:ClearAllPoints()
    TemporaryEnchantFrame:SetPoint("CENTER", buffX + 8, buffY + 8)
    TemporaryEnchantFrame:SetScale(1.2)
  end

  hooksecurefunc("UIParent_UpdateTopFramePositions", MoveBuffs)

  MoveBuffs()
end

function M:SetupNamePlates()
  hooksecurefunc("CompactUnitFrame_UpdateName", function(nameplate)
    local isNameplate = nameplate.unit:find("nameplate")

    if isNameplate then
      -- Class colored names for friendly units instead of healthbar
      if
        UnitIsFriend("player", nameplate.unit)
        and UnitIsPlayer(nameplate.unit)
        and isNameplate
      then
        local color = RAID_CLASS_COLORS[select(2, UnitClass(nameplate.unit))]
        local unit_name = GetUnitName(nameplate.unit, true)
        nameplate.name:SetVertexColor(color.r, color.g, color.b)
        nameplate.name:SetText(unit_name:match("[^-]+"))
      end
    end
  end)

  moduleEventHandler:RegisterEvent("NAME_PLATE_UNIT_ADDED")
end

function moduleEventHandler:NAME_PLATE_UNIT_ADDED()
end

function M:SetupGameTooltip()
  local function FixGameTooltip()
    -- Don't move tooltip to the left when enabling Right Bars
    CONTAINER_OFFSET_X = 0
  end

  hooksecurefunc("UIParent_ManageFramePosition", function(index)
    if InCombatLockdown() then
      return
    end

    FixGameTooltip()
  end)

  FixGameTooltip()
end

function M:SetupRaidFrames()
  -- Remove names from Raid Frames
  hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
    if frame and not frame:IsForbidden() then
      local frame_name = frame:GetName()
      if
        frame_name
        and frame_name:match("^CompactRaidFrame%d")
        and frame.unit
        and frame.name
      then
        local unit_name = GetUnitName(frame.unit, true)
        if unit_name then
          frame.name:SetText("")
        end
      end
    end
  end)
end

function M:SetupMinimap()
  MinimapCluster:SetScale(1.30)
  MinimapCluster:ClearAllPoints()
  MinimapCluster:SetPoint("BOTTOMRIGHT", 0, 0)

  Minimap:EnableMouseWheel(true)
  Minimap:SetScript("OnMouseWheel", function(_, delta)
    if delta > 0 then
      Minimap_ZoomIn()
    else
      Minimap_ZoomOut()
    end
  end)

  MinimapZoomIn:Hide()
  MinimapZoomOut:Hide()
  MinimapBorderTop:Hide()
  MinimapZoneText:Hide()
  MiniMapWorldMapButton:Hide()

  MinimapNorthTag:SetAlpha(0)
  GameTimeFrame:SetAlpha(0)
  MiniMapTracking:SetAlpha(0)
  LoadAddOn("Blizzard_TimeManager")
  local region = TimeManagerClockButton:GetRegions()
  region:Hide()
  TimeManagerClockButton:Hide()
end

function M:MouseOverElements()
  local ELEMENTS_TO_MOUSEOVER = {
    GameTimeFrame,
    MiniMapTracking,
  }

  local function showElement(self)
    self:SetAlpha(100)
  end

  local function hideElement(self)
    self:SetAlpha(0)
  end

  for _, element in ipairs(ELEMENTS_TO_MOUSEOVER) do
    element:HookScript("OnEnter", showElement)
    element:HookScript("OnLeave", hideElement)
    element:SetAlpha(0)
  end
end

function M:MoveNovaWorldBuffs()
  if LibDBIcon10_NovaWorldBuffs ~= nil then
    MinimapLayerFrame:ClearAllPoints()
    MinimapLayerFrame:SetPoint("TOP", 0, 20)
    LibDBIcon10_NovaWorldBuffs:SetAlpha(0)
  end
end

function M:Tooltip()
  -- TODO
  -- Hide Tooltips in combat
  function OnTooltipSetUnit(tooltip, data)
    if InCombatLockdown() then
      GameTooltip:Hide()
    end
  end

  -- Move Tooltip above Minimap
  hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip)
    tooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -7, 275)
  end)
end
