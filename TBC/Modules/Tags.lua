local _, p1xelUI = ...
local m = p1xelUI:CreateModule("Tags")

local _, ns = ...

local eventHandler = CreateFrame("Frame", nil, UIParent)
eventHandler:SetScript("OnEvent", function(self, event, ...)
  return self[event](self, ...)
end)

function m:OnLoad()
  self:ElvUITags()
end

function m:ElvUITags() end
