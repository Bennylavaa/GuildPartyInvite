local addonName = "GuildPartyInvite"
local defaultKeyword = "invite"
local keyword = defaultKeyword -- variable to store the keyword

-- Function to handle the CHAT_MSG_WHISPER event
local function GuildPartyInvite_OnWhisper(self, event, message, sender)

    if message and message:lower() == keyword then
        -- Update the guild roster to ensure accurate guild information
        GuildRoster()

        -- Check if the sender is in the same guild
        local playerName = UnitName("player")
        local senderIsInGuild = UnitIsInMyGuild(sender)
        local playerIsInGuild = UnitIsInMyGuild("player")

        if senderIsInGuild and playerIsInGuild then
            if senderIsInGuild == playerIsInGuild then
                -- Invite the sender to the party
                if not UnitInParty(sender) then
                    InviteUnit(sender)
                    print("Invited " .. sender .. " to the party.")
                else
                    print(sender .. " is already in the party.")
                end
            else
                print(sender .. " is not in the same guild.")
            end
        else
            print("They are not in a guild.")
        end
    end
end

-- Function to handle the CHAT_MSG_GUILD event
local function GuildPartyInvite_OnGuildChat(self, event, message, sender)
    if message and message:lower():find(keyword) then
        local playerName = UnitName("player")
        if playerName ~= sender then
            if IsInGuild() then
                if UnitIsInMyGuild(sender) then
                    local isInParty = UnitInParty(sender)
                    if not isInParty then
                        InviteUnit(sender)
                        print("Invited " .. sender .. " to the party.")
                    else
                        print(sender .. " is already in the party.")
                    end
                else
                    print(sender .. " is not in the same guild as you.")
                end
            else
                print("They are not in a guild.")
            end
        end
    end
end

-- Function to handle the CHAT_MSG_YELL event
local function GuildPartyInvite_OnYell(self, event, message, sender)

    if message and message:lower() == keyword then
        -- Update the guild roster to ensure accurate guild information
        GuildRoster()

        -- Check if the sender is in the same guild
        local playerName = UnitName("player")
        local senderIsInGuild = UnitIsInMyGuild(sender)
        local playerIsInGuild = UnitIsInMyGuild("player")

        if senderIsInGuild and playerIsInGuild then
            if senderIsInGuild == playerIsInGuild then
                -- Invite the sender to the party
                if not UnitInParty(sender) then
                    InviteUnit(sender)
                    print("Invited " .. sender .. " to the party.")
                else
                    print(sender .. " is already in the party.")
                end
            else
                print(sender .. " is not in the same guild.")
            end
        else
            print("They are not in a guild.")
        end
    end
end

-- Function to handle the CHAT_MSG_SAY event
local function GuildPartyInvite_OnSay(self, event, message, sender)

    if message and message:lower() == keyword then
        -- Update the guild roster to ensure accurate guild information
        GuildRoster()

        -- Check if the sender is in the same guild
        local playerName = UnitName("player")
        local senderIsInGuild = UnitIsInMyGuild(sender)
        local playerIsInGuild = UnitIsInMyGuild("player")

        if senderIsInGuild and playerIsInGuild then
            if senderIsInGuild == playerIsInGuild then
                -- Invite the sender to the party
                if not UnitInParty(sender) then
                    InviteUnit(sender)
                    print("Invited " .. sender .. " to the party.")
                else
                    print(sender .. " is already in the party.")
                end
            else
                print(sender .. " is not in the same guild.")
            end
        else
            print("They are not in a guild.")
        end
    end
end

-- Register the CHAT_MSG_SAY event handler
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", GuildPartyInvite_OnSay)

-- Register the CHAT_MSG_YELL event handler
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", GuildPartyInvite_OnYell)

-- Register the CHAT_MSG_WHISPER event handler
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", GuildPartyInvite_OnWhisper)

-- Register the CHAT_MSG_GUILD event handler
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", GuildPartyInvite_OnGuildChat)

-- Function to create GUI settings
local function CreateSettings()
    -- Define the UpdateEditBoxText function
    local function UpdateEditBoxText(editBox, text)
        editBox:SetText(text)
    end

    local panel = CreateFrame("Frame", addonName .. "SettingsPanel", UIParent)
    panel.name = addonName
    panel:Hide()

    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText(addonName .. " Settings")

    local keywordLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    keywordLabel:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -20)
    keywordLabel:SetText("Keyword:")

    local keywordEditBox = CreateFrame("EditBox", addonName .. "KeywordEditBox", panel, "InputBoxTemplate")
    keywordEditBox:SetWidth(150)
    keywordEditBox:SetHeight(20)
    keywordEditBox:SetPoint("TOPLEFT", keywordLabel, "BOTTOMLEFT", 0, -5)
    
    -- Retrieve the keyword from saved variables file
    local savedKeyword = GuildPartyInviteDB and GuildPartyInviteDB.defaultKeyword
    
    -- Set the initial value of the edit box to the saved keyword or the default keyword if not found
    UpdateEditBoxText(keywordEditBox, savedKeyword or defaultKeyword)
    
    keywordEditBox:SetScript("OnEnterPressed", function(self)
        local newKeyword = self:GetText()
        GuildPartyInviteDB = GuildPartyInviteDB or {}
        GuildPartyInviteDB.defaultKeyword = newKeyword
        print("Keyword updated to: " .. newKeyword)
        
        -- Update the 'keyword' variable
        keyword = newKeyword
        
        -- Save the changes to the saved variables file
        if GuildPartyInviteDB then
            GuildPartyInviteDB.defaultKeyword = newKeyword
        end
        
        UpdateEditBoxText(self, newKeyword) -- Update the edit box text after the keyword is changed
        
        self:ClearFocus()
    end)

    local saveButton = CreateFrame("Button", addonName .. "SaveButton", panel, "UIPanelButtonTemplate")
    saveButton:SetText("Save")
    saveButton:SetWidth(100)
    saveButton:SetHeight(25)
    saveButton:SetPoint("TOPLEFT", keywordEditBox, "BOTTOMLEFT", 0, -10)
    saveButton:SetScript("OnClick", function()
        local newKeyword = keywordEditBox:GetText()
        GuildPartyInviteDB = GuildPartyInviteDB or {}
        GuildPartyInviteDB.defaultKeyword = newKeyword
        print("Keyword updated to: " .. newKeyword)
        
        -- Update the 'keyword' variable
        keyword = newKeyword
    end)

    InterfaceOptions_AddCategory(panel)
