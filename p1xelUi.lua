local addonName, p1xelUI = ...

p1xelUI.modules = {}

local eventHandler = CreateFrame("Frame", nil, UIParent)
eventHandler:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, ...)
end)
eventHandler:RegisterEvent("ADDON_LOADED")

function p1xelUI:CreateModule(m)
    p1xelUI.modules[m] = {}
    return p1xelUI.modules[m]
end

local function startUI()
    for m, _ in pairs(p1xelUI.modules) do
        if p1xelUI.modules[m].OnLoad then
            p1xelUI.modules[m]:OnLoad()
        end
    end
    print("p1xelUI loaded")
end

function eventHandler:ADDON_LOADED(addon)
    if addon ~= addonName then
        return
    else
        startUI()
    end
end
