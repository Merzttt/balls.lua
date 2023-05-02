_G.BLACKLISTED = {
	--["ACID_lani"] = true,
}

for _, plr in pairs(game.Players:GetPlayers()) do
    if _G.BLACKLISTED[plr.DisplayName] then
    	local args = {
			[1] = "The user, " .. plr.DisplayName .. ", has been blacklisted from talking to the AI. Your behaviour will not be tolerated.",
			[2] = "All"
		}

		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))
    end
end


local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local language = "en"
local censorSwearing = "True"

if _G.Enabled then print("Settings Applied, Overwrite complete. Returning...") return end;

local args = {
    [1] = "Hello, I'm SimSimi, an Artificial Intelligence. Please feel free to talk to me, ask me anything you like. I learn how to speak better as we go.",
    [2] = "All"
}

game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))

_G.Enabled = true

local function main(message, userDisplay)
    local text = message
    local response = game:HttpGet("https://api.simsimi.net/v2/?text="..text.."&lc="..language.."&cf="..censorSwearing)
    local data = HttpService:JSONDecode(response)
    
    local responseText = data.success:gsub("i love you", "ily"):gsub("wtf", "wt$"):gsub("zex", "zesty"):gsub("\n", ""):gsub("I love you", "ily"):gsub("I don't know what you're saying. Please teach me.", "I do not understand, try saying it without emojis and/or special characters.")
    
   wait()
   
   game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("[ChatBot]: "..userDisplay..", "..responseText.."", "All")
   print(userDisplay..", "..responseText)
end

Players.PlayerChatted:Connect(function(type, plr, message)
    for _,plrs in pairs(game.Players:GetPlayers()) do
    	if _G.BLACKLISTED[plrs.DisplayName] then
            continue
        end
		if (Players.LocalPlayer.Character.HumanoidRootPart.Position - plrs.Character.HumanoidRootPart.Position).magnitude <= 100 then
			if plr.DisplayName == plrs.DisplayName then
				main(message, plr.DisplayName)
			end
		end
	end
end)

local function serverHop()
   local queueonteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
   local httprequest = (syn and syn.request) or http and http.request or http_request or (fluxus and fluxus.request) or request
   local httpservice = game:GetService('HttpService')
   queueonteleport("loadstring(game:HttpGet(''))()")

   local Http = game:GetService("HttpService")
   local TPS = game:GetService("TeleportService")
   local Api = "https://games.roblox.com/v1/games/"

   local _place = game.PlaceId
   local _servers = Api.._place.."/servers/Public?sortOrder=Desc&limit=100"
   function ListServers(cursor)
      local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
      return Http:JSONDecode(Raw)
   end

   local Server, Next; repeat
      local Servers = ListServers(Next)
      Server = Servers.data[1]
      Next = Servers.nextPageCursor
   until Server

   TPS:TeleportToPlaceInstance(_place,Server.id,game.Players.LocalPlayer)
end

-- Run the server hop function every 15 minutes
while true do
   serverHop()
   wait(15 * 60)
end