end

-- Register for the ADDON_LOADED event to ensure proper initialization
local addonFrame = CreateFrame("Frame")
addonFrame:RegisterEvent("ADDON_LOADED")
addonFrame:SetScript("OnEvent", function(self, event, addonLoaded)
    -- Check if the loaded addon matches the addon we're interested in
    if addonLoaded == addonName then
        -- Retrieve the keyword from saved variables file or use the default keyword if not found
        keyword = GuildPartyInviteDB and GuildPartyInviteDB.defaultKeyword or defaultKeyword

        -- Call CreateSettings() to create the settings panel
        CreateSettings()

        -- Unregister from ADDON_LOADED event to avoid unnecessary checks
        self:UnregisterEvent("ADDON_LOADED")
    end
end)

-- Function to save keyword to saved variables
local function SaveSettings()
    GuildPartyInviteDB = GuildPartyInviteDB or {}
    GuildPartyInviteDB.defaultKeyword = keyword
end

-- Register event to save settings on logout or reload
local addonFrame = CreateFrame("Frame")
addonFrame:RegisterEvent("PLAYER_LOGOUT")
addonFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGOUT" then
        SaveSettings()
    end
end)


function hcstrsplit(delimiter, subject)
  if not subject then return nil end
  local delimiter, fields = delimiter or ":", {}
  local pattern = string.format("([^%s]+)", delimiter)
  string.gsub(subject, pattern, function(c) fields[table.getn(fields)+1] = c end)
  return unpack(fields)
end

local major, minor, fix = hcstrsplit(".", tostring(GetAddOnMetadata("GuildPartyInvite", "Version")))
fix = fix or 0 -- Set fix to 0 if it is nil

local alreadyshown = false
local localversion  = tonumber(major*10000 + minor*100 + fix)
local remoteversion = tonumber(gpiupdateavailable) or 0
local loginchannels = { "BATTLEGROUND", "RAID", "GUILD", "PARTY" }
local groupchannels = { "BATTLEGROUND", "RAID", "PARTY" }
  
gpiupdater = CreateFrame("Frame")
gpiupdater:RegisterEvent("CHAT_MSG_ADDON")
gpiupdater:RegisterEvent("PLAYER_ENTERING_WORLD")
gpiupdater:RegisterEvent("PARTY_MEMBERS_CHANGED")
gpiupdater:SetScript("OnEvent", function(_, event, ...)
    if event == "CHAT_MSG_ADDON" then
        local arg1, arg2 = ...
        if arg1 == "gpi" then
            local v, remoteversion = hcstrsplit(":", arg2)
            remoteversion = tonumber(remoteversion)
            if v == "VERSION" and remoteversion then
                if remoteversion > localversion then
                    gpiupdateavailable = remoteversion
                    if not alreadyshown then
                        print("|cff6699ffG|cff66aaffu|cff66bbffi|cff66ccffl|cff66ddffd|cff66eeffP|cff77ffffa|cff88ffffr|cff99fffft|cffaaffffy|cffbbffffI|cffccffffn|cffddffffv|cffffffffite|r New version available! |cff66ccffhttps://github.com/Shadowtoots/GuildPartyInvite|r")
                        alreadyshown = true
                    end
                end
            end
            --This is a little check that I can use to see if people are actually using the addon.
            if v == "PING?" then
                for _, chan in ipairs(loginchannels) do
                    SendAddonMessage("gpi", "PONG!:"..GetAddOnMetadata("GuildPartyInvite", "Version"), chan)
                end
            end
            if v == "PONG!" then
                --print(arg1 .." "..arg2.." "..arg3.." "..arg4)
            end
        end

        if event == "PARTY_MEMBERS_CHANGED" then
            local groupsize = GetNumRaidMembers() > 0 and GetNumRaidMembers() or GetNumPartyMembers() > 0 and GetNumPartyMembers() or 0
            if (this.group or 0) < groupsize then
                for _, chan in ipairs(groupchannels) do
                    SendAddonMessage("gpi", "VERSION:" .. localversion, chan)
                end
            end
            this.group = groupsize
        end

    elseif event == "PLAYER_ENTERING_WORLD" then
        if not alreadyshown and localversion < remoteversion then
            print("|cff6699ffG|cff66aaffu|cff66bbffi|cff66ccffl|cff66ddffd|cff66eeffP|cff77ffffa|cff88ffffr|cff99fffft|cffaaffffy|cffbbffffI|cffccffffn|cffddffffv|cffffffffite|r New version available! |cff66ccffhttps://github.com/Shadowtoots/GuildPartyInvite|r")
            gpiupdateavailable = localversion
            alreadyshown = true
        end

        for _, chan in ipairs(loginchannels) do
            SendAddonMessage("gpi", "VERSION:" .. localversion, chan)
        end
    end
end)