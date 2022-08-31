local _, p1xelUI = ...
local m = p1xelUI:CreateModule("Unitframes")

local eventHandler = CreateFrame("Frame", nil, UIParent)
eventHandler:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, ...)
end)

function m:OnLoad()
    self:SetupUnitframes()
    self:EnableClassColorStatusBar()
    self:EnableClassColorNameBackground()
    self:EnableCombatIndicator()
    self:ColorTooltipName()
    -- self:EnableBigBuffs()
    self:RemoveTargetLevel()
end

function m:SetupUnitframes()
    local ToTX = -100
    local ToTY = 11

    local frameScale = 1.17
    local castbarScale = 1.29

    -- Player
    PlayerFrame:ClearAllPoints()
    PlayerFrame:SetPoint("CENTER", -520, 220)
    PlayerFrame:SetUserPlaced(true)
    PlayerFrame:SetScale(frameScale)

    -- Feedback text
    local feedbackText = PlayerFrame:CreateFontString(nil, "OVERLAY", "NumberFontNormalHuge")
    PlayerFrame.feedbackText = feedbackText
    PlayerFrame.feedbackStartTime = 0
    PlayerHitIndicator:Hide()
    PlayerLeaderIcon:SetAlpha(0)
    PetHitIndicator:Hide()
    PlayerFrame.name:SetAlpha(0)
    PlayerFrameGroupIndicator:SetAlpha(0)
    PlayerFrameRoleIcon:SetAlpha(0)
    PlayerPrestigeBadge:SetAlpha(0)
    PlayerPrestigePortrait:SetAlpha(0)
    PlayerPVPIcon:SetAlpha(0)

    PetFrame.feedbackText = feedbackText
    PetFrame.feedbackStartTime = 0
    PetName:SetAlpha(0)

    -- Target
    TargetFrame:ClearAllPoints()
    TargetFrame:SetPoint("LEFT", PlayerFrame, "RIGHT", -5, 0)
    TargetFrame:SetScale(frameScale)
    TargetFrame:SetUserPlaced(true)
    TargetFrameSpellBar:SetScale(castbarScale)
    TargetFrameTextureFramePVPIcon:SetAlpha(0)
    TargetFrameTextureFramePrestigeBadge:SetAlpha(0)
    TargetFrameTextureFramePrestigePortrait:SetAlpha(0)
    TargetFrameTextureFrameLeaderIcon:SetAlpha(0)

    -- Target of Target
    TargetFrameToT:ClearAllPoints()
    TargetFrameToT:SetPoint("LEFT", TargetFrame, "BOTTOMRIGHT", ToTX, ToTY)
    TargetFrameToT.name:SetAlpha(0)

    -- Focus
    FocusFrame:ClearAllPoints()
    FocusFrame:SetPoint("TOP", TargetFrame, "BOTTOM", 0, -129)
    FocusFrame:SetScale(frameScale)
    FocusFrame:SetUserPlaced(true)
    -- FocusFrame.name:SetAlpha(0)
    FocusFrameSpellBar:SetScale(castbarScale)
    FocusFrameTextureFramePVPIcon:SetAlpha(0)
    FocusFrameTextureFramePrestigeBadge:SetAlpha(0)
    FocusFrameTextureFramePrestigePortrait:SetAlpha(0)
    FocusFrameTextureFrameLeaderIcon:SetAlpha(0)

    -- Target of Focus
    FocusFrameToT:ClearAllPoints()
    FocusFrameToT:SetPoint("LEFT", FocusFrame, "BOTTOMRIGHT", ToTX, ToTY)
    FocusFrameToT.name:SetAlpha(0)
end

