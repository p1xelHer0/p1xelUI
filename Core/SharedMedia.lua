local _, p1xelUI = ...
local M = p1xelUI:CreateModule("SharedMedia")

local eventHandler = CreateFrame("Frame", nil, UIParent)
eventHandler:SetScript("OnEvent", function(self, event, ...)
  return self[event](self, ...)
end)

function M:OnLoad()
  self:SetupMedia()
end

function M:SetupMedia()
  local LSM = LibStub("LibSharedMedia-3.0")
  local p1xelText = "|cff30d5acp|cff26b5951|cff1e977ex|cff187967e|cff145d50l|cffffffff"
  local COLOR_RESET = "|r"

  if LSM == nil then
    return
  end

  -- Fonts
  LSM:Register(
    "font",
    p1xelText .. COLOR_RESET,
    [[Interface\AddOns\p1xelUI\Media\Fonts\Expressway_Free.ttf]]
  )
  -- LSM:Register(
  --   "font",
  --   p1xelText .. "Large" .. COLOR_RESET,
  --   [[Interface\Addons\p1xelUI\Media\Fonts\Homespun.ttf]]
  -- )
  -- LSM:Register(
  --   "font",
  --   p1xelText .. "Regular" .. COLOR_RESET,
  --   [[Interface\Addons\p1xelUI\Media\Fonts\Barlow_SemiCondensed_SemiBold.ttf]]
  -- )
  -- LSM:Register(
  --   "font",
  --   p1xelText .. "Bold" .. COLOR_RESET,
  --   [[Interface\Addons\p1xelUI\Media\Fonts\Barlow_SemiCondensed_Black.ttf]]
  -- )

  -- StatusBars
  LSM:Register(
    "statusbar",
    p1xelText .. COLOR_RESET,
    [[Interface\AddOns\p1xelUI\Media\StatusBar\StatusBar.tga]]
  )
  LSM:Register(
    "statusbar",
    p1xelText .. "Blank" .. COLOR_RESET,
    [[Interface\AddOns\p1xelUI\Media\StatusBar\White8x8.tga]]
  )

end
