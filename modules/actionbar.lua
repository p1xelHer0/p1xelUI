local _, p1xelUi = ...
local m = p1xelUi:CreateModule("Actionbar")

local eventHandler = CreateFrame("Frame", nil, UIParent)
eventHandler:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, ...)
end)

function m:OnLoad()
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

    MicroButtonAndBagsBar:SetAlpha(0)
    CharacterMicroButton:ClearAllPoints()
    CharacterMicroButton:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 1, 1)

    ActionButton1:ClearAllPoints()
    ActionButton1:SetPoint('BOTTOM', MainMenuBarArtFrameBackground, -314, 60)

    MultiBarBottomLeftButton1:ClearAllPoints()
    MultiBarBottomLeftButton1:SetPoint("BOTTOMLEFT", "ActionButton1", "TOPLEFT", 0, 6)

    MultiBarBottomRightButton1:ClearAllPoints()
    MultiBarBottomRightButton1:SetPoint("LEFT", ActionButton12, "CENTER", 23, 0)
    MultiBarBottomRightButton7:ClearAllPoints()
    MultiBarBottomRightButton7:SetPoint("LEFT", MultiBarBottomLeftButton12, "CENTER", 23, 0)

    -- Hide XP Bar. Don't touch MainMenuBar it's evil
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

    -- Fix position of pet bar
    local petAnchor = CreateFrame("Frame", nil, PetActionBarFrame)
    petAnchor:SetSize(509, 43)
    for i = 1, 10 do
        local button = _G["PetActionButton" .. i]
        button:ClearAllPoints()
        if i == 1 then
            button:SetPoint("BOTTOMLEFT", petAnchor, "BOTTOMLEFT", 36, 2)
        else
            button:SetPoint("LEFT", "PetActionButton" .. i - 1, "RIGHT", 8, 0)
        end
    end

    -- Fix position of stance bar
    StanceBarFrame.ignoreFramePositionManager = true
    StanceBarFrame:SetAlpha(0)

    hooksecurefunc("UIParent_ManageFramePosition", function(index)
        if InCombatLockdown() then
            return
        end

        if index == "PETACTIONBAR_YPOS" then
            petAnchor:SetPoint("BOTTOMLEFT", MainMenuBarArtFrameBackground, "TOPLEFT", 30,
                SHOW_MULTI_ACTIONBAR_1 and 60 or -2)
        elseif index == "StanceBarFrame" then
            StanceBarFrame:SetPoint("BOTTOMLEFT", MainMenuBarArtFrameBackground, "TOPLEFT", 30,
                SHOW_MULTI_ACTIONBAR_1 and 60 or -2)
        end
    end)

    -- Fix texture size on stance bar when bottom left bar is disabled
    local sizeHook = false

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
    end

    self.buttons = {}
    for i = 1, 12 do
        tinsert(self.buttons, _G["ActionButton" .. i])
        tinsert(self.buttons, _G["MultiBarBottomLeftButton" .. i])
        tinsert(self.buttons, _G["MultiBarBottomRightButton" .. i])
        tinsert(self.buttons, _G["MultiBarLeftButton" .. i])
        tinsert(self.buttons, _G["MultiBarRightButton" .. i])
    end

    local function updateHotkeys(self)
        self.HotKey:Hide()
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

    self:HideXPBar(true)
    self:HideArrows(true)
    self:HideHotkeys(true)
    self:HideMacroNames(true)
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
