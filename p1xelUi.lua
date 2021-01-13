local AddonName, Addon = ...

local function MinimapCleanup()
    MinimapZoomIn:Hide()
    MinimapZoomOut:Hide()
    MiniMapWorldMapButton:Hide()
    MinimapBorderTop:Hide()
    GameTimeFrame:Hide()
    MinimapZoneText:Hide()

    Minimap:EnableMouseWheel(true)

    Minimap:SetScript('OnMouseWheel', function(self, delta)
        if delta > 0 then
            Minimap_ZoomIn()
        else
            Minimap_ZoomOut()
        end
    end)

    MiniMapTracking:Hide()
end

local function Nameplates()
    local U = UnitIsUnit
    hooksecurefunc("CompactUnitFrame_UpdateName", function(nameplate)
        if IsActiveBattlefieldArena() and nameplate.unit:find("nameplate") then
            for i = 1, 5 do
                if U(nameplate.unit, "arena" .. i) then
                    nameplate.name:SetText(i)
                    nameplate.name:SetTextColor(1, 1, 0)
                    break
                end
            end
        end
    end)

    C_NamePlate.SetNamePlateFriendlySize(100, 30)
    SetCVar("nameplateOccludedAlphaMult", 1)
end

local function ActionBars()
    local CurrentElement = "MainMenuBarArtFrame"
    _G[CurrentElement .. "Background"]:Hide()
    _G[CurrentElement].PageNumber:Hide()
    _G[CurrentElement].LeftEndCap:Hide()
    _G[CurrentElement].RightEndCap:Hide()

    hooksecurefunc(StanceBarFrame, "Show", function(self)
        self:Hide()
    end)

    ActionButton1:ClearAllPoints()
    ActionButton1:SetPoint('BOTTOM', _G[CurrentElement .. "Background"], -314, 100)

    CurrentElement = "MultiBarBottomRight"
    _G[CurrentElement .. "Button7"]:SetPoint("BOTTOMLEFT", _G[CurrentElement .. "Button1"], "TOPLEFT", 0, 10)
    UIPARENT_MANAGED_FRAME_POSITIONS[CurrentElement].xOffset = 6

    MainMenuBar.GetYOffset = function()
        return -100
    end
    UIParent_ManageFramePositions()

    CurrentElement = "MultiBarBottomLeft"
    _G[CurrentElement .. "Button1"]:SetPoint("BOTTOMLEFT", "ActionButton1", "TOPLEFT", 0, 10)
    UIPARENT_MANAGED_FRAME_POSITIONS[CurrentElement].xOffset = 6
    MainMenuBar.GetYOffset = function()
        return -30
    end

    UIParent_ManageFramePositions()

    MicroButtonAndBagsBar:Hide()
    CharacterMicroButton:ClearAllPoints()
    CharacterMicroButton:SetPoint("TOPLEFT", "MainMenuBar", -637, 14)
    CharacterMicroButton.SetPoint = function()
    end

    -- hide actionbar text
    for i = 1, 12 do
        _G["ActionButton" .. i .. "HotKey"]:SetAlpha(0)
        _G["ActionButton" .. i .. "Name"]:SetAlpha(0)

        _G["MultiBarBottomLeftButton" .. i .. "HotKey"]:SetAlpha(0)
        _G["MultiBarBottomLeftButton" .. i .. "Name"]:SetAlpha(0)

        _G["MultiBarBottomRightButton" .. i .. "HotKey"]:SetAlpha(0)
        _G["MultiBarBottomRightButton" .. i .. "Name"]:SetAlpha(0)

        _G["MultiBarRightButton" .. i .. "HotKey"]:SetAlpha(0)
        _G["MultiBarRightButton" .. i .. "Name"]:SetAlpha(0)

        _G["MultiBarLeftButton" .. i .. "HotKey"]:SetAlpha(0)
        _G["MultiBarLeftButton" .. i .. "Name"]:SetAlpha(0)
    end
end

local function UnitFrames()
    local ToTX = -108
    local ToTY = 13

    local elementsToHide = {PlayerFrame.name, PlayerLevelText}

    PlayerFrame:ClearAllPoints()
    PlayerFrame:SetPoint("LEFT", 200, 200)
    PlayerFrame.SetPoint = function()
    end

    TargetFrame:ClearAllPoints()
    TargetFrame:SetPoint("LEFT", PlayerFrame, "RIGHT", -5, 0)
    TargetFrameSpellBar:SetScale(1.1)

    for _, element in pairs(elementsToHide) do
        hooksecurefunc(element, "Show", function(s)
            s:Hide()
        end)

        element:Show()
    end
    TargetFrame.SetPoint = function()
    end

    TargetFrameToT:ClearAllPoints()
    TargetFrameToT:SetPoint("LEFT", TargetFrame, "BOTTOMRIGHT", ToTX, ToTY)
    TargetFrameToT.SetPoint = function()
    end

    FocusFrame:ClearAllPoints()
    FocusFrame:SetPoint("TOP", TargetFrame, "BOTTOM", 0, -100)
    FocusFrameSpellBar:SetScale(1.1)
    FocusFrame.SetPoint = function()
    end

    FocusFrameToT:ClearAllPoints()
    FocusFrameToT:SetPoint("LEFT", FocusFrame, "BOTTOMRIGHT", ToTX, ToTY)
    FocusFrameToT.SetPoint = function()
    end

