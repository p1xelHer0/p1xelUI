local addonName, p1xelUI = ...

p1xelUI.modules = {}

local eventHandler = CreateFrame("Frame", nil, UIParent)
eventHandler:SetScript("OnEvent", function(self, event, ...)
    return self[event](self, ...)
end)
eventHandler:RegisterEvent("ADDON_LOADED")

function p1xelUI:CreateModule(module)
    p1xelUI.modules[module] = {}
    return p1xelUI.modules[module]
end

local function loadAllModules()
    for module, _ in pairs(p1xelUI.modules) do
        if p1xelUI.modules[module].OnLoad then
            print("Loading module: " .. module)
            p1xelUI.modules[module]:OnLoad()
        end
    end
end

function eventHandler:ADDON_LOADED(addon)
    if addon ~= addonName then
        return
    else
        loadAllModules()
    end
end

