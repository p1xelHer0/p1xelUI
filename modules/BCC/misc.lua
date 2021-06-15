local _, p1xelUI = ...
local m = p1xelUI:CreateModule("Misc")

local eventHandler = CreateFrame("Frame", nil, UIParent)
eventHandler:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, ...)
end)

function m:OnLoad()
    self:Misc()
    self:SetCVars()
    self:SetupBuffs()
    self:SetupGameTooltip()
    self:SetupRaidFrames()
    self:SetupMinimap()
    self:MouseOverElements()
end

function m:Misc()
    UIErrorsFrame:Hide()
end

function m:SetCVars()
    SetCVar("autoLootDefault", 1)
    SetCVar("cameraDistanceMaxZoomFactor", 2.6)
    SetCVar("cameraPitchMoveSpeed", 45)
    SetCVar("cameraSmoothStyle", 0)
    SetCVar("cameraYawMoveSpeed", 90)
    SetCVar("ffxGlow", 0)
    SetCVar("autoLootDefault", 1)
    SetCVar("uiScale", 0.75)
    SetCVar("useUiScale", 1)
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
    SetCVar("OutlineEngineMode", 2)

    SetCVar("floatingCombatTextSpellMechanics", 1)
    SetCVar("floatingCombatTextSpellMechanicsOther", 1)

    SetCVar("maxFPS", 0)
    SetCVar("maxFPSBk", 30)
    SetCVar("maxFPSLoading", 10)

    SetCVar("NameplatePersonalShowAlways", 1)
    SetCVar("nameplateSelfBottomInset", .42)
    SetCVar("nameplateSelfTopInset", .52)
    SetCVar("nameplateMaxAlphaDistance", 100)
    SetCVar("nameplateMaxDistance", 100)
    SetCVar("nameplateMinAlpha", 0.7)
    SetCVar("nameplateMinAlphaDistance", 100)
    SetCVar("nameplateOccludedAlphaMult", 0.5)
    SetCVar("nameplateShowAll", 1)
    SetCVar("nameplateShowEnemyGuardians", 1)
    SetCVar("nameplateShowEnemyMinions", 1)
    SetCVar("nameplateShowEnemyPets", 1)
    SetCVar("nameplateShowEnemyTotems", 1)
    SetCVar("nameplateTargetBehindMaxDistance", 30)
    SetCVar("ShowClassColorInFriendlyNameplate", 1)

    SetCVar("noBuffDebuffFilterOnTarget", 1)
    SetCVar("showTargetOfTarget", 1)

    SetCVar("whisperMode", "inline")
end

function m:SetupBuffs()
    local function MoveBuffs()
        BuffFrame:ClearAllPoints()
        BuffFrame:SetPoint("TOP", 480, -80)
        BuffFrame:SetScale(1.2)
    end

    hooksecurefunc("UIParent_UpdateTopFramePositions", MoveBuffs)

    MoveBuffs()
end

local function friendlyNamePlates()
    C_NamePlate.SetNamePlateFriendlySize(60, 60)
end

function m:SetupNamePlates()
    -- Smaller friendly NamePlates
    friendlyNamePlates()

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

    eventHandler:RegisterEvent("NAME_PLATE_UNIT_ADDED")
end

function eventHandler:NAME_PLATE_UNIT_ADDED()
    friendlyNamePlates()
end

function m:SetupGameTooltip()
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

function m:SetupRaidFrames()
    -- Remove server from Raid Frames
    hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
        if frame and not frame:IsForbidden() then
            local frame_name = frame:GetName()
            if frame_name and frame_name:match("^CompactRaidFrame%d") and frame.unit and frame.name then
                local unit_name = GetUnitName(frame.unit, true)
                if unit_name then
                    frame.name:SetText(unit_name:match("[^-]+"))
                    -- frame.name:SetText("")
                end
            end
        end
    end)
end

function m:SetupMinimap()
    MinimapZoomIn:Hide()
    MinimapZoomOut:Hide()
    MinimapBorderTop:Hide()
    MinimapToggleButton:Hide()
    MinimapZoneText:Hide()
    MiniMapWorldMapButton:Hide()

    MinimapNorthTag:SetAlpha(0)
    GameTimeFrame:SetAlpha(0)
    MiniMapTracking:SetAlpha(0)

    Minimap:EnableMouseWheel(true)
    Minimap:SetScript('OnMouseWheel', function(_, delta)
        if delta > 0 then
            Minimap_ZoomIn()
        else
            Minimap_ZoomOut()
        end
    end)
end

function m:MouseOverElements()
    local ELEMENTS_TO_MOUSEOVER = {GameTimeFrame, QueueStatusMinimapButton,
                                   MiniMapTracking}

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
