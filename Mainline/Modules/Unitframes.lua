local _, p1xelUI = ...
local M = p1xelUI:CreateModule("UnitFrames")

local eventHandler = CreateFrame("Frame", nil, UIParent)
eventHandler:SetScript("OnEvent", function(self, event, ...)
  return self[event](self, ...)
end)

function M:OnLoad()
  self:ClassColorStatusBars()
  self:NamePlates()
  self:CombatIndicator()
  self:SetupRaidFrames()
end

local isTooltipStatusBar = _G.GameTooltipStatusBar

local classColor = function(unit)
  return RAID_CLASS_COLORS[select(2, UnitClass(unit))]
end

-- Class Color Staturbar for Unitframes AND Tooltip
local colorStatusBar = function(statusBar)
  if UnitIsPlayer(statusBar.unit) and UnitIsConnected(statusBar.unit) then
    local color = classColor(statusBar.unit)
    if color then
      statusBar:SetStatusBarColor(color.r, color.g, color.b)
      statusBar:SetStatusBarDesaturated(true)
    else
      statusBar:SetStatusBarColor(0.5, 0.5, 0.5)
      statusBar:SetStatusBarDesaturated(true)
    end
  elseif UnitIsPlayer(statusBar.unit) then
    statusBar:SetStatusBarColor(0.5, 0.5, 0.5)
    statusBar:SetStatusBarDesaturated(true)
  else
    statusBar:SetStatusBarColor(0.0, 1.0, 0.0)
    statusBar:SetStatusBarDesaturated(true)
  end
end

function M:ClassColorStatusBars()
  hooksecurefunc("HealthBar_OnValueChanged", colorStatusBar)
  hooksecurefunc("UnitFrameHealthBar_Update", colorStatusBar)
end

local function friendlyNamePlates()
  if not InCombatLockdown() then
    C_NamePlate.SetNamePlateFriendlySize(60, 60)
  end
end

function M:NamePlates()
  -- Smaller friendly NamePlates
  friendlyNamePlates()

  -- Arena target 1 / 2 / 3 inside Arena
  hooksecurefunc("CompactUnitFrame_UpdateName", function(namePlate)
    if IsActiveBattlefieldArena() and namePlate.unit:find("nameplate") then
      for i = 1, 5 do
        if UnitIsUnit(namePlate.unit, "arena" .. i) then
          namePlate.name:SetText(i)
          local color = classColor(namePlate.unit)
          if color then
            namePlate.name:SetTextColor(color.r, color.g, color.b)
          else
            namePlate.name:SetTextColor(1, 1, 0)
          end
          break
        end
      end
    end
  end)

  eventHandler:RegisterEvent("NAME_PLATE_UNIT_ADDED")
  function eventHandler:NAME_PLATE_UNIT_ADDED()
    friendlyNamePlates()
  end
end

function M:SetupRaidFrames()
  -- Remove server from Raid Frames
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
          frame.name:SetText(unit_name:match("[^-]+"))
          frame.name:SetText("")
        end
      end
    end
  end)
end
