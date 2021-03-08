--[[
	Made by IAteYourDog
	Everything else was made by IAteYourDog
]]
local messages = {
	"Lol this game has no security",
	"Probably the easiest script I've ever made tbh",
	"Imagine not having good anti-exploit",
	"Don't like what I'm doing? Thank the devs",
	"Lol, this took less than an hour to make",
	"IAteYourDog car4864 is pretty cool tbh",
	"Do the devs know what anti exploit is?",
	"Good luck fixing this lol",
	"I remember when it was actually hard to exploit a game",
	"Aww, you thought banning 1 out of 600 accounts would do a thing?",
	"Hi devs, if you see this message. Make your game better lol",
	"I thought you 'patched' my script?",
	"I love seeing watching this game die tbh"
}

print("Loading")

if not game:IsLoaded() then
	game.Loaded:Wait()
end

repeat 
	wait() 
	for _,v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.HUD.TeamScreen.PoliceBG.MouseButton1Click)) do
		v:Fire()
	end
until game:GetService("Players").LocalPlayer.PlayerGui.HUD.TeamScreen.Visible == false and game:GetService("Players").LocalPlayer.Character ~= nil

print("Past loading screen")

local function leave()
	game:GetService("ReplicatedStorage").Events.ExitVehicle:FireServer()
end

local function enterCar(car)
	local args = {
		[1] = "EnterVehicle",
		[2] = car
	}

	game:GetService("ReplicatedStorage").NetworkEvents.EventIndex7:FireServer(unpack(args))
	wait(0.3)
end

local function arrest(plr)
	local args = {
		[1] = "ContextCallback",
		[2] = "ArrestPlayer",
		[3] = plr,
		[4] = true
	}

	game:GetService("ReplicatedStorage").NetworkEvents.EventIndex6:FireServer(unpack(args))
end

local function taze(plr)
	local args = {
		[1] = plr.Position,
		[2] = plr.Position,
		[3] = plr
	}

	game:GetService("ReplicatedStorage").Events.CreateTaserProjectile:FireServer(unpack(args))
end

local function go(plr)
	--DEBUG
	local vehicle
	for i,v in pairs(game.Workspace.Vehicles:GetDescendants()) do 
		if v.Name == "Caddie" and v.Seats:FindFirstChild("Driver") and v.Seats.Driver.Occupant == nil then
			if v.Seats.Driver:FindFirstChild("VehicleNameTag") then
				if v.Seats.Driver.VehicleNameTag.Username.Text == "UseStarCode_BACON" or v.Seats.Driver.VehicleNameTag.Username.Text == "" then
					print("car car")
					vehicle = v.Seats.Driver
				end
			end
		end
	end

	local target = plr
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = vehicle.CFrame + Vector3.new(0,3,0)
	game.Players.LocalPlayer.Character.Humanoid:ChangeState(10)
	enterCar(vehicle)
	vehicle.Parent.Parent:SetPrimaryPartCFrame(target.CFrame + Vector3.new(0,3,0))

	wait(0.5)
end

local function chat()
	local randomMsg = messages[math.random(1,#messages)]
	local args = {
		[1] = randomMsg,
		[2] = "All"
	}

	game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))
end

local function sererHop()
	print("Work in progress")
	game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
		if State == Enum.TeleportState.Started then
			syn.queue_on_teleport(game:HttpGet("https://elliotdoescode.github.io/skid/load.lua"))
		end
	end)
	wait()
	while wait() do
		local worked, failed = pcall(function()
			--My Beta Serverhop
			for _,v in ipairs(game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..tonumber(game.PlaceId).."/servers/Public?sortOrder=Asc&limit=100")).data) do
				if type(v) == "table" then --Might have to change this because sometimes roblox jsondecode glitches and doesn't return as a table?
					if tonumber(v["playing"]) ~= tonumber(v["maxPlayers"]) and tonumber(v["playing"]) > tonumber(v["maxPlayers"]) / 2 then
						--Might change this later maybe like a table.sort
						game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,v["id"])
					end
				end
			end
		end)
		if not worked then print(failed) end
	end
end

spawn(function()
	while wait(3) do
		chat()
	end
end)

for _,v in pairs(game:GetService("Players"):GetPlayers()) do
	--If LocalPlayer Disconnects (NOT MADE BY ME: https://v3rmillion.net/showthread.php?tid=896572)
	local prompt = assert(game:GetService("CoreGui"):FindFirstChild("promptOverlay", true), "Lol it should work :/")
	prompt.ChildAdded:Connect(function(child)
		assert(child, typeof(child) == "Instance" and child.Name == "ErrorPrompt" and child.ClassName == "Frame" and wait(2) and print("Disconnected")) game:GetService("Players").LocalPlayer:Kick("Autoarrest detected anti-exploit kick. Bypassing...") Serverhop()
	end)
	pcall(function()
		if v.Team and v.Team.Name == "Criminals" then
			local function repeatFunc()
				local target = v.Character.UpperTorso
				go(target)
				wait()
				if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
					for count = 1, 3 do
						leave()
					end
					taze(target.Parent.Head)
					wait(0.4)
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.CFrame + Vector3.new(0,3,0)
					wait(0.4)
					arrest(target)
				end
				wait(2.4)
				if v.Team and v.Team.Name == "Criminals" then
					print("Player wasn't arrested, trying again")
					repeatFunc()
				end
			end
			repeatFunc()
		end
	end)
end

sererHop()