end

local function Buffs()
    local function MoveBuffs()
        BuffFrame:ClearAllPoints()
        BuffFrame:SetPoint("TOPRIGHT", -250, -100)
    end

    hooksecurefunc("UIParent_UpdateTopFramePositions", MoveBuffs)
end

local function ClassColorHealthBars()
    local function ClassColor(statusbar, unit)
        if UnitIsPlayer(unit) and UnitIsConnected(unit) and unit == statusbar.unit and UnitClass(unit) then
            local _, class = UnitClass(unit)

            local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]

            statusbar:SetStatusBarColor(color.r, color.g, color.b)
        end
    end

    hooksecurefunc("UnitFrameHealthBar_Update", ClassColor)
    hooksecurefunc("HealthBar_OnValueChanged", function(self)
        ClassColor(self, self.unit)
    end)
end

local function UniframeBackgroundColor()
    local UnitframeBackgroundColorFrame = CreateFrame("FRAME")
    UnitframeBackgroundColorFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
    UnitframeBackgroundColorFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
    UnitframeBackgroundColorFrame:RegisterEvent("PLAYER_FOCUS_CHANGED")
    UnitframeBackgroundColorFrame:RegisterEvent("UNIT_FACTION")

    local function UnitFrameBackgroundColor(self, event, ...)
        if UnitIsPlayer("target") then
            local color = RAID_CLASS_COLORS[select(2, UnitClass("target"))]
            TargetFrameNameBackground:SetVertexColor(color.r, color.g, color.b)
        end

        if UnitIsPlayer("focus") then
            local color = RAID_CLASS_COLORS[select(2, UnitClass("focus"))]
            FocusFrameNameBackground:SetVertexColor(color.r, color.g, color.b)
        end

        if PlayerFrame:IsShown() and not PlayerFrame.bg then
            local color = RAID_CLASS_COLORS[select(2, UnitClass("player"))]
            local bg = PlayerFrame:CreateTexture()
            bg:SetPoint("TOPLEFT", PlayerFrameBackground)
            bg:SetPoint("BOTTOMRIGHT", PlayerFrameBackground, 0, 22)
            bg:SetTexture(TargetFrameNameBackground:GetTexture())
            bg:SetVertexColor(color.r, color.g, color.b)
            PlayerFrame.bg = true
        end
    end

    UnitframeBackgroundColorFrame:SetScript("OnEvent", UnitFrameBackgroundColor)

    for _, BarTextures in pairs({TargetFrameNameBackground, FocusFrameNameBackground}) do
        BarTextures:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
    end
end

local function CombatIndicator()
    local CombatIndicatorTargetFrame = CreateFrame("Frame")
    CombatIndicatorTargetFrame:SetParent(TargetFrame)
    CombatIndicatorTargetFrame:SetPoint("Right", TargetFrame, -16, 7)
    CombatIndicatorTargetFrame:SetSize(30, 30)
    CombatIndicatorTargetFrame.t = CombatIndicatorTargetFrame:CreateTexture(nil, BORDER)
    CombatIndicatorTargetFrame.t:SetAllPoints()
    CombatIndicatorTargetFrame.t:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")
    CombatIndicatorTargetFrame:Hide()

    local function FrameOnUpdateTarget(self)
        if UnitAffectingCombat("target") and UnitIsPlayer then
            self:Show()
        else
            self:Hide()
        end
    end

    local OnUpdateFrameTarget = CreateFrame("Frame")
    OnUpdateFrameTarget:SetScript("OnUpdate", function(self)
        FrameOnUpdateTarget(CombatIndicatorTargetFrame)
    end)

    local CombatIndicatorFocusFrame = CreateFrame("Frame")
    CombatIndicatorFocusFrame:SetParent(FocusFrame)
    CombatIndicatorFocusFrame:SetPoint("Right", FocusFrame, -16, 7)
    CombatIndicatorFocusFrame:SetSize(30, 30)
    CombatIndicatorFocusFrame.t = CombatIndicatorFocusFrame:CreateTexture(nil, BORDER)
    CombatIndicatorFocusFrame.t:SetAllPoints()
    CombatIndicatorFocusFrame.t:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")
    CombatIndicatorFocusFrame:Hide()

    local function FrameOnUpdateFocus(self)
        if UnitAffectingCombat("focus") and UnitIsPlayer then
            self:Show()
        else
            self:Hide()
        end
    end

    local OnUpdateFrameFocus = CreateFrame("Frame")
    OnUpdateFrameFocus:SetScript("OnUpdate", function(self)
        FrameOnUpdateFocus(CombatIndicatorFocusFrame)
    end)
