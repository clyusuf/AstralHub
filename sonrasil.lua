--// Player Locals
local Players = game:GetService("Players");
local Client = Players.LocalPlayer;
local Mouse = Client:GetMouse();


--// Aimbot Locals
local mousemoverel = mousemoverel or Input.MouseMove;

local aimkey = Enum.UserInputType.MouseButton2;
local enabled = false;
local camera = workspace.CurrentCamera;
local down = false;
local aimpart = "Head";
local tsp = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2 + 400);
local gs = game:GetService("GuiService"):GetGuiInset();
local sc = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2);
local fov = 150;
local fovenabled = false;
local rainbowfov = false;
local teamcheck = false;
local triggerbot = false;
local healthcheck = false;
local visibilitycheck = false;
local Paused = false
local counter = 0;

--# Functions
local NotObstructing = function(destination, ignore)
    local Origin = workspace.CurrentCamera.CFrame.p
    local CheckRay = Ray.new(Origin, destination- Origin)
    local Hit = workspace:FindPartOnRayWithIgnoreList(CheckRay, ignore)
    return Hit == nil
end 

function Circle(color)
    local circ = Drawing.new('Circle')
    circ.Transparency = 1
    circ.Thickness = 1.5
    circ.Visible = true
    circ.Color = color
    circ.Filled = false
    circ.Radius = fov
    return circ
end

function zigzag(X) 
    return math.acos(math.cos(X*math.pi))/math.pi 
end

local GetClosestPlayer = function()
	local nearest = math.huge
	local nearplr
	for i, v in pairs(game:GetService("Players"):GetPlayers()) do
		if v ~= Client and v.Character and v.Character:FindFirstChild(aimpart) then
            if teamcheck then
                if visibilitycheck then
                    if healthcheck then
                        if NotObstructing(v.Character[aimpart].Position,{Client.Character,v.Character}) then
                            if v.Team ~= Client.Team then
                                local Humanoid = v.Character:FindFirstChildOfClass("Humanoid")
                                if Humanoid.Health > 1 then
                                    local pos = camera:WorldToScreenPoint(v.Character[aimpart].Position)
                                    local diff = math.sqrt((pos.X - sc.X) ^ 2 + (pos.Y + gs.Y - sc.Y) ^ 2)
                                    if diff < nearest and diff < 150 then
                                        nearest = diff
                                        nearplr = v
                                    end
                                end
                            end
                        end
                    else
                        if v.Team ~= Client.Team then
                            if NotObstructing(v.Character[aimpart].Position,{Client.Character,v.Character}) then
                                local pos = camera:WorldToScreenPoint(v.Character[aimpart].Position)
                                local diff = math.sqrt((pos.X - sc.X) ^ 2 + (pos.Y + gs.Y - sc.Y) ^ 2)
                                if diff < nearest and diff < 150 then
                                    nearest = diff
                                    nearplr = v
                                end
                            end
                        end
                    end
                else
                    if healthcheck then
                        if v.Team ~= Client.Team then
                            if v.Character:FindFirstChildOfClass("Humanoid") then
                                local Humanoid = v.Character:FindFirstChildOfClass("Humanoid")
                                if Humanoid.Health > 1 then
                                    local pos = camera:WorldToScreenPoint(v.Character[aimpart].Position)
                                    local diff = math.sqrt((pos.X - sc.X) ^ 2 + (pos.Y + gs.Y - sc.Y) ^ 2)
                                    if diff < nearest and diff < 150 then
                                        nearest = diff
                                        nearplr = v
                                    end
                                end
                            end
                        end
                    else
                        if v.Team ~= Client.Team then
                            local pos = camera:WorldToScreenPoint(v.Character[aimpart].Position)
                            local diff = math.sqrt((pos.X - sc.X) ^ 2 + (pos.Y + gs.Y - sc.Y) ^ 2)
                            if diff < nearest and diff < 150 then
                                nearest = diff
                                nearplr = v
                            end
                        end
                    end
                end
            else
                if visibilitycheck then
                    if healthcheck then
                        if NotObstructing(v.Character[aimpart].Position,{Client.Character,v.Character}) then
                            local Humanoid = v.Character:FindFirstChildOfClass("Humanoid")
                            if Humanoid.Health > 1 then
                                local pos = camera:WorldToScreenPoint(v.Character[aimpart].Position)
                                local diff = math.sqrt((pos.X - sc.X) ^ 2 + (pos.Y + gs.Y - sc.Y) ^ 2)
                                if diff < nearest and diff < 150 then
                                    nearest = diff
                                    nearplr = v
                                end
                            end
                        end
                    else
                        if NotObstructing(v.Character[aimpart].Position,{Client.Character,v.Character}) then
                            local pos = camera:WorldToScreenPoint(v.Character[aimpart].Position)
                            local diff = math.sqrt((pos.X - sc.X) ^ 2 + (pos.Y + gs.Y - sc.Y) ^ 2)
                            if diff < nearest and diff < 150 then
                                nearest = diff
                                nearplr = v
                            end
                        end
                    end
                else
                    if healthcheck then
                        local Humanoid = v.Character:FindFirstChildOfClass("Humanoid")
                        if Humanoid.Health > 1 then
                            local pos = camera:WorldToScreenPoint(v.Character[aimpart].Position)
                            local diff = math.sqrt((pos.X - sc.X) ^ 2 + (pos.Y + gs.Y - sc.Y) ^ 2)
                            if diff < nearest and diff < 150 then
                                nearest = diff
                                nearplr = v
                            end
                        end
                    else
                        local pos = camera:WorldToScreenPoint(v.Character[aimpart].Position)
                        local diff = math.sqrt((pos.X - sc.X) ^ 2 + (pos.Y + gs.Y - sc.Y) ^ 2)
                        if diff < nearest and diff < 150 then
                            nearest = diff
                            nearplr = v
                        end
                    end
                end
            end
		end
	end
	return nearplr
