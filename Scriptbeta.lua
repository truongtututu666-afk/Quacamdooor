local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

local Window = redzlib:MakeWindow({
  Title = "quả cam Hub",
  SubTitle = "DOORS Premium Script",
  SaveFolder = "KhiCamHub_DOORS"
})

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://6031097225", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(0, 5) },
})

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

-- Settings
_G.DOORS = {
    -- Auto
    AutoDoor = false,
    AutoKey = false,
    AutoLever = false,
    AutoValve = false,
    AutoSkipRoom = false,
    AutoPlayGame = false,
    
    -- Entity
    EntityNotifier = false,
    AvoidRush = false,
    AvoidAmbush = false,
    AvoidEyes = false,
    DeleteSeek = false,
    DeleteScreech = false,
    DeleteHalt = false,
    DeleteDupe = false,
    NoJumpscare = false,
    
    -- ESP
    DoorESP = false,
    KeyESP = false,
    ItemESP = false,
    EntityESP = false,
    PlayerESP = false,
    ClosetESP = false,
    GoldESP = false,
    
    -- Bypass
    NoSeekChase = false,
    NoFigure = false,
    NoScreechJumpscare = false,
    InstantInteract = false,
    
    -- Visual
    FullBright = false,
    NoFog = false,
    ESPColor = Color3.fromRGB(255, 255, 0),
    
    -- Movement
    Speed = 20,
    Fly = false,
    Noclip = false,
    
    -- Misc
    AntiAFK = true,
    ShowRoomNumber = false,
}

-- Notify Function
local function Notify(title, text, duration)
    game.StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration or 3;
    })
end

-- Get Current Room
local function GetCurrentRoom()
    local currentRoom = 0
    pcall(function()
        currentRoom = ReplicatedStorage.GameData.LatestRoom.Value
    end)
    return currentRoom
end

-- ==================== AUTO OPEN DOORS ====================
spawn(function()
    while wait(0.1) do
        if _G.DOORS.AutoDoor then
            pcall(function()
                local currentRoom = GetCurrentRoom()
                for _, v in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if v.Name == "Door" and v.Parent.Name == tostring(currentRoom) then
                        if v:FindFirstChild("ClientOpen") then
                            fireproximityprompt(v.ClientOpen)
                        end
                    end
                end
            end)
        end
    end
end)

