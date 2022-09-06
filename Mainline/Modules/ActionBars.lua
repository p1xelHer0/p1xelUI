local _, p1xelUI = ...
local m = p1xelUI:CreateModule("ActionBars")

local eventHandler = CreateFrame("Frame", nil, UIParent)
eventHandler:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, ...)
end)

local hideArrows = true
local hideXPBar = true

local hideHotkeys = true
local hideMacroNames = true

function m:OnLoad()
    local actionBarScale = 1.0

    -- Hide artwork
    MainMenuBarArtFrameBackground.BackgroundSmall:SetAlpha(0)
    MainMenuBarArtFrameBackground.BackgroundLarge:SetAlpha(0)
    MainMenuBarArtFrameBackground.QuickKeybindGlowLarge:SetAlpha(0)
    MainMenuBarArtFrameBackground.QuickKeybindGlowSmall:SetAlpha(0)
    MultiBarBottomLeft.QuickKeybindGlow:SetAlpha(0)
    MultiBarBottomRight.QuickKeybindGlow:SetAlpha(0)
    MainMenuBarArtFrame.RightEndCap:Hide()
    MainMenuBarArtFrame.LeftEndCap:Hide()
    MainMenuBarArtFrame.PageNumber:Hide()
    StanceBarLeft:SetAlpha(0)
    StanceBarRight:SetAlpha(0)
    StanceBarMiddle:SetAlpha(0)
    SlidingActionBarTexture0:SetAlpha(0)
    SlidingActionBarTexture1:SetAlpha(0)

    -- Make ActionBars bigger
    for i = 1, 12 do
        _G["ActionButton" .. i]:SetScale(actionBarScale)
        _G["MultiBarBottomLeftButton" .. i]:SetScale(actionBarScale)
        _G["MultiBarBottomRightButton" .. i]:SetScale(actionBarScale)
        -- _G["MultiBarLeftButton" .. i]:SetScale(actionBarScale)
        -- _G["MultiBarRightButton" .. i]:SetScale(actionBarScale)
    end

    -- Move ActionBars
    ActionButton1:ClearAllPoints()

    -- Actual position of ActionBar is set in `MoveRelativeToEnabledBars`
    ActionButton1:SetPoint('BOTTOM', MainMenuBarArtFrameBackground, -314, 10)

    MultiBarBottomLeftButton1:ClearAllPoints()
    MultiBarBottomLeftButton1:SetPoint("BOTTOMLEFT", "ActionButton1", "TOPLEFT", -26, 12)

    MultiBarBottomRightButton1:ClearAllPoints()

    MultiBarBottomRightButton1:SetPoint("LEFT", ActionButton12, "CENTER", 23, 0)
    MultiBarBottomRightButton7:ClearAllPoints()
    MultiBarBottomRightButton7:SetPoint("LEFT", MultiBarBottomLeftButton12, "CENTER", 23, 0)

    -- Don't touch MainMenuBar it's evil
    MainMenuBarArtFrameBackground:ClearAllPoints()
    MainMenuBarArtFrameBackground:SetPoint("LEFT", MainMenuBar)

    hooksecurefunc(StatusTrackingBarManager, "LayoutBar", function(self, bar)
        bar:SetPoint("BOTTOM", MainMenuBarArtFrameBackground, 0, select(5, bar:GetPoint()));
    end)

    -- MainMenuBar blocks click action on some moved buttons
    MainMenuBar:EnableMouse(false)

    -- UIParent_ManageFramePosition will ignore a frame if it's user-placed
    MultiBarBottomLeft:SetMovable(true)
    MultiBarBottomLeft:SetUserPlaced(true)

    -- Pet ActionBar
    for i = 1, 10 do
        local button = _G["PetActionButton" .. i]
        button:ClearAllPoints()
        if i == 1 then
            -- Actual position of PetBar is set in `MoveRelativeToEnabledBars`
            button:SetPoint("BOTTOMLEFT", ActionButton1, "BOTTOMLEFT", 0, 0)
        else
            -- Spacing of PetBars
            button:SetPoint("LEFT", "PetActionButton" .. i - 1, "RIGHT", 5, 0)
        end
    end

    -- Bigger important abilities
    for i = 7, 10 do
        _G["MultiBarBottomLeftButton" .. i]:SetScale(1.3)
    end

    -- Extra Action Bar
    ExtraActionButton1:ClearAllPoints()
    ExtraActionButton1:SetPoint("TOP", PlayerPowerBarAlt, "BOTTOM", 0, -20)

    -- Castbar
    CastingBarFrame.ignoreFramePositionManager = true
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetPoint("BOTTOM", 0, 255)
    CastingBarFrame:SetScale(1.2)

    -- Alternative PowerBar
    PlayerPowerBarAlt.ignoreFramePositionManager = true -- optional but sometimes helpful for Blizzard frames
    PlayerPowerBarAlt:SetMovable(true)
    PlayerPowerBarAlt:SetUserPlaced(true)
    PlayerPowerBarAlt:ClearAllPoints()
    PlayerPowerBarAlt:SetPoint("TOP", "CastingBarFrame", "BOTTOM", 0, -20)
    PlayerPowerBarAlt:SetMovable(false)

    StanceButton1:ClearAllPoints()

    -- Hide StanceBar texture when Bottom Left Bar is hidden
    local sizeHook = false

    -- Create textures for each Stance Button to make it look good
    local function widthFunc(self)
        if sizeHook then
            return
        end
        sizeHook = true
        self:SetWidth(52)
        sizeHook = false
    end

    local function heightFunc(self)
        if sizeHook then
            return
        end
        sizeHook = true
        self:SetHeight(52)
        sizeHook = false
    end

    for i = 1, NUM_STANCE_SLOTS do
        hooksecurefunc(_G["StanceButton" .. i]:GetNormalTexture(), "SetWidth", widthFunc)
        hooksecurefunc(_G["StanceButton" .. i]:GetNormalTexture(), "SetHeight", heightFunc)
        local button = _G["StanceButton" .. i]
        button:ClearAllPoints()
        if i == 1 then
            -- StanceButton start
            button:SetPoint("BOTTOMLEFT", ActionButton1, "BOTTOMLEFT", 0, 0)
        else
            -- Rest of Pet StanceButtons, space etc
            button:SetPoint("LEFT", "StanceButton" .. i - 1, "RIGHT", 4, 0)
        end
    end

    CharacterMicroButton:ClearAllPoints()
    CharacterMicroButton:SetPoint("BOTTOM", -130, -30)

    local function MoveRelativeToEnabledBars(index)
        -- Move Main Action Bar to middle
        local mainBarXPos = SHOW_MULTI_ACTIONBAR_2 and -315 or -231

        -- Move Pet X position if Bottom Right Bar is enabled
        local petXPos = SHOW_MULTI_ACTIONBAR_1 and SHOW_MULTI_ACTIONBAR_2 and 161 * actionBarScale or 77 * actionBarScale

        -- Move Pet Y position if Bottom Left Bar is enabled
        local petYPos = SHOW_MULTI_ACTIONBAR_1 and 53 * actionBarScale or 10 * actionBarScale

        -- Move Stance Y is Bottom Left Bar is enabled
        local stanceYPos = SHOW_MULTI_ACTIONBAR_1 and 55 * actionBarScale or 7 * actionBarScale

        if index == "PETACTIONBAR_YPOS" then
            PetActionButton1:SetPoint("BOTTOMLEFT", ActionButton1, "TOPLEFT", petXPos, petYPos)
            ActionButton1:SetPoint('BOTTOM', MainMenuBarArtFrameBackground, mainBarXPos, 10)
        elseif index == "StanceBarFrame" then
            StanceButton1:SetPoint("BOTTOMLEFT", ActionButton1, "TOP", 10, stanceYPos)
        end

        CharacterMicroButton:ClearAllPoints()
        CharacterMicroButton:SetPoint("BOTTOM", -130, -30)
    end

    -- Position ActionBars properly when enabling/disabling Extra ActionBars
    hooksecurefunc("UIParent_ManageFramePosition", function(index)
        if InCombatLockdown() then
            return
        end

        MoveRelativeToEnabledBars(index)
    end)

    self.buttons = {}
    for i = 1, 12 do
        tinsert(self.buttons, _G["ActionButton" .. i])
        tinsert(self.buttons, _G["MultiBarBottomLeftButton" .. i])
        tinsert(self.buttons, _G["MultiBarBottomRightButton" .. i])
        tinsert(self.buttons, _G["MultiBarLeftButton" .. i])
        tinsert(self.buttons, _G["MultiBarRightButton" .. i])
    end

    local function updateHotkeys(self)
        if (hideHotkeys) then
            self.HotKey:Hide(hideHotkeys)
        end
    end

    for _, button in pairs(self.buttons) do
        hooksecurefunc(button, "UpdateHotkeys", updateHotkeys)
    end

    hooksecurefunc("ActionButton_UpdateRangeIndicator", updateHotkeys)
    hooksecurefunc("PetActionButton_SetHotkeys", updateHotkeys)

    _G["MultiBarBottomRightButton5"]:SetAlpha(0)
    _G["MultiBarBottomRightButton6"]:SetAlpha(0)
    _G["MultiBarBottomRightButton11"]:SetAlpha(0)
    _G["MultiBarBottomRightButton12"]:SetAlpha(0)

    self:HideXPBar(hideXPBar)
    self:HideArrows(hideArrows)
    self:HideHotkeys(hideHotkeys)
    self:HideMacroNames(hideMacroNames)
    self:HideMicroMenuAndBags()