end

local function UnitframeBigBuffs()
    local spellIds = {
        [185422] = true,
        [108208] = true,
        [345231] = true,
        [97462] = true,
        [3411] = true,
        [197690] = true
    }

    local buffBigSize = 28
    local buffStandardSize = 20

    hooksecurefunc("TargetFrame_UpdateBuffAnchor", function(_, name, i)
        if name == "TargetFrameBuff" then
            local buffname, _, _, _, _, _, _, _, _, spellId = UnitBuff("target", i)
            if spellIds[buffname] or spellIds[spellId] then
                _G[name .. i]:SetSize(buffBigSize, buffBigSize) -- Set Size if BIGfrom table
            else
                _G[name .. i]:SetSize(buffStandardSize, buffStandardSize) -- Standard Size
            end
        end
    end)

    hooksecurefunc("TargetFrame_UpdateDebuffAnchor", function(_, name, i)
        if name == "TargetFrameDebuff" then
            local buffname, _, _, _, _, _, _, _, _, spellId = UnitDebuff("target", i)
            if spellIds[buffname] or spellIds[spellId] then
                _G[name .. i]:SetSize(buffBigSize, buffBigSize) -- Set Size if BIGfrom table
            else
                _G[name .. i]:SetSize(buffStandardSize, buffStandardSize) -- Standard Size
            end
        end
    end)

    hooksecurefunc("TargetFrame_UpdateBuffAnchor", function(_, name, i)
        if name == "FocusFrameBuff" then
            local buffname, _, _, _, _, _, _, _, _, spellId = UnitBuff("focus", i)
            if spellIds[buffname] or spellIds[spellId] then
                _G[name .. i]:SetSize(buffBigSize, buffBigSize) -- Set Size if BIGfrom table
            else
                _G[name .. i]:SetSize(buffStandardSize, buffStandardSize) -- Standard Size
            end
        end
    end)

    hooksecurefunc("TargetFrame_UpdateDebuffAnchor", function(_, name, i)
        if name == "FocusFrameDebuff" then
            _G[name .. i]:SetSize(buffBigSize, buffBigSize)
            local buffname, _, _, _, _, _, _, _, _, spellId = UnitDebuff("focus", i)
            if spellIds[buffname] or spellIds[spellId] then
                _G[name .. i]:SetSize(buffBigSize, buffBigSize) -- Set Size if BIGfrom table
            else
                _G[name .. i]:SetSize(buffStandardSize, buffStandardSize) -- Standard Size
            end
        end
    end)
end

function Addon:Load()
    MinimapCleanup()
    Buffs()
    ActionBars()
    UnitFrames()
    ClassColorHealthBars()
    UniframeBackgroundColor()
    UnitframeBigBuffs()
    CombatIndicator()

    -- Too bright
    ConsoleExec("ffxglow 0")

    -- Damage: 3,123 -> 3123
    SetCVar('BreakUpLargeNumbers', 0)

    -- SetCVar("SHOW_ARENA_ENEMY_FRAMES_TEXT", 1)
    -- SetCVar("ShowArenaEnemyFrames", 1)

    -- PvP Icons
    PlayerPVPIcon:SetAlpha(0)
    TargetFrameTextureFramePVPIcon:SetAlpha(0)
    FocusFrameTextureFramePVPIcon:SetAlpha(0)

    -- Chat alert bell
    QuickJoinToastButton:SetAlpha(0)

    -- Small Friendly Nameplates
    C_NamePlate.SetNamePlateFriendlySize(60, 60)

    -- Prestige Icons
    PlayerPrestigeBadge:SetAlpha(0)
    PlayerPrestigePortrait:SetAlpha(0)
    TargetFrameTextureFramePrestigeBadge:SetAlpha(0)
    TargetFrameTextureFramePrestigePortrait:SetAlpha(0)
    FocusFrameTextureFramePrestigeBadge:SetAlpha(0)
    FocusFrameTextureFramePrestigePortrait:SetAlpha(0)

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

local main = CreateFrame("Frame")
main:RegisterEvent("PLAYER_ENTERING_WORLD")
main:SetScript("OnEvent", function(self)
    Addon:Load()
    self:UnregisterAllEvents()
end)
