local _, p1xelUI = ...
local M = p1xelUI:CreateModule("UnitFrames")

local moduleEventHandler = CreateFrame("Frame", nil, UIParent)
moduleEventHandler:SetScript("OnEvent", function(self, event, ...)
  return self[event](self, ...)
end)

function M:OnLoad()
  self:SetupUnitframes()
  self:EnableCombatIndicator()
  self:EnableClassColoredStatusBars()
  self:EnableClassColoredTooltipName()
  self:EnableClassColoredNameBackground()
  self:RemoveTargetLevel()
end

function M:SetupUnitframes()
  local ToTX = -100
  local ToTY = -15

  local frameScale = 1.15
  local castbarScale = 1.15

  -- Player
  PlayerFrame:SetScale(frameScale)

  -- Pet
  PetName:SetAlpha(0)

  -- Feedback text
  local feedbackText =
    PlayerFrame:CreateFontString(nil, "OVERLAY", "NumberFontNormalHuge")
  PlayerFrame.feedbackText = feedbackText
  PlayerFrame.feedbackStartTime = 0
  PlayerHitIndicator:Hide()
  PetFrame.feedbackText = feedbackText
  PetFrame.feedbackStartTime = 0

  -- Remove clutter
  PlayerLeaderIcon:SetAlpha(0)
  PetHitIndicator:Hide()
  PlayerFrame.name:SetAlpha(0)
  PlayerFrameGroupIndicator:SetAlpha(0)
  PlayerPrestigeBadge:SetAlpha(0)
  PlayerPrestigePortrait:SetAlpha(0)
  PlayerPVPIcon:SetAlpha(0)

  -- Target
  TargetFrame:SetScale(frameScale)
  TargetFrameSpellBar:SetScale(castbarScale)
  TargetFrameTextureFramePVPIcon:SetAlpha(0)
  TargetFrameTextureFramePrestigeBadge:SetAlpha(0)
  TargetFrameTextureFramePrestigePortrait:SetAlpha(0)
  TargetFrameTextureFrameLeaderIcon:SetAlpha(0)

  -- Target of Target
  TargetFrameToT:ClearAllPoints()
  TargetFrameToT:SetPoint("LEFT", TargetFrame, "BOTTOMRIGHT", ToTX, ToTY)
end

function M:RemoveTargetLevel()
  hooksecurefunc("TargetFrame_Update", function(target)
    if (UnitLevel(target.unit) == 60) and UnitIsPlayer(target.unit) then
      TargetFrameTextureFrameTexture:SetTexture(
        "Interface/TargetingFrame/UI-TargetingFrame-NoLevel"
      )
      TargetFrameTextureFrameLevelText:SetAlpha(0)
      -- FocusFrameTextureFrameTexture:SetTexture("Interface/TargetingFrame/UI-TargetingFrame-NoLevel")
      --   FocusFrameTextureFrameLevelText:SetAlpha(0)
    else
      TargetFrameTextureFrameTexture:SetTexture(
        "Interface/TargetingFrame/UI-TargetingFrame"
      )
      TargetFrameTextureFrameLevelText:SetAlpha(1)
      -- FocusFrameTextureFrameTexture:SetTexture("Interface/TargetingFrame/UI-TargetingFrame")
      -- FocusFrameTextureFrameLevelText:SetAlpha(100)
    end
  end)
end

function M:EnableClassColoredStatusBars()
  moduleEventHandler:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

  hooksecurefunc("UnitFrameHealthBar_Update", self.ClassColorStatusBar)
  hooksecurefunc("HealthBar_OnValueChanged", function(self)
    M.ClassColorStatusBar(self, self.unit)
  end)

  local isTooltipStatusBar = _G.GameTooltipStatusBar
  function moduleEventHandler:UPDATE_MOUSEOVER_UNIT()
    M.ClassColorStatusBar(isTooltipStatusBar, "mouseover")
  end
end

function M:EnableClassColoredNameBackground()
  local eventHandler = CreateFrame("FRAME", nil, UIParent)
  eventHandler:RegisterEvent("GROUP_ROSTER_UPDATE")
  eventHandler:RegisterEvent("PLAYER_TARGET_CHANGED")
  eventHandler:RegisterEvent("UNIT_FACTION")

  local function UnitFrameBackgroundColor(self, event, ...)
    if UnitIsPlayer("target") then
      local color = RAID_CLASS_COLORS[select(2, UnitClass("target"))]
      TargetFrame.nameBackground:SetVertexColor(0.0, 0.0, 0.0, 0.50)
      TargetFrame.name:SetTextColor(color.r, color.g, color.b)
    end
  end

  eventHandler:SetScript("OnEvent", UnitFrameBackgroundColor)
end

local function getClassColor(unit)
  local _, class = UnitClass(unit)
  local color = class and RAID_CLASS_COLORS[class]

  return color
end

-- ClassColor statusbars
function M.ClassColorStatusBar(statusbar, unit)
  if UnitIsPlayer(unit) then
    local color = getClassColor(unit)
    if color then
      statusbar:SetStatusBarColor(color.r, color.g, color.b)
    end
  end
end

function M.EnableClassColoredTooltipName()
  GameTooltip:HookScript("OnTooltipSetUnit", function(GameTooltip)
    local _, unit = GameTooltip:GetUnit()
    if UnitIsPlayer(unit) then
      local color = getClassColor(unit)
      if color then
        local text = GameTooltipTextLeft1:GetText()
        GameTooltipTextLeft1:SetFormattedText(
          "|cff%02x%02x%02x%s|r",
          color.r * 255,
          color.g * 255,
          color.b * 255,
          text:match("|cff\x\x\x\x\x\x(.+)|r") or text
        )
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

function M:EnableCombatIndicator()
  moduleEventHandler:SetScript("OnUpdate", self.CombatIndicatorUpdate)
end