end

function eventHandler:PLAYER_LOGIN()
    if InCombatLockdown() then
        return
    end

    -- moving the bar here because PLAYER_LOGIN is called after layout-local.txt settings
    MultiBarBottomLeft:ClearAllPoints()
    MultiBarBottomLeft:SetPoint("BOTTOMLEFT", ActionButton1, "TOPLEFT", 0, 6)
end

function m:HideXPBar(hide)
    StatusTrackingBarManager:SetAlpha(hide and 0 or 1)
    MainMenuBarArtFrameBackground:SetPoint("BOTTOM", hide and UIParent or MainMenuBar, 0, hide and 3 or 0)
end

function m:HideArrows(hide)
    ActionBarDownButton:SetAlpha(hide and 0 or 1)
    ActionBarUpButton:SetAlpha(hide and 0 or 1)
end

function m:HideHotkeys(hide)
    for _, button in ipairs(self.buttons) do
        button:UpdateHotkeys(button.buttonType)
    end
    for i = 1, 10 do
        PetActionButton_SetHotkeys(_G["PetActionButton" .. i])
    end
end

function m:HideMacroNames(hide)
    for _, button in ipairs(self.buttons) do
        button.Name:SetShown(not hide)
    end
end

function m:HideMicroMenuAndBags()
    local ignore

    local function setAlpha(b, a)
        if ignore then
            return
        end

        ignore = true

        if b:IsMouseOver() then
            b:SetAlpha(100)
        else
            b:SetAlpha(0)
        end

        ignore = nil
    end

    local function showMicroButtons(self)
        for _, v in ipairs(MICRO_BUTTONS) do
            ignore = true
            _G[v]:SetAlpha(100)
            ignore = nil
        end
    end

    local function hideMicroButtons(self)
        for _, microButton in ipairs(MICRO_BUTTONS) do
            ignore = true
            _G[microButton]:SetAlpha(0)
            ignore = nil
        end
    end

    for _, microButton in ipairs(MICRO_BUTTONS) do
        microButton = _G[microButton]
        hooksecurefunc(microButton, "SetAlpha", setAlpha)
        microButton:HookScript("OnEnter", showMicroButtons)
        microButton:HookScript("OnLeave", hideMicroButtons)
        microButton:SetAlpha(0)
    end

    local t = {"MicroButtonAndBagsBar"}

    local function showFoo(self)
        for _, v in ipairs(t) do
            _G[v]:SetAlpha(100)
        end
    end

    local function hideFoo(self)
        for _, v in ipairs(t) do
            _G[v]:SetAlpha(0)
        end
    end

    for _, v in ipairs(t) do
        v = _G[v]
        v:SetScript("OnEnter", showFoo)
        v:SetScript("OnLeave", hideFoo)
        v:Hide(0)
    end
end
