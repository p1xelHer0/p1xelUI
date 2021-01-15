local _, p1xelUi = ...
local m = p1xelUi:CreateModule("Misc")

local eventHandler = CreateFrame("Frame", nil, UIParent)
eventHandler:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, ...)
end)

function m:OnLoad()
    self:Settings()
    self:SetupBuffs()
    self:SetupNameplates()
    self:SetupRaidFrames()
    self:SetupMinimap()
end

function m:Settings()
    ConsoleExec("ffxglow 0")
    QuickJoinToastButton:Hide(0)
    UIErrorsFrame:Hide()

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

function m:SetupBuffs()
    local function MoveBuffs()
        BuffFrame:ClearAllPoints()
        BuffFrame:SetPoint("TOP", 500, -120)
        BuffFrame:SetScale(1.3)
    end

    hooksecurefunc("UIParent_UpdateTopFramePositions", MoveBuffs)
    MoveBuffs()
end

function m:SetupNameplates()
    -- Smaller friendly nameplates
	C_NamePlate.SetNamePlateFriendlySize(60, 60)
    -- Arena target 1 / 2 / 3 inside Arena
    hooksecurefunc("CompactUnitFrame_UpdateName", function(nameplate)
        if IsActiveBattlefieldArena() and nameplate.unit:find("nameplate") then
            for i = 1, 5 do
                if UnitIsUnit(nameplate.unit, "arena" .. i) then
                    nameplate.name:SetText(i)
                    nameplate.name:SetTextColor(1, 1, 0)
                    break
                end
            end
        end
    end)
end

function m:SetupRaidFrames()
    -- Remove server from Raid Frames
    hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
        if frame and not frame:IsForbidden() then
            local frame_name = frame:GetName()
            if frame_name and frame_name:match("^CompactRaidFrame%d") and frame.unit and frame.name then
                local unit_name = GetUnitName(frame.unit, true)
                if unit_name then
                    frame.name:SetText(unit_name:match("[^-]+"))
                end
            end
        end
    end)
end

function m:SetupMinimap()
    MinimapZoomIn:Hide()
    MinimapZoomOut:Hide()
    MinimapBorderTop:Hide()
    GameTimeFrame:Hide()
    MinimapZoneText:Hide()

    MiniMapWorldMapButton:SetAlpha(0)

    Minimap:EnableMouseWheel(true)

    Minimap:SetScript('OnMouseWheel', function(_, delta)
        if delta > 0 then
            Minimap_ZoomIn()
        else
            Minimap_ZoomOut()
        end
    end)

    MiniMapTracking:Hide()
end
