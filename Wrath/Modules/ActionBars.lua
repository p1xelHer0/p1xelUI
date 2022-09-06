local _, p1xelUI = ...
local m = p1xelUI:CreateModule("ActionBars")

local eventHandler = CreateFrame("Frame", nil, UIParent)
eventHandler:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, ...)
end)

local hideArrows = true

local hideHotkeys = true
local hideMacroNames = true

function m:OnLoad()
    local actionBarScale = 1.0

    -- Hide artwork
    MainMenuBarRightEndCap:Hide()
    MainMenuBarLeftEndCap:Hide()

    for i = 0, 3 do
        _G["MainMenuBarTexture" .. i]:Hide()
        _G["MainMenuMaxLevelBar" .. i]:Hide()
    end

    StanceBarLeft:SetAlpha(0)
    StanceBarRight:SetAlpha(0)
    StanceBarMiddle:SetAlpha(0)
    SlidingActionBarTexture0:SetAlpha(0)
    SlidingActionBarTexture1:SetAlpha(0)

    -- Move ActionBars
    ActionButton1:ClearAllPoints()

    -- Actual position of ActionBar is set in `MoveRelativeToEnabledBars`
    ActionButton1:SetPoint('BOTTOM', MainMenuBarArtFrameBackground, -314, 10)

    -- Make ActionBars bigger
    for i = 1, 12 do
        _G["ActionButton" .. i]:SetScale(actionBarScale)
        _G["MultiBarBottomLeftButton" .. i]:SetScale(actionBarScale)
        _G["MultiBarBottomRightButton" .. i]:SetScale(actionBarScale)
        _G["MultiBarLeftButton" .. i]:SetScale(actionBarScale)
        _G["MultiBarRightButton" .. i]:SetScale(actionBarScale)
    end

    MainMenuBarBackpackButton:ClearAllPoints()
    MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)

    for i = 0, 3 do
      _G["CharacterBag".. i .. "Slot"]:ClearAllPoints()
      _G["CharacterBag".. i .. "Slot"]:SetPoint("RIGHT", MainMenuBarBackpackButton, "LEFT", -37 * i, 0)
    end

    KeyRingButton:ClearAllPoints()
    KeyRingButton:SetPoint("RIGHT", CharacterBag3Slot, "LEFT", 0, 0)

    MainMenuBarPerformanceBar:ClearAllPoints()
    MainMenuBarPerformanceBar:SetPoint("RIGHT", KeyRingButton, "LEFT", 0, 0)
    MainMenuBarPerformanceBar:SetAlpha(0)

    MainMenuBarPerformanceBarFrameButton:ClearAllPoints()
    MainMenuBarPerformanceBarFrameButton:SetPoint("RIGHT", KeyRingButton, "LEFT", 0, 0)

    CharacterMicroButton:ClearAllPoints()
    CharacterMicroButton:SetPoint("BOTTOMRIGHT", KeyRingButton, "TOPLEFT", 23, -1)


    MultiBarBottomLeftButton1:ClearAllPoints()
    MultiBarBottomLeftButton1:SetPoint("BOTTOMLEFT", "ActionButton1", "TOPLEFT", 0, 6)

    MultiBarBottomRightButton1:ClearAllPoints()

    MultiBarBottomRightButton1:SetPoint("LEFT", ActionButton12, "CENTER", 23, 0)
    MultiBarBottomRightButton7:ClearAllPoints()
    MultiBarBottomRightButton7:SetPoint("LEFT", MultiBarBottomLeftButton12, "CENTER", 23, 0)

    -- MainMenuBar blocks click action on some moved buttons
    -- MainMenuBar:EnableMouse(false)

    -- UIParent_ManageFramePosition will ignore a frame if it's user-placed
    -- MultiBarBottomLeft:SetMovable(true)
    -- MultiBarBottomLeft:SetUserPlaced(true)

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

    -- Castbar
    CastingBarFrame.ignoreFramePositionManager = true
    CastingBarFrame:ClearAllPoints()
    CastingBarFrame:SetPoint("BOTTOM", 0, 260)
    CastingBarFrame:SetScale(1.2)

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

    local function MoveRelativeToEnabledBars(index)
        -- Move Main Action Bar to middle
        local mainBarXPos = SHOW_MULTI_ACTIONBAR_2 and -315 or -231

        -- Move Pet X position if Bottom Right Bar is enabled
        local petXPos = SHOW_MULTI_ACTIONBAR_1 and SHOW_MULTI_ACTIONBAR_2 and 161 * actionBarScale or 77 * actionBarScale

        -- Move Pet Y position if Bottom Left Bar is enabled
        local petYPos = SHOW_MULTI_ACTIONBAR_1 and 53 * actionBarScale or 10 * actionBarScale

        -- Move Stance Y is Bottom Left Bar is enabled
        local stanceYPos = SHOW_MULTI_ACTIONBAR_1 and 48 * actionBarScale or 5 * actionBarScale

        local xpBarScale = SHOW_MULTI_ACTIONBAR_2 and 0.65 or 0.49

        MainMenuExpBar:SetScale(xpBarScale)
        ReputationWatchBar.StatusBar:SetScale(xpBarScale)

        if index == "PETACTIONBAR_YPOS" then
            PetActionButton1:SetPoint("BOTTOMLEFT", ActionButton1, "TOPLEFT", petXPos, petYPos)
            ActionButton1:SetPoint('BOTTOM', MainMenuBarArtFrameBackground, mainBarXPos, 54)
        elseif index == "StanceBarFrame" then
            StanceButton1:SetPoint("BOTTOMLEFT", ActionButton1, "TOP", 10, stanceYPos)
        end
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
        -- hooksecurefunc(button, "UpdateHotkeys", updateHotkeys)
    end

    -- hooksecurefunc("ActionButton_UpdateRangeIndicator", updateHotkeys)
    -- hooksecurefunc("PetActionButton_SetHotkeys", updateHotkeys)

    _G["MultiBarBottomRightButton5"]:SetAlpha(0)
    _G["MultiBarBottomRightButton6"]:SetAlpha(0)
    _G["MultiBarBottomRightButton11"]:SetAlpha(0)
    _G["MultiBarBottomRightButton12"]:SetAlpha(0)

    self:HideArrows(hideArrows)
    self:HideHotkeys(hideHotkeys)
    self:HideMacroNames(hideMacroNames)
    self:HideMicroMenuAndBags()
    self:HideExtraActionBars()
    self:HideXPBar()
