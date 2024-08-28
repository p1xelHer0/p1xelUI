local _, p1xelUI = ...
local m = p1xelUI:CreateModule("Misc")

local eventHandler = CreateFrame("Frame", nil, UIParent)
eventHandler:SetScript("OnEvent", function(self, event, ...)
  return self[event](self, ...)
end)

function m:OnLoad()
  self:Settings()
  -- self:Layer()
end

function m:Settings()
  SetCVar("ActionButtonUseKeyDown", 1)

  SetCVar("autoDismountFlying", 1)
  SetCVar("autoLootDefault", 1)
  SetCVar("combinedBags", 1)

  SetCVar("cameraDistanceMaxZoomFactor", 2.6)
  SetCVar("cameraPitchMoveSpeed", 45)
  SetCVar("cameraSmoothStyle", 0)
  SetCVar("cameraYawMoveSpeed", 90)
  SetCVar("ffxGlow", 0)

  SetCVar("uiScale", 0.65)
  SetCVar("useUiScale", 1)
  SetCVar("BreakUpLargeNumbers", 0)
  SetCVar("SHOW_ARENA_ENEMY_FRAMES_TEXT", 1)
  SetCVar("ShowArenaEnemyFrames", 1)
  SetCVar("ffxDeath", 0)
  SetCVar("ffxNether", 0)
  SetCVar("chatStyle", "classic")
  SetCVar("checkAddonVersion", 0)
  SetCVar("deselectOnClick", 1)

  SetCVar("findYourselfMode", 1)
  SetCVar("Outline", 3)
  SetCVar("OutlineEngineMode", 2)

  SetCVar("RAIDWaterDetail", 0)
  SetCVar("RAIDweatherDensity ", 0)

  SetCVar("floatingCombatTextSpellMechanics", 1)
  SetCVar("floatingCombatTextSpellMechanicsOther", 1)

  SetCVar("maxFPS", 160)
  SetCVar("maxFPSBk", 30)
  SetCVar("maxFPSLoading", 10)

  SetCVar("nameplateShowEnemyTotems", 1)
  SetCVar("nameplateShowEnemyPets", 1)
  SetCVar("nameplateShowEnemyGuardians", 1)
  SetCVar("nameplateShowEnemyMinions", 1)
  SetCVar("nameplateMaxDistance", 100)
  SetCVar("nameplateMaxAlphaDistance", 100)
  SetCVar("nameplateMinAlphaDistance", 100)
  SetCVar("nameplateMinAlpha", 0.7)
  SetCVar("nameplateOccludedAlphaMult", 0.5)
  SetCVar("nameplateShowAll", 1)
  SetCVar("NameplatePersonalShowAlways", 1)
  SetCVar("nameplateTargetBehindMaxDistance", 30)

  SetCVar("noBuffDebuffFilterOnTarget", 1)
  SetCVar("showTargetOfTarget", 1)

  SetCVar("whisperMode", "inline")
end

function m:Layer()
  -- Nova World Buffs - Layer text, already anchored to Minimap
  MinimapLayerFrame:ClearAllPoints()
  MinimapLayerFrame:SetPoint("TOP", 0, 20)
  LibDBIcon10_NovaWorldBuffs:SetAlpha(0)
end