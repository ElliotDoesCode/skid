--[[
	Made by IAteYourDog
	Serverhop made by https://v3rmillion.net/showthread.php?tid=1040972
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
	"Good lucking fixing this lol",
	"I remember when it was actually hard to exploit a game",
	"Aww, you thought banning 1 out of 600 accounts would do a thing?"
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

--[[
	LITERAL TRASH LMFAO
]]
local a=game.PlaceId;local b={}local c=""local d=os.date("!*t").hour;local e=false;local f=pcall(function()b=game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))end)if not f then table.insert(b,d)writefile("NotSameServers.json",game:GetService('HttpService'):JSONEncode(b))end;function TPReturner()local g;if c==""then g=game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/'..a..'/servers/Public?sortOrder=Asc&limit=100'))else g=game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/'..a..'/servers/Public?sortOrder=Asc&limit=100&cursor='..c))end;local h=""if g.nextPageCursor and g.nextPageCursor~="null"and g.nextPageCursor~=nil then c=g.nextPageCursor end;local i=0;for j,k in pairs(g.data)do local l=true;h=tostring(k.id)if tonumber(k.maxPlayers)>tonumber(k.playing)then for m,n in pairs(b)do if i~=0 then if h==tostring(n)then l=false end else if tonumber(d)~=tonumber(n)then local o=pcall(function()delfile("NotSameServers.json")b={}table.insert(b,d)end)end end;i=i+1 end;if l==true then table.insert(b,h)wait()pcall(function()writefile("NotSameServers.json",game:GetService('HttpService'):JSONEncode(b))wait()game:GetService("TeleportService"):TeleportToPlaceInstance(a,h,game.Players.LocalPlayer)end)wait(4)end end end end;function Teleport()while wait()do pcall(function()TPReturner()if c~=""then TPReturner()end end)end end

spawn(function()
	while wait(3) do
		chat()
	end
end)

for _,v in pairs(game:GetService("Players"):GetPlayers()) do
	if v.Team and v.Team.Name == "Criminals" then
		local target = v.Character.UpperTorso
		go(target)
		if game.Players.LocalPlayer.Character.Humanoid.Sit == true then
			leave()
			wait(.3)
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.CFrame
			taze(target.Parent.Head)
			wait(0.4)
			arrest(target)
		end
		wait(2.4)
	end
end

sererHop()
Teleport()
