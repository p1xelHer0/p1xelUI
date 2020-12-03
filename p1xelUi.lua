local E, L, V, P, G = unpack(ElvUI)
local name = "p1xelUi"
local mMT = E:NewModule(name, "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local EP = LibStub("LibElvUIPlugin-1.0")
local addon, ns = ...
local Version = GetAddOnMetadata(addon, "Version")

local ReloadUI = ReloadUI

-- SharedMedia
local LSM = LibStub("LibSharedMedia-3.0")

function init()
    ConsoleExec("ffxglow 0")
end

init()