end

function eventHandler:PLAYER_LOGIN()
    if InCombatLockdown() then
        return
    end

    -- moving the bar here because PLAYER_LOGIN is called after layout-local.txt settings
    MultiBarBottomLeft:ClearAllPoints()
    MultiBarBottomLeft:SetPoint("BOTTOMLEFT", ActionButton1, "TOPLEFT", 0, 6)
end

function m:HideArrows(hide)
    ActionBarDownButton:SetAlpha(hide and 0 or 1)
    ActionBarUpButton:SetAlpha(hide and 0 or 1)
    MainMenuBarPageNumber:SetAlpha(hide and 0 or 1)

    ActionBarUpButton:ClearAllPoints()
    ActionBarUpButton:SetPoint("RIGHT", ActionButton1, "LEFT", 0, 10)

    ActionBarDownButton:ClearAllPoints()
    ActionBarDownButton:SetPoint("TOP", ActionBarUpButton, "BOTTOM", 0, 9)

    MainMenuBarPageNumber:ClearAllPoints()
    MainMenuBarPageNumber:SetPoint("TOPRIGHT", ActionBarUpButton, "LEFT", 0, -4)
end

function m:HideHotkeys(hide)
    for _, button in ipairs(self.buttons) do
        -- button:UpdateHotkeys(button.buttonType)
    end
    for i = 1, 10 do
        -- PetActionButton_SetHotkeys(_G["PetActionButton" .. i])
    end
end

function m:HideMacroNames(hide)
    for _, button in ipairs(self.buttons) do
        button.Name:SetShown(not hide)
    end
end

function m:HideMicroMenuAndBags()
    local showOnHover = {
      "MainMenuBarBackpackButton",
      "CharacterBag0Slot",
      "CharacterBag1Slot",
      "CharacterBag2Slot",
      "CharacterBag3Slot",
      "KeyRingButton",

      "CharacterMicroButton",
      "SpellbookMicroButton",
      "AchievementMicroButton",
      "TalentMicroButton",
      "QuestLogMicroButton",
      "SocialsMicroButton",
      "LFGMicroButton",
      "MainMenuMicroButton",
      -- "PvPMicroButton",
    }

    local function showElement(self)
        for _, v in ipairs(showOnHover) do
            _G[v]:SetAlpha(100)
        end
    end

    local function hideElement(self)
        for _, v in ipairs(showOnHover) do
            _G[v]:SetAlpha(0)
        end
    end

    for _, v in ipairs(showOnHover) do
        v = _G[v]
        v:SetScript("OnEnter", showElement)
        v:SetScript("OnLeave", hideElement)
        v:SetAlpha(0)
    end
end

function m:HideExtraActionBars()
    local showOnHover = {
      "MultiBarLeft",
      "MultiBarRight",
      "MultiBarLeftButton1",
      "MultiBarLeftButton2",
      "MultiBarLeftButton3",
      "MultiBarLeftButton4",
      "MultiBarLeftButton5",
      "MultiBarLeftButton6",
      "MultiBarLeftButton7",
      "MultiBarLeftButton8",
      "MultiBarLeftButton9",
      "MultiBarLeftButton10",
      "MultiBarLeftButton11",
      "MultiBarLeftButton12",
      "MultiBarRightButton1",
      "MultiBarRightButton2",
      "MultiBarRightButton3",
      "MultiBarRightButton4",
      "MultiBarRightButton5",
      "MultiBarRightButton6",
      "MultiBarRightButton7",
      "MultiBarRightButton8",
      "MultiBarRightButton9",
      "MultiBarRightButton10",
      "MultiBarRightButton11",
      "MultiBarRightButton12"
    }

    local function showElement(self)
        for _, v in ipairs(showOnHover) do
            _G[v]:SetAlpha(100)
        end
    end

    local function hideElement(self)
        for _, v in ipairs(showOnHover) do
            _G[v]:SetAlpha(0)
        end
    end

    for _, v in ipairs(showOnHover) do
        v = _G[v]
        v:SetScript("OnEnter", showElement)
        v:SetScript("OnLeave", hideElement)
        v:SetAlpha(0)
    end
end

function m:HideXPBar()
    local showOnHover = {"MainMenuExpBar"}

    local function showElement(self)
        for _, v in ipairs(showOnHover) do
            _G[v]:SetAlpha(100)
        end
    end

    local function hideElement(self)
        for _, v in ipairs(showOnHover) do
            _G[v]:SetAlpha(0)
        end
    end

    for _, v in ipairs(showOnHover) do
        v = _G[v]
        v:SetScript("OnEnter", showElement)
        v:SetScript("OnLeave", hideElement)
        v:SetAlpha(0)
    end
end
