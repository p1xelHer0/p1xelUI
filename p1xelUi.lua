local addonName, p1xelUi = ...

p1xelUi.modules = {}

local eventHandler = CreateFrame("Frame", nil, UIParent)
eventHandler:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, ...)
end)
eventHandler:RegisterEvent("ADDON_LOADED")

function p1xelUi:CreateModule(m)
    p1xelUi.modules[m] = {}
    return p1xelUi.modules[m]
end

local function startUi()
    for m, _ in pairs(p1xelUi.modules) do
        if p1xelUi.modules[m].OnLoad then
            p1xelUi.modules[m]:OnLoad()
        end
    end
    print("p1xelUi loaded")
end

function eventHandler:ADDON_LOADED(addon)
    if addon ~= addonName then
        return
    else
        startUi()
    end
end