-- ==================== AUTO COLLECT KEYS ====================
spawn(function()
    while wait(0.1) do
        if _G.DOORS.AutoKey then
            pcall(function()
                local currentRoom = GetCurrentRoom()
                for _, v in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if v.Name == "KeyObtain" then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = (v.Hitbox.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                            if distance < 10 then
                                fireproximityprompt(v.ModulePrompt)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ==================== AUTO LEVERS ====================
spawn(function()
    while wait(0.1) do
        if _G.DOORS.AutoLever then
            pcall(function()
                for _, v in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if v.Name == "LeverForGate" then
                        if v:FindFirstChild("PromptPart") then
                            fireproximityprompt(v.PromptPart.ActivateEventPrompt)
                        end
                    end
                end
            end)
        end
    end
end)

-- ==================== AUTO VALVES ====================
spawn(function()
    while wait(0.1) do
        if _G.DOORS.AutoValve then
            pcall(function()
                for _, v in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if v.Name == "Valve" or v.Name == "LiveHintBook" then
                        if v:FindFirstChild("ModulePrompt") then
                            fireproximityprompt(v.ModulePrompt)
                        end
                    end
                end
            end)
        end
    end
end)

-- ==================== ENTITY NOTIFIER ====================
local entityNames = {
    "RushMoving",
    "AmbushMoving", 
    "Eyes",
    "Screech",
    "Halt",
    "Seek",
    "Figure",
    "A60",
    "A120"
}

local notifiedEntities = {}

spawn(function()
    while wait(0.1) do
        if _G.DOORS.EntityNotifier then
            pcall(function()
                for _, entityName in pairs(entityNames) do
                    for _, entity in pairs(Workspace:GetDescendants()) do
                        if entity.Name == entityName and not notifiedEntities[entity] then
                            Notify("⚠️ ENTITY ALERT", entityName .. " đã xuất hiện!", 5)
                            notifiedEntities[entity] = true
                            
                            -- Play warning sound
                            local sound = Instance.new("Sound")
                            sound.SoundId = "rbxassetid://4590657391"
                            sound.Volume = 2
                            sound.Parent = game:GetService("SoundService")
                            sound:Play()
                            
                            task.wait(1)
                            sound:Destroy()
                            
                            -- Clear after 30 seconds
                            task.delay(30, function()
                                notifiedEntities[entity] = nil
                            end)
                        end
                    end
                end
            end)
        end
    end
end)

-- ==================== AUTO AVOID RUSH/AMBUSH ====================
spawn(function()
    while wait(0.1) do
        if _G.DOORS.AvoidRush or _G.DOORS.AvoidAmbush then
            pcall(function()
                for _, entity in pairs(Workspace:GetDescendants()) do
                    if (entity.Name == "RushMoving" and _G.DOORS.AvoidRush) or 
                       (entity.Name == "AmbushMoving" and _G.DOORS.AvoidAmbush) then
                        
                        -- Find nearest closet
                        local nearestCloset = nil
                        local nearestDist = math.huge
                        
                        for _, closet in pairs(Workspace.CurrentRooms:GetDescendants()) do
                            if closet.Name == "Wardrobe" then
                                local prompt = closet:FindFirstChild("HiddenPlayer")
                                if prompt then
                                    local dist = (closet.PrimaryPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                                    if dist < nearestDist then
                                        nearestCloset = closet
                                        nearestDist = dist
                                    end
                                end
                            end
                        end
                        
                        if nearestCloset then
                            -- Teleport to closet
                            LocalPlayer.Character.HumanoidRootPart.CFrame = nearestCloset.PrimaryPart.CFrame
                            wait(0.2)
                            
                            -- Hide in closet
                            fireproximityprompt(nearestCloset.HiddenPlayer.HidePrompt)
                            
                            -- Wait for entity to pass
                            wait(8)
                            
                            -- Exit closet
                            if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                LocalPlayer.Character.HumanoidRootPart.CFrame = nearestCloset.PrimaryPart.CFrame + Vector3.new(0, 0, 5)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ==================== DELETE ENTITIES ====================
spawn(function()
    while wait(0.1) do
        pcall(function()
            for _, entity in pairs(Workspace:GetDescendants()) do
                if _G.DOORS.DeleteSeek and entity.Name == "Seek" then
                    entity:Destroy()
                end
                if _G.DOORS.DeleteScreech and entity.Name == "Screech" then
                    entity:Destroy()
                end
                if _G.DOORS.DeleteHalt and entity.Name == "Halt" then
                    entity:Destroy()
                end
                if _G.DOORS.DeleteDupe and entity.Name == "FakeDoor" then
                    entity:Destroy()
                end
            end
        end)
    end
end)

-- ==================== NO SEEK CHASE ====================
spawn(function()
    while wait(0.1) do
        if _G.DOORS.NoSeekChase then
            pcall(function()
                for _, v in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if v.Name == "Seek_Arm" then
                        v:Destroy()
                    end
                end
                
                -- Skip seek chase
                if Workspace:FindFirstChild("SeekRig") then
                    Workspace.SeekRig:Destroy()
                end
            end)
        end
    end
end)

-- ==================== NO EYES DAMAGE ====================
spawn(function()
    while wait(0.1) do
        if _G.DOORS.AvoidEyes then
            pcall(function()
                for _, eyes in pairs(Workspace:GetDescendants()) do
                    if eyes.Name == "Eyes" then
                        -- Look away from eyes
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                            LocalPlayer.Character.Humanoid.AutoRotate = false
                        end
                    end
                end
            end)
        else
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.AutoRotate = true
            end
        end
    end
end)

-- ==================== ESP SYSTEM ====================
local function CreateESP(object, text, color)
    if not object:FindFirstChild("ESP_DOORS") then
        local BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Name = "ESP_DOORS"
        BillboardGui.Parent = object
        BillboardGui.AlwaysOnTop = true
        BillboardGui.Size = UDim2.new(0, 100, 0, 50)
        BillboardGui.StudsOffset = Vector3.new(0, 2, 0)
        
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Parent = BillboardGui
        TextLabel.BackgroundTransparency = 1
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.Text = text
        TextLabel.TextColor3 = color
        TextLabel.TextStrokeTransparency = 0
        TextLabel.TextScaled = true
        TextLabel.Font = Enum.Font.GothamBold
    end
end

-- Door ESP
spawn(function()
    while wait(1) do
        if _G.DOORS.DoorESP then
            pcall(function()
                for _, door in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if door.Name == "Door" then
                        CreateESP(door, "🚪 DOOR", Color3.fromRGB(0, 255, 0))
                    end
                end
            end)
        else
            for _, v in pairs(Workspace.CurrentRooms:GetDescendants()) do
                if v:FindFirstChild("ESP_DOORS") then
                    v.ESP_DOORS:Destroy()
                end
            end
        end
    end
end)

-- Key ESP
spawn(function()
    while wait(1) do
        if _G.DOORS.KeyESP then
            pcall(function()
                for _, key in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if key.Name == "KeyObtain" then
                        CreateESP(key, "🔑 KEY", Color3.fromRGB(255, 255, 0))
                    end
                end
            end)
        end
    end
end)

-- Item ESP
spawn(function()
    while wait(1) do
        if _G.DOORS.ItemESP then
            pcall(function()
                local items = {"Lighter", "Flashlight", "Battery", "Crucifix", "Lockpick", "Vitamins"}
                for _, itemName in pairs(items) do
                    for _, item in pairs(Workspace.CurrentRooms:GetDescendants()) do
                        if item.Name == itemName then
                            CreateESP(item, "📦 " .. itemName:upper(), Color3.fromRGB(255, 100, 255))
                        end
                    end
                end
            end)
        end
    end
end)

-- Closet ESP
spawn(function()
    while wait(1) do
        if _G.DOORS.ClosetESP then
            pcall(function()
                for _, closet in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if closet.Name == "Wardrobe" then
                        CreateESP(closet.PrimaryPart, "🚪 CLOSET", Color3.fromRGB(100, 200, 255))
                    end
                end
            end)
        end
    end
end)

-- Gold ESP
spawn(function()
    while wait(1) do
        if _G.DOORS.GoldESP then
            pcall(function()
                for _, gold in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if gold.Name == "GoldPile" then
                        CreateESP(gold, "💰 GOLD", Color3.fromRGB(255, 215, 0))
                    end
                end
            end)
        end
    end
end)

-- Entity ESP
spawn(function()
    while wait(0.5) do
        if _G.DOORS.EntityESP then
            pcall(function()
                for _, entity in pairs(Workspace:GetDescendants()) do
                    if entity.Name == "RushMoving" then
                        CreateESP(entity, "⚠️ RUSH", Color3.fromRGB(255, 0, 0))
                    elseif entity.Name == "AmbushMoving" then
                        CreateESP(entity, "⚠️ AMBUSH", Color3.fromRGB(255, 50, 0))
                    elseif entity.Name == "Eyes" then
                        CreateESP(entity, "👁️ EYES", Color3.fromRGB(200, 0, 255))
                    elseif entity.Name == "Screech" then
                        CreateESP(entity, "👻 SCREECH", Color3.fromRGB(0, 255, 255))
                    end
                end
            end)
        end
    end
end)

-- ==================== FULLBRIGHT ====================
spawn(function()
    while wait(0.1) do
        if _G.DOORS.FullBright then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        end
    end
end)

-- ==================== SPEED HACK ====================
RunService.Heartbeat:Connect(function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = _G.DOORS.Speed
        end
    end)
end)

-- ==================== FLY ====================
local flying = false
local flyConnection

spawn(function()
    while wait(0.1) do
        if _G.DOORS.Fly and not flying then
            flying = true
            
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local bv = Instance.new("BodyVelocity")
                bv.Name = "FlyVelocity"
                bv.Parent = LocalPlayer.Character.HumanoidRootPart
                bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                
                flyConnection = RunService.Heartbeat:Connect(function()
                    if not _G.DOORS.Fly then
                        flying = false
                        bv:Destroy()
                        if flyConnection then flyConnection:Disconnect() end
                        return
                    end
                    
                    local cam = Workspace.CurrentCamera
                    local dir = Vector3.new()
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        dir = dir + cam.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        dir = dir - cam.CFrame.LookVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        dir = dir - cam.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        dir = dir + cam.CFrame.RightVector
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        dir = dir + Vector3.new(0, 1, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        dir = dir - Vector3.new(0, 1, 0)
                    end
                    
                    bv.Velocity = dir * 50
                end)
            end
        elseif not _G.DOORS.Fly and flying then
            flying = false
            if flyConnection then flyConnection:Disconnect() end
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local bv = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlyVelocity")
                if bv then bv:Destroy() end
            end
        end
    end
end)

-- ==================== NOCLIP ====================
RunService.Stepped:Connect(function()
    if _G.DOORS.Noclip then
        pcall(function()
            if LocalPlayer.Character then
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- ==================== INSTANT INTERACT ====================
spawn(function()
    while wait(0.1) do
        if _G.DOORS.InstantInteract then
            pcall(function()
                for _, v in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if v:IsA("ProximityPrompt") then
                        v.HoldDuration = 0
                    end
                end
            end)
        end
    end
end)

-- ==================== NO JUMPSCARE ====================
spawn(function()
    while wait(0.1) do
        if _G.DOORS.NoJumpscare then
            pcall(function()
                for _, v in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                    if v.Name == "Jumpscare" then
                        v:Destroy()
                    end
                end
            end)
        end
    end
end)

-- ==================== TABS ====================
local Tab1 = Window:MakeTab({"Home", "home"})
local Tab2 = Window:MakeTab({"Auto", "zap"})
local Tab3 = Window:MakeTab({"Entity", "alert-triangle"})
local Tab4 = Window:MakeTab({"ESP", "eye"})
local Tab5 = Window:MakeTab({"Player", "user"})
local Tab6 = Window:MakeTab({"Visual", "sun"})
local Tab7 = Window:MakeTab({"Settings", "settings"})

-- ==================== TAB 1: HOME ====================
Tab1:AddParagraph({
    Name = "quả cam hub - DOORS",
    Description = "Player: " .. LocalPlayer.Name
    .. "\nRoom: " .. GetCurrentRoom()
})

Tab1:AddButton({
    Name = "🎮 Enable Auto Play",
    Description = "Bật tất cả tính năng auto",
    Callback = function()
        _G.DOORS.AutoDoor = true
        _G.DOORS.AutoKey = true
        _G.DOORS.AutoLever = true
        _G.DOORS.AutoValve = true
        _G.DOORS.EntityNotifier = true
        _G.DOORS.FullBright = true
        _G.DOORS.InstantInteract = true
        
        Notify("quả cam hub", "Auto Play Enabled!", 3)
    end
})

Tab1:AddButton({
    Name = "👻 Enable God Mode",
    Description = "Bật tất cả bypass entity",
    Callback = function()
        _G.DOORS.DeleteSeek = true
        _G.DOORS.DeleteScreech = true
        _G.DOORS.DeleteHalt = true
        _G.DOORS.AvoidRush = true
        _G.DOORS.AvoidAmbush = true
        _G.DOORS.AvoidEyes = true
        _G.DOORS.NoJumpscare = true
        
        Notify("quả cam hub", "God Mode Enabled!", 3)
    end
})

Tab1:AddButton({
    Name = "👁️ Enable All ESP",
    Description = "Bật tất cả ESP",
    Callback = function()
        _G.DOORS.DoorESP = true
        _G.DOORS.KeyESP = true
        _G.DOORS.ItemESP = true
        _G.DOORS.ClosetESP = true
        _G.DOORS.GoldESP = true
        _G.DOORS.EntityESP = true
        
        Notify("quả cam hub", "All ESP Enabled!", 3)
    end
})

-- ==================== TAB 2: AUTO ====================
local Section2_1 = Tab2:AddSection({"Auto Actions"})

Tab2:AddToggle({
    Name = "Auto Open Doors",
    Description = "Tự động mở cửa",
    Default = false,
    Callback = function(value)
        _G.DOORS.AutoDoor = value
    end
})

Tab2:AddToggle({
    Name = "Auto Collect Keys",
    Description = "Tự động nhặt chìa khóa",
    Default = false,
    Callback = function(value)
        _G.DOORS.AutoKey = value
    end
})

Tab2:AddToggle({
    Name = "Auto Pull Levers",
    Description = "Tự động kéo đòn bẩy",
    Default = false,
    Callback = function(value)
        _G.DOORS.AutoLever = value
    end
})

Tab2:AddToggle({
    Name = "Auto Turn Valves",
    Description = "Tự động vặn van",
    Default = false,
    Callback = function(value)
        _G.DOORS.AutoValve = value
    end
})

Tab2:AddToggle({
    Name = "Instant Interact",
    Description = "Tương tác tức thời",
    Default = false,
    Callback = function(value)
        _G.DOORS.InstantInteract = value
    end
})

-- ==================== TAB 3: ENTITY ====================
local Section3_1 = Tab3:AddSection({"Entity Detection"})

Tab3:AddToggle({
    Name = "Entity Notifier",
    Description = "Thông báo khi có entity",
    Default = false,
    Callback = function(value)
        _G.DOORS.EntityNotifier = value
    end
})

local Section3_2 = Tab3:AddSection({"Auto Avoid"})

Tab3:AddToggle({
    Name = "Auto Avoid Rush",
    Description = "Tự động trốn Rush",
    Default = false,
    Callback = function(value)
        _G.DOORS.AvoidRush = value
    end
})

Tab3:AddToggle({
    Name = "Auto Avoid Ambush",
    Description = "Tự động trốn Ambush",
    Default = false,
    Callback = function(value)
        _G.DOORS.AvoidAmbush = value
    end
})

Tab3:AddToggle({
    Name = "Avoid Eyes",
    Description = "Tránh Eyes (tự động quay đầu)",
    Default = false,
    Callback = function(value)
        _G.DOORS.AvoidEyes = value
    end
})

local Section3_3 = Tab3:AddSection({"Delete Entity"})

Tab3:AddToggle({
    Name = "Delete Seek",
    Description = "Xóa Seek",
    Default = false,
    Callback = function(value)
        _G.DOORS.DeleteSeek = value
    end
})

Tab3:AddToggle({
    Name = "Delete Screech",
    Description = "Xóa Screech",
    Default = false,
    Callback = function(value)
        _G.DOORS.DeleteScreech = value
    end
})

Tab3:AddToggle({
    Name = "Delete Halt",
    Description = "Xóa Halt",
    Default = false,
    Callback = function(value)
        _G.DOORS.DeleteHalt = value
    end
})

Tab3:AddToggle({
    Name = "Delete Dupe",
    Description = "Xóa cửa giả",
    Default = false,
    Callback = function(value)
        _G.DOORS.DeleteDupe = value
    end
})

local Section3_4 = Tab3:AddSection({"Bypass"})

Tab3:AddToggle({
    Name = "No Seek Chase",
    Description = "Bỏ qua Seek chase",
    Default = false,
    Callback = function(value)
        _G.DOORS.NoSeekChase = value
    end
})

Tab3:AddToggle({
    Name = "No Jumpscare",
    Description = "Không bị jumpscare",
    Default = false,
    Callback = function(value)
        _G.DOORS.NoJumpscare = value
    end
})

-- ==================== TAB 4: ESP ====================
local Section4_1 = Tab4:AddSection({"Object ESP"})

Tab4:AddToggle({
    Name = "Door ESP",
    Description = "Hiển thị cửa",
    Default = false,
    Callback = function(value)
        _G.DOORS.DoorESP = value
    end
})

Tab4:AddToggle({
    Name = "Key ESP",
    Description = "Hiển thị chìa khóa",
    Default = false,
    Callback = function(value)
        _G.DOORS.KeyESP = value
    end
})

Tab4:AddToggle({
    Name = "Item ESP",
    Description = "Hiển thị vật phẩm",
    Default = false,
    Callback = function(value)
        _G.DOORS.ItemESP = value
    end
})

Tab4:AddToggle({
    Name = "Closet ESP",
    Description = "Hiển thị tủ",
    Default = false,
    Callback = function(value)
        _G.DOORS.ClosetESP = value
    end
})

Tab4:AddToggle({
    Name = "Gold ESP",
    Description = "Hiển thị vàng",
    Default = false,
    Callback = function(value)
        _G.DOORS.GoldESP = value
    end
})

local Section4_2 = Tab4:AddSection({"Entity ESP"})

Tab4:AddToggle({
    Name = "Entity ESP",
    Description = "Hiển thị entity",
    Default = false,
    Callback = function(value)
        _G.DOORS.EntityESP = value
    end
})

-- ==================== TAB 5: PLAYER ====================
local Section5_1 = Tab5:AddSection({"Movement"})

Tab5:AddSlider({
    Name = "Speed",
    Description = "Tốc độ di chuyển",
    Min = 20,
    Max = 200,
    Increase = 5,
    Default = 20,
    Callback = function(value)
        _G.DOORS.Speed = value
    end
})

Tab5:AddToggle({
    Name = "Fly",
    Description = "Bay (WASD + Space/Shift)",
    Default = false,
    Callback = function(value)
        _G.DOORS.Fly = value
    end
})

Tab5:AddToggle({
    Name = "Noclip",
    Description = "Đi xuyên tường",
    Default = false,
    Callback = function(value)
        _G.DOORS.Noclip = value
    end
})

local Section5_2 = Tab5:AddSection({"Teleport"})

Tab5:AddButton({
    Name = "TP Next Door",
    Description = "TP đến cửa tiếp theo",
    Callback = function()
        pcall(function()
            local currentRoom = GetCurrentRoom()
            for _, door in pairs(Workspace.CurrentRooms:GetDescendants()) do
                if door.Name == "Door" and door.Parent.Name == tostring(currentRoom + 1) then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = door.CFrame
                    break
                end
            end
        end)
    end
})

Tab5:AddButton({
    Name = "TP to Key",
    Description = "TP đến chìa khóa",
    Callback = function()
        pcall(function()
            for _, key in pairs(Workspace.CurrentRooms:GetDescendants()) do
                if key.Name == "KeyObtain" then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = key.Hitbox.CFrame
                    break
                end
            end
        end)
    end
})

-- ==================== TAB 6: VISUAL ====================
local Section6_1 = Tab6:AddSection({"Lighting"})

Tab6:AddToggle({
    Name = "FullBright",
    Description = "Sáng toàn bộ",
    Default = false,
    Callback = function(value)
        _G.DOORS.FullBright = value
        if not value then
            Lighting.Brightness = 1
            Lighting.ClockTime = 0
            Lighting.FogEnd = 100
            Lighting.GlobalShadows = true
        end
    end
})

Tab6:AddToggle({
    Name = "No Fog",
    Description = "Xóa sương mù",
    Default = false,
    Callback = function(value)
        _G.DOORS.NoFog = value
        if value then
            Lighting.FogEnd = 100000
        else
            Lighting.FogEnd = 100
        end
    end
})

-- ==================== TAB 7: SETTINGS ====================
Tab7:AddToggle({
    Name = "Anti AFK",
    Description = "Chống AFK",
    Default = true,
    Callback = function(value)
        _G.DOORS.AntiAFK = value
    end
})

Tab7:AddButton({
    Name = "Rejoin",
    Description = "Tham gia lại game",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end
})

Tab7:AddButton({
    Name = "Copy Discord",
    Description = "Copy link Discord",
    Callback = function()
        setclipboard("https://discord.gg/khicamhub")
        Notify("Copied!", "Discord link đã copy!", 2)
    end
})

-- Anti AFK
if _G.DOORS.AntiAFK then
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end)
end

Notify("quả cam hub", "DOORS Script Loaded!\n✅ " .. GetCurrentRoom() .. " Rooms", 5)

print("=================================")
print("quả cam hub - DOORS")
print("Current Room: " .. GetCurrentRoom())
print("Script Loaded Successfully!")

print("=================================")