end

local function IsPlayer(str)
	for i,v in pairs (game:GetService("Players"):GetPlayers()) do
		if triggerbot then
			if v.Team ~= game:GetService("Players").LocalPlayer.Team then
				if game:GetService("Players"):FindFirstChild(str) then
					return true
				end
			end
		else
			if game:GetService("Players"):FindFirstChild(str) then
				return true
			end
		end
	end
end

local GetRel = function(x, y)
	local newy
	local newy
	if x > sc.X then
		newx = -(sc.X - x)
	else
		newx = x - sc.X
	end
	if y > sc.Y then
		newy = -(sc.Y - y)
	else
		newy = y - sc.Y
	end
	return newx, newy
end


curc = Circle(Color3.fromRGB(255,255,255));









local library = loadstring(game:HttpGet("https://pastebinp.com/raw/qwdPKKDN"))()
local Arsenal = library.new("Astral Hub", 5013109572)

-- themes
local themes = {
Background = Color3.fromRGB(24, 24, 24),
Glow = Color3.fromRGB(0, 0, 0),
Accent = Color3.fromRGB(10, 10, 10),
LightContrast = Color3.fromRGB(20, 20, 20),
DarkContrast = Color3.fromRGB(14, 14, 14),  
TextColor = Color3.fromRGB(255, 255, 255)
}

local page = Arsenal:addPage("Aimbot", 5012544693)
local page2 = Arsenal:addPage("Esp", 5012544693)
local page3 = Arsenal:addPage("Misc", 5012544693)
local section1 = page:addSection("Aimbot Settings")
local section2 = page:addSection("Fov Settings")
local section3 = page2:addSection("Esp")
local section4 = page3:addSection("Misc")

section1:addToggle("Aimbot", nil, function(value)
    enabled = value
end)

section1:addToggle("Health Check", nil, function(value)
    healthcheck = value
end)

section1:addToggle("Team Check", nil, function(value)
    teamcheck = value
end)
section1:addToggle("Visibility Check", nil, function(value)
    visibilitycheck = value
end)

section2:addToggle("Fov Enable", nil, function(value)
    fovenabled = value
end)

section2:addToggle("Fov Rainbow", nil, function(value)
    rainbowfov = value
end)

section2:addSlider("Fov Size", 0, 0, 400, function(value)
    fov = value
    end)
    