function m:RemoveTargetLevel()
    hooksecurefunc("TargetFrame_Update", function(target)
        if (UnitLevel(target.unit) == 60) and UnitIsPlayer(target.unit) then
            TargetFrameTextureFrameTexture:SetTexture("Interface/TargetingFrame/UI-TargetingFrame-NoLevel")
            TargetFrameTextureFrameLevelText:SetAlpha(0)
            FocusFrameTextureFrameTexture:SetTexture("Interface/TargetingFrame/UI-TargetingFrame-NoLevel")
            FocusFrameTextureFrameLevelText:SetAlpha(0)
        else
            TargetFrameTextureFrameTexture:SetTexture("Interface/TargetingFrame/UI-TargetingFrame")
            TargetFrameTextureFrameLevelText:SetAlpha(100)
            FocusFrameTextureFrameTexture:SetTexture("Interface/TargetingFrame/UI-TargetingFrame")
            FocusFrameTextureFrameLevelText:SetAlpha(100)
        end
    end)
end

function m:EnableClassColorStatusBar()
    eventHandler:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

    hooksecurefunc("UnitFrameHealthBar_Update", self.ColorStatusbar)
    hooksecurefunc("HealthBar_OnValueChanged", function(self)
        m.ColorStatusbar(self, self.unit)
    end)
end

local isTooltipStatusBar = _G.GameTooltipStatusBar
function eventHandler:UPDATE_MOUSEOVER_UNIT()
    m.ColorStatusbar(isTooltipStatusBar, "mouseover")
end

local UnitIsPlayer, UnitIsConnected, UnitClass, RAID_CLASS_COLORS = UnitIsPlayer, UnitIsConnected, UnitClass,
    RAID_CLASS_COLORS
local _, class, c

-- ClassColor statusbar for Tooltip and TargetofTargets
function m.ColorStatusbar(statusbar, unit)
    if UnitIsPlayer(unit) and UnitIsConnected(unit) and UnitClass(unit) then
        if unit == "targettarget" or unit == "focus-target" then
            _, class = UnitClass(unit)
            c = RAID_CLASS_COLORS[class]
            statusbar:SetStatusBarColor(c.r, c.g, c.b)
        end
    end
end

