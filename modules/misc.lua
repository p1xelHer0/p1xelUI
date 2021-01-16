local _, p1xelUI = ...
local m = p1xelUI:CreateModule("Misc")

local eventHandler = CreateFrame("Frame", nil, UIParent)
eventHandler:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, ...)
end)

function m:OnLoad()
    self:Settings()
end

function m:Settings()
    UIErrorsFrame:Hide()
    ConsoleExec("ffxglow 0")
    SetCVar("UIScale", 0.75)
    SetCVar('BreakUpLargeNumbers', 0)
    SetCVar("SHOW_ARENA_ENEMY_FRAMES_TEXT", 1)
    SetCVar("ShowArenaEnemyFrames", 1)
    SetCVar("ffxDeath", 0)
    SetCVar("ffxNether", 0)
    SetCVar("chatStyle", "classic")
    SetCVar("checkAddonVersion", 0)
    SetCVar("deselectOnClick", 1)
    SetCVar("findYourselfMode", 1)
    SetCVar("Outline", 3)
    SetCVar("floatingCombatTextSpellMechanics", 1)
    SetCVar("floatingCombatTextSpellMechanicsOther", 1)
    SetCVar("maxFPS", 0)
    SetCVar("maxFPSBk", 30)
    SetCVar("maxFPSLoading", 10)
end
