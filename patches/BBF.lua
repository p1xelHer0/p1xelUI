local function ShowLastNameOnlyNpc(frame)
    local info = frame.BetterBlizzPlates.unitInfo or GetNameplateUnitInfo(frame)
    if not info then return end

    if info.isNpc then
        local name = info.name
        local letters, lastWord = "", strmatch(name, ".+%s(.+)$")

        if lastWord then
            for word in gmatch(name, ".-%s") do
                local firstLetter = string.utf8sub(gsub(word, "^[%s%p]*", ""), 1, 1)
                if firstLetter ~= string.utf8lower(firstLetter) then
                    letters = format("%s%s. ", letters, firstLetter)
                end
            end
            name = format("%s%s", letters, lastWord)

            if name then
                frame.name:SetText(name)
            end
        end
    end
end