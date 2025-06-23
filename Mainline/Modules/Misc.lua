local _, p1xelUI = ...
local M = p1xelUI:CreateModule("Misc")

local moduleEventHandler = CreateFrame("Frame", nil, UIParent)
moduleEventHandler:SetScript("OnEvent", function(self, event, ...)
  return self[event](self, ...)
end)

local function getClassColor(unit)
  local _, class = UnitClass(unit)
  local color = class and RAID_CLASS_COLORS[class]

  return color
end

function M:OnLoad()
  self:CVars()
  self:Tooltip()
  self:SetupHelpers()
  self:EnableClassColoredStatusBars()
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

function M.ClassColorStatusBar(statusbar, unit)
  if UnitIsPlayer(unit) then
    local color = getClassColor(unit)
    if color then
      statusbar:SetStatusBarColor(color.r, color.g, color.b)
    end
  end
end

function M:SetupHelpers()
  function p1xelUI:nameAbbreviation(name)
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
          frame.name:SetText(name)
        end
      end
    end
  end
end

function M:CVars()
  -- SetCVar("ActionButtonUseKeyDown", 1)

  -- SetCVar("autoDismountFlying", 1)
  -- SetCVar("autoLootDefault", 1)
  -- SetCVar("combinedBags", 1)

  -- SetCVar("cameraDistanceMaxZoomFactor", 2.6)
  -- SetCVar("cameraPitchMoveSpeed", 45)
  -- SetCVar("cameraSmoothStyle", 0)
  -- SetCVar("cameraYawMoveSpeed", 90)
  -- SetCVar("ffxGlow", 0)

  -- SetCVar("uiScale", 0.5)
  -- SetCVar("useUiScale", 1)
  -- SetCVar("BreakUpLargeNumbers", 0)
  -- SetCVar("SHOW_ARENA_ENEMY_FRAMES_TEXT", 1)
  -- SetCVar("ShowArenaEnemyFrames", 1)
  -- SetCVar("ffxDeath", 0)
  -- SetCVar("ffxNether", 0)
  -- SetCVar("chatStyle", "classic")
  -- SetCVar("checkAddonVersion", 0)
  -- SetCVar("deselectOnClick", 1)

  -- SetCVar("findYourselfMode", 1)
  -- SetCVar("Outline", 3)
  -- SetCVar("OutlineEngineMode", 2)

  -- SetCVar("RAIDweatherDensity ", 0)

  -- SetCVar("floatingCombatTextSpellMechanics", 1)
  -- SetCVar("floatingCombatTextSpellMechanicsOther", 1)

  -- SetCVar("maxFPS", 0)
  -- SetCVar("maxFPSLoading", 10)
  -- SetCVar("maxFPSBk", 30)
  -- SetCVar("maxFPSLoading", 10)

  -- SetCVar("nameplateShowEnemyTotems", 1)
  -- SetCVar("nameplateShowEnemyPets", 1)
  -- SetCVar("nameplateShowEnemyGuardians", 1)
  -- SetCVar("nameplateShowEnemyMinions", 1)
  -- SetCVar("nameplateSelectedScale", 1.2)
  -- SetCVar("nameplateMaxDistance", 100)
  -- SetCVar("nameplateMaxAlphaDistance", 100)
  -- SetCVar("nameplateMinAlphaDistance", 100)
  -- SetCVar("nameplateMinAlpha", 0.7)
  -- SetCVar("nameplateOccludedAlphaMult", 0.5)
  -- SetCVar("nameplateShowAll", 1)
  -- SetCVar("NameplatePersonalShowAlways", 1)
  -- SetCVar("nameplateTargetBehindMaxDistance", 30)

  -- SetCVar("noBuffDebuffFilterOnTarget", 1)
  -- SetCVar("showTargetOfTarget", 1)

  SetCVar("whisperMode", "inline")

  function M:Tooltip()
    -- Hide Tooltips in combat
    function OnTooltipSetUnit(tooltip, data)
      if InCombatLockdown() and not C_PetBattles.IsInBattle() then
        -- if data and data.guid then
        --   local type, _, _, _, _, npcID = string.split("-", data.guid)
        --   if (type ~= "Player") and (type ~= "Vignette") then
        --     npcID = tonumber(npcID)
        --     local t = {
        --       131616,
        --       134064,
        --       139573,
        --       144605,
        --       147834,
        --       147876,
        --       147861,
        --       147774,
        --       147775,
        --       147780,
        --       147784,
        --       155909,
        --       155910,
        --       155911,
        --     }
        --     for i = 1, #t do
        --       if npcID == t[i] then
        --         return
        --       end
        --     end
        --   end
        -- end

        GameTooltip:Hide()
      end

      -- local _, unit = GameTooltip:GetUnit()
      -- if UnitIsPlayer(unit) then
      --   local color = getClassColor(unit)
      --   if color then
      --     local text = GameTooltipTextLeft1:GetText()
      --     GameTooltipTextLeft1:SetFormattedText(
      --       "|cff%02x%02x%02x%s|r",
      --       color.r * 255,
      --       color.g * 255,
      --       color.b * 255,
      --       text:match("|cff\x\x\x\x\x\x(.+)|r") or text
      --     )
      --   end
      -- end
    end

    TooltipDataProcessor.AddTooltipPostCall(
      Enum.TooltipDataType.Unit,
      OnTooltipSetUnit
    )

    -- Move Tooltip above Minimap
    hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip)
      tooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -7, 295)
    end)
  end
end
