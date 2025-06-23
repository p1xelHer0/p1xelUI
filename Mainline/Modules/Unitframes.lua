local _, p1xelUI = ...
local M = p1xelUI:CreateModule("UnitFrames")

local moduleEventHandler = CreateFrame("Frame", nil, UIParent)
moduleEventHandler:SetScript("OnEvent", function(self, event, ...)
  return self[event](self, ...)
end)

function M:OnLoad()
  -- self:ClassColorStatusBars()
  -- self:NamePlates()
  -- self:CombatIndicator()
  -- self:SetupRaidFrames()
end

local isTooltipStatusBar = _G.GameTooltipStatusBar

local classColor = function(unit)
  return RAID_CLASS_COLORS[select(2, UnitClass(unit))]
end

local nameAbbreviation = function(unit)
  local name = unit.healthBar.unitName:GetText()
  if name then
    local letters, lastWord = "", strmatch(name, ".+%s(.+)$")

    if lastWord then
      for word in gmatch(name, ".-%s") do
        local firstLetter = string.utf8sub(gsub(word, "^[%s%p]*", ""), 1, 1)
        if firstLetter ~= string.utf8lower(firstLetter) then
          letters = format("%s%s. ", letters, firstLetter)
        end
      end
      name = format("%s%s", letters, lastWord)

      if name then
        unit.healthBar.unitName:SetText(name)
      end
    end
  end
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
  -- BBF
  -- friendlyNamePlates()

  -- Arena target 1 / 2 / 3 inside Arena
  -- BBF
  -- hooksecurefunc("CompactUnitFrame_UpdateName", function(namePlate)
  --   if IsActiveBattlefieldArena() and namePlate.unit:find("nameplate") then
  --     for i = 1, 5 do
  --       if UnitIsUnit(namePlate.unit, "arena" .. i) then
  --         namePlate.name:SetText(i)
  --         local color = classColor(namePlate.unit)
  --         if color then
  --           namePlate.name:SetTextColor(color.r, color.g, color.b)
  --         else
  --           namePlate.name:SetTextColor(1, 1, 0)
  --         end
  --         break
  --       end
  --     end
  --   end
  -- end)

  moduleEventHandler:RegisterEvent("NAME_PLATE_UNIT_ADDED")
  function moduleEventHandler:NAME_PLATE_UNIT_ADDED()
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

-- Combat indicator
local combatIndicatorX = 96
local combatIndicatorY = -15
local combatIndicatorScale = 1
local combatIndicatorSize = 24
local combatIndicatorIcon = "Interface\\ICONS\\Ability_DualWield"

M.TargetCombatIndicator = CreateFrame("Frame", nil, TargetFrame)
M.TargetCombatIndicator:SetParent(TargetFrame)
M.TargetCombatIndicator:SetPoint(
  "CENTER",
  TargetFrame,
  combatIndicatorX,
  combatIndicatorY
)
M.TargetCombatIndicator:SetSize(combatIndicatorSize, combatIndicatorSize)
M.TargetCombatIndicator:SetScale(combatIndicatorScale)
M.TargetCombatIndicator.icon =
  M.TargetCombatIndicator:CreateTexture(nil, "BORDER")
M.TargetCombatIndicator.icon:SetAllPoints()
M.TargetCombatIndicator.icon:SetTexture(combatIndicatorIcon)
M.TargetCombatIndicator:Hide()

M.FocusCombatIndicator = CreateFrame("Frame", nil, FocusFrame)
M.FocusCombatIndicator:SetParent(FocusFrame)
M.FocusCombatIndicator:SetPoint(
  "CENTER",
  FocusFrame,
  combatIndicatorX,
  combatIndicatorY
)
M.FocusCombatIndicator:SetSize(combatIndicatorSize, combatIndicatorSize)
M.FocusCombatIndicator:SetScale(combatIndicatorScale)
M.FocusCombatIndicator.icon =
  M.FocusCombatIndicator:CreateTexture(nil, "BORDER")
M.FocusCombatIndicator.icon:SetAllPoints()
M.FocusCombatIndicator.icon:SetTexture(combatIndicatorIcon)
M.FocusCombatIndicator:Hide()

M.combatIndicatorElapsed = 0
local combatIndicatorUpdateInterval = 0.1
local UnitAffectingCombat = UnitAffectingCombat

function M.CombatIndicatorUpdate(_, elapsed)
  M.combatIndicatorElapsed = M.combatIndicatorElapsed + elapsed

  if M.combatIndicatorElapsed > combatIndicatorUpdateInterval then
    M.combatIndicatorElapsed = 0
    M.TargetCombatIndicator:SetShown(UnitAffectingCombat("target"))
    M.FocusCombatIndicator:SetShown(UnitAffectingCombat("focus"))
  end
end

function M:CombatIndicator()
  moduleEventHandler:SetScript("OnUpdate", self.CombatIndicatorUpdate)
end
