local E, L, V, P, G = unpack(ElvUI)
local CH = E:GetModule("Chat")
local CT = E:GetModule("CustomTweaks")
local isEnabled = E.private["chat"].enable and E.private["CustomTweaks"] and E.private["CustomTweaks"]["ChatMaxLines"] and true or false

local _G = _G
local pairs = pairs

P["CustomTweaks"]["ChatMaxLines"] = {
	["MaxLines"] = 128,
}

local UpdateMaxLines
local function ConfigTable()
	E.Options.args.elvuiPlugins.args.CustomTweaks.args.Chat.args.ChatMaxLines = {
		type = "group",
		name = "ChatMaxLines",
		get = function(info) return E.db.CustomTweaks.ChatMaxLines[info[#info]] end,
		set = function(info, value) E.db.CustomTweaks.ChatMaxLines[info[#info]] = value; UpdateMaxLines() end,
		args = {
			MaxLines = {
				order = 1,
				type = "range",
				name = L["Max Lines"],
				desc = L["The max amount of messages kept in chat before they get replaced by new messages. Changing this setting will clear the chat in all windows."],
				disabled = function() return not isEnabled end,
				min = 1, max = 5000, step = 1,
			},
		},
	}
end
CT.Configs["ChatMaxLines"] = ConfigTable
if not isEnabled then return; end

function UpdateMaxLines(self)
	for _, frameName in pairs(CHAT_FRAMES) do
		local frame = _G[frameName]
		frame:SetMaxLines(E.db.CustomTweaks.ChatMaxLines.MaxLines)
	end

	--Re-display chat history since it was all cleared when calling :SetMaxLines
	if E.db.chat.chatHistory then
		self.SoundPlayed = true;
		self:DisplayChatHistory()
		self.SoundPlayed = nil;
	end
end
hooksecurefunc(CH, "Initialize", UpdateMaxLines)