section3:addButton("Box esp", function()
    loadstring(game:HttpGet("https://pastebinp.com/raw/zKjj0TQD", true))()
wait()
local gui = game.Players.LocalPlayer.PlayerGui.UNIX
gui:Destroy()
    end)

    section4:addButton("Wall Bang", function()
        local EzHook = loadstring(game:HttpGetAsync("https://pastebinp.com/raw/3cCyS6GF"))()
        EzHook:HookIndex("Clips",function()end,workspace.Map)
    end)

    section4:addButton("Kill all / E", function()
        game.Players.LocalPlayer:GetMouse().KeyDown:Connect(function(k)
            if k == "e" then
            local Gun = game.ReplicatedStorage.Weapons:FindFirstChild(game.Players.LocalPlayer.NRPBS.EquippedTool.Value);
            local Crit = math.random() > .6 and true or false;
            for i,v in pairs(game.Players:GetPlayers()) do
            if v and v.Character and v.Character:FindFirstChild("Head") then
            local Distance = (game.Players.LocalPlayer.Character.Head.Position - v.Character.Head.Position).magnitude
            for i  = 1,10 do
            game.ReplicatedStorage.Events.HitPart:FireServer(v.Character.Head,
            v.Character.Head.Position + Vector3.new(math.random(), math.random(), math.random()),
            Gun.Name,
            Crit and 2 or 1,
            Distance,
            Backstab,
            Crit,
            false,
            1,
            false,
            Gun.FireRate.Value,
            Gun.ReloadTime.Value,
            Gun.Ammo.Value,
            Gun.StoredAmmo.Value,
            Gun.Bullets.Value,
            Gun.EquipTime.Value,
            Gun.RecoilControl.Value,
            Gun.Auto.Value,
            Gun['Speed%'].Value,
            game.ReplicatedStorage.wkspc.DistributedTime.Value);
            end
            end
            end
            end
            end)
    end)

    section4:addButton("Hitbox", function()
        local Script = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client
        local ran = false
        local tables = {}
        local w = wait
        
        local players = game:GetService("Players")
        local plr = players.LocalPlayer
        coroutine.resume(coroutine.create(function()
            while  wait(1) do
                coroutine.resume(coroutine.create(function()
                    for _,v in pairs(players:GetPlayers()) do
                        if v.Name ~= plr.Name and v.Character then
                            v.Character.LowerTorso.CanCollide = false
                            v.Character.LowerTorso.Material = "Neon"
                            v.Character.LowerTorso.Size = Vector3.new(20,20,20)
                            v.Character.HumanoidRootPart.Size = Vector3.new(20,20,20)
                            v.character.LowerTorso.Transparency = 0.9
                            v.Character.HumanoidRootPart.Transparency = 0.9
                        end
                    end
                end))
            end
        end))
     end)

    section3:addButton("Line Esp", function()
        local camera = game:GetService("Workspace").CurrentCamera
        local RunService = game:GetService("RunService")
        local Players = game:GetService("Players")
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local mouse = game:GetService("Players").LocalPlayer:GetMouse()
        local Paused = false
        
        TaggedPlayers = { }
        LinedPlayers = { }
        PlayerNames = { }
        
        function WorldToScreen(part, idx)
        if part ~= nil then
        RootPos = part.position
        scr, vis = camera:WorldToScreenPoint(RootPos)
        if vis then
        TaggedPlayers[idx].Visible = true
        LinedPlayers[idx].Visible = true
        return Vector2.new(scr.x, scr.y)
        else
        TaggedPlayers[idx].Visible = false
        LinedPlayers[idx].Visible = false
        return Vector2.new(0, 0)
        end
        else
        TaggedPlayers[idx].Visible = false
        LinedPlayers[idx].Visible = false
        return Vector2.new(0, 0)
        end
        end
        
        local function has_value (tab, val)
           for index, value in ipairs(tab) do
               if value == val then
                   return true
               end
           end
           return false
        end
        
        local function cleartb(t)
        for k in pairs (t) do
        t [k] = nil
        end
        end
        
        local function removeESP(t)
        for k in pairs (t) do
        t[k].Remove(t[k])
        end
        end
        
        function Init()
        Paused = true
        removeESP(TaggedPlayers)
        removeESP(LinedPlayers)
        cleartb(LinedPlayers)
        cleartb(TaggedPlayers)
        cleartb(PlayerNames)
        
           watermark = Drawing.new("Text")
        watermark.Text = ""
        watermark.Color = Color3.new(153/255,5/255,204/255)
        watermark.Position = Vector2.new(camera.ViewportSize.X - 160, camera.ViewportSize.Y - 25)
        watermark.Size = 24.0
        watermark.Outline = true
        watermark.Visible = true
        Wait(1)
        Paused = false
        end
        
        function LoadESP()
        for i,v in pairs(game:GetService("Players"):GetChildren()) do
        if game:GetService("Workspace"):FindFirstChild(v.Name) ~= nil then
        if not has_value(PlayerNames, v.Name) then
        table.insert(LinedPlayers, Drawing.new("Line"))
        table.insert(TaggedPlayers, Drawing.new("Text"))
        table.insert(PlayerNames, v.Name)
        if v.Name ~= LocalPlayer.Name then
        TaggedPlayers[i].Text = v.Name
        TaggedPlayers[i].Size = 14.0
        TaggedPlayers[i].Color = v.TeamColor.Color
        TaggedPlayers[i].Outline = true
        TaggedPlayers[i].Center = true
        
        LinedPlayers[i].Thickness = 1.6
        LinedPlayers[i].Color = v.TeamColor.Color
        
        Loc = WorldToScreen(v.Character:FindFirstChild("HumanoidRootPart"), i)
        
        LinedPlayers[i].From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y - 2)
        LinedPlayers[i].To = Loc
        TaggedPlayers[i].Position = Loc
        end
        else
        Loc = WorldToScreen(v.Character:FindFirstChild("HumanoidRootPart"), i)
        LinedPlayers[i].From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y - 2)
        LinedPlayers[i].To = Loc
        TaggedPlayers[i].Position = Loc
        end
        end
        end
        end
        
        Init()
        
        Players.PlayerAdded:connect(function(player)
        Paused = true
        removeESP(TaggedPlayers)
        removeESP(LinedPlayers)
        cleartb(LinedPlayers)
        cleartb(TaggedPlayers)
        Paused = false
        end)
        
        Players.PlayerRemoving:connect(function(player)
        Paused = true
        removeESP(TaggedPlayers)
        removeESP(LinedPlayers)
        cleartb(LinedPlayers)
        cleartb(TaggedPlayers)
        Paused = false
        end)
        
        RunService.RenderStepped:connect(function()
        if not Paused then
        LoadESP()
        end
        end)
    end)





























    local NotObstructing = function(destination, ignore)
        local Origin = workspace.CurrentCamera.CFrame.p
        local CheckRay = Ray.new(Origin, destination- Origin)
        local Hit = workspace:FindPartOnRayWithIgnoreList(CheckRay, ignore)
        return Hit == nil
    end 
    
    game:GetService("UserInputService").InputBegan:Connect(function( input )
        if input.UserInputType  == aimkey then
            down = true
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function( input )
        if input.UserInputType == aimkey then
            down = false
        end
    end)
    
    game:GetService("RunService").RenderStepped:Connect(function( ... )
        if enabled then
            if down then
                if GetClosestPlayer() ~= nil and GetClosestPlayer().Character:FindFirstChild(aimpart) then
                    pcall(function( ... )
                        local pos,visible = camera:WorldToScreenPoint(GetClosestPlayer().Character[aimpart].Position)
                        local x, y = GetRel(pos.X, pos.Y + gs.Y)
                        mousemoverel(x, y)
                    end)
                end
            end
        end
        if triggerbot then
            if Mouse.Target then
                if IsPlayer(Mouse.Target.Name) or IsPlayer(Mouse.Target.Parent.Name) or IsPlayer(Mouse.Target.Parent.Parent.Name) or IsPlayer(Mouse.Target.Parent.Parent.Parent.Name) then
                    mouse1press()
                    wait(0.01)
                    mouse1release()
                end
            end
        end
        curc.Visible = fovenabled
        curc.Position = Vector2.new(Mouse.X, Mouse.Y+gs.Y)
        curc.Radius = fov
        curc.NumSides = 15
        if rainbowfov then
            curc.Color = Color3.fromHSV(zigzag(counter),1,1)
        end
        counter = counter + 0.01
    end)