function m.ColorTooltipName()
  GameTooltip:HookScript("OnTooltipSetUnit", function(GameTooltip)
	local _, unit = GameTooltip:GetUnit()
	if UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		local color = class and (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
		if color then
			local text = GameTooltipTextLeft1:GetText()
			GameTooltipTextLeft1:SetFormattedText("|cff%02x%02x%02x%s|r", color.r * 255, color.g * 255, color.b * 255, text:match("|cff\x\x\x\x\x\x(.+)|r") or text)
		end
	end
    end)
end

function m:EnableClassColorNameBackground()
    local eventHandler = CreateFrame("FRAME", nil, UIParent)
    eventHandler:RegisterEvent("GROUP_ROSTER_UPDATE")
    eventHandler:RegisterEvent("PLAYER_TARGET_CHANGED")
    eventHandler:RegisterEvent("PLAYER_FOCUS_CHANGED")
    eventHandler:RegisterEvent("UNIT_FACTION")

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

    eventHandler:SetScript("OnEvent", UnitFrameBackgroundColor)

    for _, BarTextures in pairs({TargetFrameNameBackground, FocusFrameNameBackground}) do
        BarTextures:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
    end
end

-- Combat indicator
local combatIndicatorX = 96
local combatIndicatorY = -15
local combatIndicatorScale = 1
local combatIndicatorSize = 24
local combatIndicatorIcon = "Interface\\ICONS\\Ability_DualWield"

m.TargetCombatIndicator = CreateFrame("Frame", nil, TargetFrame)
m.TargetCombatIndicator:SetParent(TargetFrame)
m.TargetCombatIndicator:SetPoint("CENTER", TargetFrame, combatIndicatorX, combatIndicatorY)
m.TargetCombatIndicator:SetSize(combatIndicatorSize, combatIndicatorSize)
m.TargetCombatIndicator:SetScale(combatIndicatorScale)
m.TargetCombatIndicator.icon = m.TargetCombatIndicator:CreateTexture(nil, "BORDER")
m.TargetCombatIndicator.icon:SetAllPoints()
m.TargetCombatIndicator.icon:SetTexture(combatIndicatorIcon)
m.TargetCombatIndicator:Hide()

m.FocusCombatIndicator = CreateFrame("Frame", nil, FocusFrame)
m.FocusCombatIndicator:SetParent(FocusFrame)
m.FocusCombatIndicator:SetPoint("CENTER", FocusFrame, combatIndicatorX, combatIndicatorY)
m.FocusCombatIndicator:SetSize(combatIndicatorSize, combatIndicatorSize)
m.FocusCombatIndicator:SetScale(combatIndicatorScale)
m.FocusCombatIndicator.icon = m.FocusCombatIndicator:CreateTexture(nil, "BORDER")
m.FocusCombatIndicator.icon:SetAllPoints()
m.FocusCombatIndicator.icon:SetTexture(combatIndicatorIcon)
m.FocusCombatIndicator:Hide()

m.combatIndicatorElapsed = 0
local combatIndicatorUpdateInterval = 0.1
local UnitAffectingCombat = UnitAffectingCombat

function m.CombatIndicatorUpdate(_, elapsed)
    m.combatIndicatorElapsed = m.combatIndicatorElapsed + elapsed

    if m.combatIndicatorElapsed > combatIndicatorUpdateInterval then
        m.combatIndicatorElapsed = 0
        m.TargetCombatIndicator:SetShown(UnitAffectingCombat("target"))
        m.FocusCombatIndicator:SetShown(UnitAffectingCombat("focus"))
    end
end

function m:EnableCombatIndicator()
    eventHandler:SetScript("OnUpdate", self.CombatIndicatorUpdate)
end

function m:EnableBigBuffs()
    local spellIds = {
        [185422] = true, -- Shadow Dance
        [108208] = true, -- Subterfuge
        [345231] = true, -- Battlemaster
        [97462] = true, -- Rallying Cry
        [3411] = true, -- Intervene
        [197690] = true -- Defensive Stance
    }

    local buffBigSize = 28
    local buffStandardSize = 22

    hooksecurefunc("TargetFrame_UpdateBuffAnchor", function(_, name, i)
        if name == "TargetFrameBuff" then
            local buffname, _, _, _, _, _, _, _, _, spellId = UnitBuff("target", i)
            if spellIds[buffname] or spellIds[spellId] then
                _G[name .. i]:SetSize(buffBigSize, buffBigSize)
            else
                _G[name .. i]:SetSize(buffStandardSize, buffStandardSize)
            end
        end
    end)

    hooksecurefunc("TargetFrame_UpdateDebuffAnchor", function(_, name, i)
        if name == "TargetFrameDebuff" then
            local buffname, _, _, _, _, _, _, _, _, spellId = UnitDebuff("target", i)
            if spellIds[buffname] or spellIds[spellId] then
                _G[name .. i]:SetSize(buffBigSize, buffBigSize)
            else
                _G[name .. i]:SetSize(buffStandardSize, buffStandardSize)
            end
        end
    end)

    hooksecurefunc("TargetFrame_UpdateBuffAnchor", function(_, name, i)
        if name == "FocusFrameBuff" then
            local buffname, _, _, _, _, _, _, _, _, spellId = UnitBuff("focus", i)
            if spellIds[buffname] or spellIds[spellId] then
                _G[name .. i]:SetSize(buffBigSize, buffBigSize)
            else
                _G[name .. i]:SetSize(buffStandardSize, buffStandardSize)
            end
        end
    end)

    hooksecurefunc("TargetFrame_UpdateDebuffAnchor", function(_, name, i)
        if name == "FocusFrameDebuff" then
            _G[name .. i]:SetSize(buffBigSize, buffBigSize)
            local buffname, _, _, _, _, _, _, _, _, spellId = UnitDebuff("focus", i)
            if spellIds[buffname] or spellIds[spellId] then
                _G[name .. i]:SetSize(buffBigSize, buffBigSize)
            else
                _G[name .. i]:SetSize(buffStandardSize, buffStandardSize)
            end
        end
    end)
end
