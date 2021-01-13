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
    -- too bright
    ConsoleExec("ffxglow 0")

    -- damage: 3,123 -> 3123
    SetCVar('BreakUpLargeNumbers', 0)

    -- we use ElvUI for arena frames
    SetCVar("SHOW_ARENA_ENEMY_FRAMES_TEXT", 1)
    SetCVar("ShowArenaEnemyFrames", 1)
end

init()
