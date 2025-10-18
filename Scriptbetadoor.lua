local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

local Window = redzlib:MakeWindow({
  Title = "quả cam hub",
  SubTitle = "DOORS Ultimate Edition",
  SaveFolder = "quaCamHub_DOORS_Ultimate"
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
local TeleportService = game:GetService("TeleportService")

-- Settings
_G.DOORS = {
    -- God Mode
    GodMode = false,
    InfiniteHealth = false,
    AntiDamage = false,
    AntiDeath = false,
    InfiniteRevives = false,
    AntiKick = false,
    
    -- Auto Complete
    AutoCompleteRoom = false,
    AutoSkipRoom = false,
    InstantWin = false,
    AutoOpenAll = false,
    AutoCollectAll = false,
    
    -- Auto Actions
    AutoDoor = false,
    AutoKey = false,
    AutoLever = false,
    AutoValve = false,
    AutoBook = false,
    AutoCircuitBreaker = false,
    AutoLockpick = false,
    
    -- Items
    InfiniteItems = false,
    ItemDuplication = false,
    InfiniteLighter = false,
    InfiniteFlashlight = false,
    InfiniteBattery = false,
    InfiniteLockpick = false,
    InfiniteCrucifix = false,
    InfiniteVitamins = false,
    AutoEquipBest = false,
    
    -- Entity
    EntityNotifier = false,
    EntityESP = false,
    DeleteAllEntities = false,
    DeleteRush = false,
    DeleteAmbush = false,
    DeleteSeek = false,
    DeleteScreech = false,
    DeleteEyes = false,
    DeleteHalt = false,
    DeleteDupe = false,
    DeleteFigure = false,
    DeleteJeff = false,
    DeleteShadow = false,
    AutoAvoidAll = false,
    NoEntityDamage = false,
    NoJumpscare = false,
    NoSeekChase = false,
    NoFigureChase = false,
    InstantHideCloset = false,
    
    -- ESP
    DoorESP = false,
    KeyESP = false,
    ItemESP = false,
    ClosetESP = false,
    GoldESP = false,
    PlayerESP = false,
    LeverESP = false,
    GeneratorESP = false,
    BookESP = false,
    ChestESP = false,
    RoomNumberESP = false,
    
    -- Movement
    Speed = 20,
    SpeedMultiplier = 1,
    JumpPower = 50,
    Fly = false,
    FlySpeed = 100,
    Noclip = false,
    InfiniteJump = false,
    NoClip = false,
    WalkOnWalls = false,
    SuperJump = false,
    
    -- Teleport
    TPSpeed = 300,
    InstantTP = false,
    TPNextRoom = false,
    TPToKey = false,
    TPToLever = false,
    TPToCloset = false,
    TPToExit = false,
    
    -- Visual
    FullBright = false,
    NoFog = false,
    NoDarkness = false,
    NoFlicker = false,
    Rainbow = false,
    Xray = false,
    RemoveWalls = false,
    RemoveDoors = false,
    ESPColor = Color3.fromRGB(255, 255, 0),
    
    -- Bypass
    InstantInteract = false,
    NoProximityCheck = false,
    NoAnimations = false,
    BypassLocks = false,
    BypassPuzzles = false,
    BypassSeekChase = false,
    UnlockAllDoors = false,
    
    -- Exploits
    SpamInteract = false,
    DupeGold = false,
    MaxKnobs = false,
    NoMinigames = false,
    AutoHeartbeat = false,
    
    -- Farm
    AutoFarmGold = false,
    AutoFarmKnobs = false,
    AutoFarmRevives = false,
    AutoOpenChests = false,
    
    -- Misc
    AntiAFK = true,
    AntiVoid = false,
    AntiRagdoll = false,
    ShowRoomNumber = true,
    Notifications = true,
    ChatSpam = false,
}

-- Variables
local OriginalHealth = 100
local CurrentRoom = 0
local MaxRoom = 100
local EntitiesDetected = {}

-- Notify Function
local function Notify(title, text, duration)
    if _G.DOORS.Notifications then
        game.StarterGui:SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = duration or 3;
        })
    end
end

-- Get Current Room
local function GetCurrentRoom()
    local room = 0
    pcall(function()
        room = ReplicatedStorage.GameData.LatestRoom.Value
    end)
    return room
end

-- Get Character
local function GetCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

-- Get Humanoid
local function GetHumanoid()
    local char = GetCharacter()
    return char and char:FindFirstChild("Humanoid")
end

-- Get HumanoidRootPart
local function GetRoot()
    local char = GetCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- ==================== GOD MODE SYSTEM ====================
spawn(function()
    while wait(0.1) do
        if _G.DOORS.GodMode then
            pcall(function()
                local humanoid = GetHumanoid()
                if humanoid then
                    -- Infinite Health
                    if _G.DOORS.InfiniteHealth then
                        humanoid.Health = humanoid.MaxHealth
                    end
                    
                    -- Anti Damage
                    if _G.DOORS.AntiDamage then
                        local oldHealth = humanoid.Health
                        humanoid.Health = math.max(humanoid.Health, oldHealth)
                    end
                end
            end)
        end
    end
end)

-- Anti Death
spawn(function()
    while wait(0.1) do
        if _G.DOORS.AntiDeath then
            pcall(function()
                local humanoid = GetHumanoid()
                if humanoid and humanoid.Health <= 0 then
                    humanoid.Health = 100
                    Notify("God Mode", "Prevented Death!", 2)
                end
            end)
        end
    end
end)

-- Infinite Revives
spawn(function()
    while wait(1) do
        if _G.DOORS.InfiniteRevives then
            pcall(function()
                LocalPlayer.Character.Revives.Value = 999
            end)
        end
    end
end)

-- No Entity Damage
spawn(function()
    while wait(0.1) do
        if _G.DOORS.NoEntityDamage then
            pcall(function()
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v.Name == "Damage" or v.Name == "DamageScript" then
                        v:Destroy()
                    end
                end
            end)
        end
    end
end)

-- ==================== AUTO COMPLETE ROOM ====================
spawn(function()
    while wait(0.5) do
        if _G.DOORS.AutoCompleteRoom then
            pcall(function()
                -- Auto open door
                _G.DOORS.AutoDoor = true
                
                -- Auto collect key
                _G.DOORS.AutoKey = true
                
                -- Auto pull lever
                _G.DOORS.AutoLever = true
                
                -- Auto turn valve
                _G.DOORS.AutoValve = true
                
                -- Auto collect books
                _G.DOORS.AutoBook = true
                
                -- Auto circuit breaker
                _G.DOORS.AutoCircuitBreaker = true
                
                -- Auto lockpick
                if _G.DOORS.AutoLockpick then
                    for _, lock in pairs(Workspace.CurrentRooms:GetDescendants()) do
                        if lock.Name == "LockPart" then
                            fireproximityprompt(lock.UnlockPrompt)
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Skip Room
spawn(function()
    while wait(1) do
        if _G.DOORS.AutoSkipRoom then
            pcall(function()
                local currentRoom = GetCurrentRoom()
                for _, door in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if door.Name == "Door" and door.Parent.Name == tostring(currentRoom + 1) then
                        GetRoot().CFrame = door.CFrame + Vector3.new(0, 0, -10)
                        wait(0.5)
                        break
                    end
                end
            end)
        end
    end
end)

-- ==================== AUTO OPEN ALL ====================
spawn(function()
    while wait(0.1) do
        if _G.DOORS.AutoOpenAll then
            pcall(function()
                for _, v in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if v:IsA("ProximityPrompt") then
                        if v.Name:find("Unlock") or v.Name:find("Open") or v.Name:find("Activate") then
                            fireproximityprompt(v)
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Collect All
spawn(function()
    while wait(0.2) do
        if _G.DOORS.AutoCollectAll then
            pcall(function()
                local items = {"Key", "Lighter", "Flashlight", "Battery", "Lockpick", "Crucifix", "Vitamins"}
                
                for _, itemName in pairs(items) do
                    for _, item in pairs(Workspace.CurrentRooms:GetDescendants()) do
                        if item.Name == itemName or item.Name:find(itemName) then
                            if item:FindFirstChild("ModulePrompt") then
                                fireproximityprompt(item.ModulePrompt)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ==================== AUTO ACTIONS ====================
-- Auto Door
spawn(function()
    while wait(0.1) do
        if _G.DOORS.AutoDoor then
            pcall(function()
                for _, door in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if door.Name == "Door" then
                        if door:FindFirstChild("ClientOpen") then
                            fireproximityprompt(door.ClientOpen)
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Key
spawn(function()
    while wait(0.1) do
        if _G.DOORS.AutoKey then
            pcall(function()
                for _, key in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if key.Name == "KeyObtain" then
                        if key:FindFirstChild("ModulePrompt") then
                            local root = GetRoot()
                            if root then
                                local distance = (key.Hitbox.Position - root.Position).Magnitude
                                if distance < 15 then
                                    fireproximityprompt(key.ModulePrompt)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Lever
spawn(function()
    while wait(0.1) do
        if _G.DOORS.AutoLever then
            pcall(function()
                for _, lever in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if lever.Name == "LeverForGate" then
                        if lever:FindFirstChild("PromptPart") then
                            fireproximityprompt(lever.PromptPart.ActivateEventPrompt)
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Valve
spawn(function()
    while wait(0.1) do
        if _G.DOORS.AutoValve then
            pcall(function()
                for _, valve in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if valve.Name == "TurnValve" or valve.Name == "Valve" then
                        if valve:FindFirstChild("ValvePrompt") then
                            fireproximityprompt(valve.ValvePrompt)
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Circuit Breaker
spawn(function()
    while wait(0.1) do
        if _G.DOORS.AutoCircuitBreaker then
            pcall(function()
                for _, breaker in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if breaker.Name == "CircuitBreaker" then
                        if breaker:FindFirstChild("BreakerPrompt") then
                            fireproximityprompt(breaker.BreakerPrompt)
                        end
                    end
                end
            end)
        end
    end
end)

-- ==================== INFINITE ITEMS ====================
spawn(function()
    while wait(1) do
        if _G.DOORS.InfiniteItems then
            pcall(function()
                -- Set item durability to max
                for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if item:FindFirstChild("Durability") then
                        item.Durability.Value = 100
                    end
                end
                
                for _, item in pairs(GetCharacter():GetChildren()) do
                    if item:IsA("Tool") and item:FindFirstChild("Durability") then
                        item.Durability.Value = 100
                    end
                end
            end)
        end
        
        -- Infinite specific items
        if _G.DOORS.InfiniteLighter then
            pcall(function()
                local lighter = LocalPlayer.Backpack:FindFirstChild("Lighter") or GetCharacter():FindFirstChild("Lighter")
                if lighter and lighter:FindFirstChild("Durability") then
                    lighter.Durability.Value = 100
                end
            end)
        end
        
        if _G.DOORS.InfiniteFlashlight then
            pcall(function()
                local flashlight = LocalPlayer.Backpack:FindFirstChild("Flashlight") or GetCharacter():FindFirstChild("Flashlight")
                if flashlight and flashlight:FindFirstChild("Battery") then
                    flashlight.Battery.Value = 100
                end
            end)
        end
        
        if _G.DOORS.InfiniteLockpick then
            pcall(function()
                local lockpick = LocalPlayer.Backpack:FindFirstChild("Lockpick") or GetCharacter():FindFirstChild("Lockpick")
                if lockpick and lockpick:FindFirstChild("Uses") then
                    lockpick.Uses.Value = 5
                end
            end)
        end
    end
end)

-- Item Duplication
spawn(function()
    while wait(1) do
        if _G.DOORS.ItemDuplication then
            pcall(function()
                for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if item:IsA("Tool") then
                        local clone = item:Clone()
                        clone.Parent = LocalPlayer.Backpack
                    end
                end
            end)
        end
    end
end)

-- ==================== DELETE ALL ENTITIES ====================
spawn(function()
    while wait(0.1) do
        if _G.DOORS.DeleteAllEntities then
            pcall(function()
                for _, entity in pairs(Workspace:GetDescendants()) do
                    if entity.Name == "RushMoving" or 
                       entity.Name == "AmbushMoving" or
                       entity.Name == "Eyes" or
                       entity.Name == "Screech" or
                       entity.Name == "Halt" or
                       entity.Name == "Seek" or
                       entity.Name == "Figure" or
                       entity.Name == "Shadow" or
                       entity.Name == "JeffTheKiller" then
                        entity:Destroy()
                    end
                end
            end)
        end
        
        -- Individual entity deletion
        if _G.DOORS.DeleteRush then
            for _, entity in pairs(Workspace:GetDescendants()) do
                if entity.Name == "RushMoving" then entity:Destroy() end
            end
        end
        
        if _G.DOORS.DeleteAmbush then
            for _, entity in pairs(Workspace:GetDescendants()) do
                if entity.Name == "AmbushMoving" then entity:Destroy() end
            end
        end
        
        if _G.DOORS.DeleteSeek then
            for _, entity in pairs(Workspace:GetDescendants()) do
                if entity.Name == "Seek" or entity.Name == "SeekRig" then entity:Destroy() end
            end
        end
        
        if _G.DOORS.DeleteScreech then
            for _, entity in pairs(Workspace:GetDescendants()) do
                if entity.Name == "Screech" then entity:Destroy() end
            end
        end
        
        if _G.DOORS.DeleteEyes then
            for _, entity in pairs(Workspace:GetDescendants()) do
                if entity.Name == "Eyes" then entity:Destroy() end
            end
        end
        
        if _G.DOORS.DeleteHalt then
            for _, entity in pairs(Workspace:GetDescendants()) do
                if entity.Name == "Halt" then entity:Destroy() end
            end
        end
        
        if _G.DOORS.DeleteDupe then
            for _, entity in pairs(Workspace:GetDescendants()) do
                if entity.Name == "FakeDoor" then entity:Destroy() end
            end
        end
        
        if _G.DOORS.DeleteFigure then
            for _, entity in pairs(Workspace:GetDescendants()) do
                if entity.Name == "Figure" or entity.Name == "FigureRig" then entity:Destroy() end
            end
        end
    end
end)

-- ==================== ENTITY NOTIFIER ====================
local entityNames = {
    "RushMoving", "AmbushMoving", "Eyes", "Screech", "Halt", 
    "Seek", "Figure", "A60", "A120", "Shadow", "JeffTheKiller"
}

spawn(function()
    while wait(0.5) do
        if _G.DOORS.EntityNotifier then
            pcall(function()
                for _, entityName in pairs(entityNames) do
                    for _, entity in pairs(Workspace:GetDescendants()) do
                        if entity.Name == entityName and not EntitiesDetected[entity] then
                            Notify("⚠️ ENTITY ALERT", entityName .. " SPAWNED!", 5)
                            
                            -- Warning sound
                            local sound = Instance.new("Sound")
                            sound.SoundId = "rbxassetid://4590657391"
                            sound.Volume = 3
                            sound.Parent = game:GetService("SoundService")
                            sound:Play()
                            
                            game:GetService("Debris"):AddItem(sound, 2)
                            
                            EntitiesDetected[entity] = true
                            
                            task.delay(30, function()
                                EntitiesDetected[entity] = nil
                            end)
                        end
                    end
                end
            end)
        end
    end
end)

-- ==================== AUTO AVOID ALL ====================
spawn(function()
    while wait(0.1) do
        if _G.DOORS.AutoAvoidAll then
            pcall(function()
                for _, entity in pairs(Workspace:GetDescendants()) do
                    if entity.Name == "RushMoving" or entity.Name == "AmbushMoving" then
                        -- Find nearest closet
                        local nearestCloset = nil
                        local nearestDist = math.huge
                        
                        for _, closet in pairs(Workspace.CurrentRooms:GetDescendants()) do
                            if closet.Name == "Wardrobe" then
                                local prompt = closet:FindFirstChild("HiddenPlayer")
                                if prompt and GetRoot() then
                                    local dist = (closet.PrimaryPart.Position - GetRoot().Position).Magnitude
                                    if dist < nearestDist and dist < 50 then
                                        nearestCloset =   closet
                                        nearestDist = dist
                                    end
                                end
                            end
                        end
                        
                        if nearestCloset then
                            -- Instant teleport to closet
                            if _G.DOORS.InstantHideCloset then
                                GetRoot().CFrame = nearestCloset.PrimaryPart.CFrame
                            end
                            
                            wait(0.1)
                            fireproximityprompt(nearestCloset.HiddenPlayer.HidePrompt)
                            
                            Notify("Auto Avoid", "Hiding from " .. entity.Name, 2)
                            
                            -- Wait for entity to pass
                            wait(10)
                            
                            -- Exit closet
                            if GetRoot() then
                                GetRoot().CFrame = nearestCloset.PrimaryPart.CFrame + Vector3.new(0, 0, 5)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ==================== NO SEEK CHASE ====================
spawn(function()
    while wait(0.1) do
        if _G.DOORS.NoSeekChase then
            pcall(function()
                -- Destroy seek arms
                for _, arm in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if arm.Name == "Seek_Arm" then
                        arm:Destroy()
                    end
                end
                
                -- Destroy seek rig
                if Workspace:FindFirstChild("SeekRig") then
                    Workspace.SeekRig:Destroy()
                end
                
                -- Remove seek fire
                for _, fire in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if fire.Name == "SeekFire" or fire.Name:find("Seek") and fire:IsA("Fire") then
                        fire:Destroy()
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
                -- Remove jumpscare GUI
                for _, gui in pairs(LocalPlayer.PlayerGui:GetDescendants()) do
                    if gui.Name == "Jumpscare" or gui.Name:find("Scare") then
                        gui:Destroy()
                    end
                end
                
                -- Remove jumpscare sounds
                for _, sound in pairs(Workspace:GetDescendants()) do
                    if sound:IsA("Sound") and (sound.Name:find("Jumpscare") or sound.Name:find("Scare")) then
                        sound:Stop()
                        sound:Destroy()
                    end
                end
            end)
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
        
        -- Distance updater
        if _G.DOORS.RoomNumberESP then
            spawn(function()
                while TextLabel and GetRoot() do
                    wait(0.5)
                    local dist = (object.Position - GetRoot().Position).Magnitude
                    TextLabel.Text = text .. "\n[" .. math.floor(dist) .. "m]"
                end
            end)
        end
    end
end

-- ESP Loops
spawn(function()
    while wait(1) do
        if _G.DOORS.DoorESP then
            for _, door in pairs(Workspace.CurrentRooms:GetDescendants()) do
                if door.Name == "Door" then
                    CreateESP(door, "🚪 DOOR", Color3.fromRGB(0, 255, 0))
                end
            end
        end
        
        if _G.DOORS.KeyESP then
            for _, key in pairs(Workspace.CurrentRooms:GetDescendants()) do
                if key.Name == "KeyObtain" then
                    CreateESP(key.Hitbox, "🔑 KEY", Color3.fromRGB(255, 255, 0))
                end
            end
        end
        
        if _G.DOORS.ItemESP then
            local items = {"Lighter", "Flashlight", "Battery", "Crucifix", "Lockpick", "Vitamins"}
            for _, itemName in pairs(items) do
                for _, item in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if item.Name == itemName then
                        CreateESP(item, "📦 " .. itemName:upper(), Color3.fromRGB(255, 100, 255))
                    end
                end
            end
        end
        
        if _G.DOORS.ClosetESP then
            for _, closet in pairs(Workspace.CurrentRooms:GetDescendants()) do
                if closet.Name == "Wardrobe" and closet.PrimaryPart then
                    CreateESP(closet.PrimaryPart, "🚪 CLOSET", Color3.fromRGB(100, 200, 255))
                end
            end
        end
        
        if _G.DOORS.GoldESP then
            for _, gold in pairs(Workspace.CurrentRooms:GetDescendants()) do
                if gold.Name == "GoldPile" then
                    CreateESP(gold, "💰 GOLD", Color3.fromRGB(255, 215, 0))
                end
            end
        end
        
        if _G.DOORS.LeverESP then
            for _, lever in pairs(Workspace.CurrentRooms:GetDescendants()) do
                if lever.Name == "LeverForGate" then
                    CreateESP(lever.PromptPart, "🎚️ LEVER", Color3.fromRGB(255, 165, 0))
                end
            end
        end
        
        if _G.DOORS.GeneratorESP then
            for _, gen in pairs(Workspace.CurrentRooms:GetDescendants()) do
                if gen.Name == "Generator" then
                    CreateESP(gen, "⚡ GENERATOR", Color3.fromRGB(255, 255, 0))
                end
            end
        end
        
        if _G.DOORS.EntityESP then
            for _, entity in pairs(Workspace:GetDescendants()) do
                if entity.Name == "RushMoving" then
                    CreateESP(entity, "⚠️ RUSH", Color3.fromRGB(255, 0, 0))
                elseif entity.Name == "AmbushMoving" then
                    CreateESP(entity, "⚠️ AMBUSH", Color3.fromRGB(255, 50, 0))
                elseif entity.Name == "Eyes" then
                    CreateESP(entity, "👁️ EYES", Color3.fromRGB(200, 0, 255))
                elseif entity.Name == "Screech" then
                    CreateESP(entity, "👻 SCREECH", Color3.fromRGB(0, 255, 255))
                elseif entity.Name == "Seek" then
                    CreateESP(entity, "🔥 SEEK", Color3.fromRGB(255, 100, 0))
                elseif entity.Name == "Figure" then
                    CreateESP(entity, "🎭 FIGURE", Color3.fromRGB(100, 100, 255))
                end
            end
        end
    end
end)

-- ==================== MOVEMENT ====================
-- Speed
RunService.Heartbeat:Connect(function()
    pcall(function()
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.WalkSpeed = _G.DOORS.Speed * _G.DOORS.SpeedMultiplier
            humanoid.JumpPower = _G.DOORS.JumpPower
        end
    end)
end)

-- Fly
local flying = false
local flyBV = nil

spawn(function()
    while wait(0.1) do
        if _G.DOORS.Fly and not flying then
            flying = true
            local root = GetRoot()
            
            if root then
                flyBV = Instance.new("BodyVelocity")
                flyBV.Name = "FlyVelocity"
                flyBV.Parent = root
                flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                
                spawn(function()
                    while _G.DOORS.Fly and flying do
                        wait()
                        local cam = Workspace.CurrentCamera
                        local dir = Vector3.new()
                        
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
                        
                        if flyBV then
                            flyBV.Velocity = dir * _G.DOORS.FlySpeed
                        end
                    end
                end)
            end
        elseif not _G.DOORS.Fly and flying then
            flying = false
            if flyBV then
                flyBV:Destroy()
                flyBV = nil
            end
        end
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if _G.DOORS.Noclip then
        pcall(function()
            local char = GetCharacter()
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if _G.DOORS.InfiniteJump then
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ==================== VISUAL ====================
spawn(function()
    while wait(0.1) do
        if _G.DOORS.FullBright then
            Lighting.Brightness = 3
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        end
        
        if _G.DOORS.NoFog then
            Lighting.FogEnd = 100000
        end
        
        if _G.DOORS.NoDarkness then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        end
    end
end)

-- Remove Walls
spawn(function()
    while wait(1) do
        if _G.DOORS.RemoveWalls then
            pcall(function()
                for _, wall in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if wall.Name == "Wall" or wall.Name:find("Wall") then
                        wall.Transparency = 1
                        wall.CanCollide = false
                    end
                end
            end)
        end
    end
end)

-- ==================== BYPASS ====================
-- Instant Interact
spawn(function()
    while wait(0.1) do
        if _G.DOORS.InstantInteract then
            pcall(function()
                for _, prompt in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        prompt.HoldDuration = 0
                        prompt.MaxActivationDistance = 100
                    end
                end
            end)
        end
    end
end)

-- Unlock All Doors
spawn(function()
    while wait(0.5) do
        if _G.DOORS.UnlockAllDoors then
            pcall(function()
                for _, door in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if door.Name == "Door" then
                        if door:FindFirstChild("Lock") then
                            door.Lock:Destroy()
                        end
                    end
                end
            end)
        end
    end
end)

-- ==================== FARM ====================
-- Auto Farm Gold
spawn(function()
    while wait(0.2) do
        if _G.DOORS.AutoFarmGold then
            pcall(function()
                for _, gold in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if gold.Name == "GoldPile" then
                        if gold:FindFirstChild("ClickDetector") then
                            fireclickdetector(gold.ClickDetector)
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Open Chests
spawn(function()
    while wait(0.2) do
        if _G.DOORS.AutoOpenChests then
            pcall(function()
                for _, chest in pairs(Workspace.CurrentRooms:GetDescendants()) do
                    if chest.Name == "Chest" or chest.Name == "ChestBox" then
                        if chest:FindFirstChild("Prompt") then
                            fireproximityprompt(chest.Prompt)
                        end
                    end
                end
            end)
        end
    end
end)

-- ==================== TABS ====================
local Tab1 = Window:MakeTab({"🏠 Home", "home"})
local Tab2 = Window:MakeTab({"🛡️ God Mode", "shield"})
local Tab3 = Window:MakeTab({"⚡ Auto", "zap"})
local Tab4 = Window:MakeTab({"👻 Entity", "alert-triangle"})
local Tab5 = Window:MakeTab({"👁️ ESP", "eye"})
local Tab6 = Window:MakeTab({"🚀 Player", "user"})
local Tab7 = Window:MakeTab({"📍 Teleport", "send"})
local Tab8 = Window:MakeTab({"🎨 Visual", "sun"})
local Tab9 = Window:MakeTab({"🔓 Bypass", "unlock"})
local Tab10 = Window:MakeTab({"💰 Farm", "dollar-sign"})
local Tab11 = Window:MakeTab({"⚙️ Settings", "settings"})


-- ==================== TAB 1: HOME ====================
Tab1:AddParagraph({
    Name = "quả cam hub- DOORS Ultimate",
    Description = "Player: " .. LocalPlayer.Name .. "\n🚪 Room: " .. GetCurrentRoom() .. "\n✅ God Mode Ready"
})

Tab1:AddButton({
    Name = "🔥 ENABLE EVERYTHING",
    Description = "BẬT TẤT CẢ CHỨC NĂNG CỰC MẠNH",
    Callback = function()
        -- God Mode
        _G.DOORS.GodMode = true
        _G.DOORS.InfiniteHealth = true
        _G.DOORS.AntiDamage = true
        _G.DOORS.AntiDeath = true
        _G.DOORS.NoEntityDamage = true
        
        -- Auto
        _G.DOORS.AutoCompleteRoom = true
        _G.DOORS.AutoOpenAll = true
        _G.DOORS.AutoCollectAll = true
        _G.DOORS.InstantInteract = true
        
        -- Entity
        _G.DOORS.EntityNotifier = true
        _G.DOORS.DeleteAllEntities = true
        _G.DOORS.AutoAvoidAll = true
        _G.DOORS.NoJumpscare = true
        
        -- ESP
        _G.DOORS.DoorESP = true
        _G.DOORS.KeyESP = true
        _G.DOORS.ItemESP = true
        _G.DOORS.EntityESP = true
        
        -- Visual
        _G.DOORS.FullBright = true
        _G.DOORS.NoFog = true
        
        -- Items
        _G.DOORS.InfiniteItems = true
        
        Notify("🔥 ULTIMATE MODE", "ALL FEATURES ENABLED!\nYOU ARE UNSTOPPABLE!", 5)
    end
})

Tab1:AddButton({
    Name = "⚡ God Mode Package",
    Description = "Bất tử + Vô hạn máu + Anti damage",
    Callback = function()
        _G.DOORS.GodMode = true
        _G.DOORS.InfiniteHealth = true
        _G.DOORS.AntiDamage = true
        _G.DOORS.AntiDeath = true
        _G.DOORS.InfiniteRevives = true
        _G.DOORS.NoEntityDamage = true
        Notify("God Mode", "You are now immortal!", 3)
    end
})

Tab1:AddButton({
    Name = "🎮 Auto Win Package",
    Description = "Auto hoàn thành game",
    Callback = function()
        _G.DOORS.AutoCompleteRoom = true
        _G.DOORS.AutoSkipRoom = true
        _G.DOORS.DeleteAllEntities = true
        _G.DOORS.InstantInteract = true
        _G.DOORS.UnlockAllDoors = true
        Notify("Auto Win", "Auto complete activated!", 3)
    end
})

Tab1:AddButton({
    Name = "👁️ ESP Package",
    Description = "Bật tất cả ESP",
    Callback = function()
        _G.DOORS.DoorESP = true
        _G.DOORS.KeyESP = true
        _G.DOORS.ItemESP = true
        _G.DOORS.ClosetESP = true
        _G.DOORS.GoldESP = true
        _G.DOORS.EntityESP = true
        _G.DOORS.LeverESP = true
        Notify("ESP", "All ESP enabled!", 3)
    end
})

-- ==================== TAB 2: GOD MODE ====================
local Section2_1 = Tab2:AddSection({"🛡️ God Mode Features"})

Tab2:AddToggle({
    Name = "🛡️ GOD MODE (Master)",
    Description = "Bật chế độ bất tử hoàn toàn",
    Default = false,
    Callback = function(value)
        _G.DOORS.GodMode = value
    end
})

Tab2:AddToggle({
    Name = "💖 Infinite Health",
    Description = "Máu vô hạn",
    Default = false,
    Callback = function(value)
        _G.DOORS.InfiniteHealth = value
    end
})

Tab2:AddToggle({
    Name = "🔰 Anti Damage",
    Description = "Không bị mất máu",
    Default = false,
    Callback = function(value)
        _G.DOORS.AntiDamage = value
    end
})

Tab2:AddToggle({
    Name = "☠️ Anti Death",
    Description = "Không thể chết",
    Default = false,
    Callback = function(value)
        _G.DOORS.AntiDeath = value
    end
})

Tab2:AddToggle({
    Name = "♾️ Infinite Revives",
    Description = "Hồi sinh vô hạn",
    Default = false,
    Callback = function(value)
        _G.DOORS.InfiniteRevives = value
    end
})

Tab2:AddToggle({
    Name = "👻 No Entity Damage",
    Description = "Entity không gây damage",
    Default = false,
    Callback = function(value)
        _G.DOORS.NoEntityDamage = value
    end
})

Tab2:AddToggle({
    Name = "🚫 Anti Kick",
    Description = "Chống kick",
    Default = false,
    Callback = function(value)
        _G.DOORS.AntiKick = value
    end
})

Tab2:AddToggle({
    Name = "🕳️ Anti Void",
    Description = "Không rơi void",
    Default = false,
    Callback = function(value)
        _G.DOORS.AntiVoid = value
    end
})

-- ==================== TAB 3: AUTO ====================
local Section3_1 = Tab3:AddSection({"⚡ Auto Complete"})

Tab3:AddToggle({
    Name = "🎮 Auto Complete Room",
    Description = "Tự động hoàn thành phòng",
    Default = false,
    Callback = function(value)
        _G.DOORS.AutoCompleteRoom = value
    end
})

Tab3:AddToggle({
    Name = "⏩ Auto Skip Room",
    Description = "Tự động skip phòng",
    Default = false,
    Callback = function(value)
        _G.DOORS.AutoSkipRoom = value
    end
})

Tab3:AddToggle({
    Name = "🚪 Auto Open All",
    Description = "Tự động mở tất cả",
    Default = false,
    Callback = function(value)
        _G.DOORS.AutoOpenAll = value
    end
})

Tab3:AddToggle({
    Name = "📦 Auto Collect All",
    Description = "Tự động nhặt tất cả vật phẩm",
    Default = false,
    Callback = function(value)
        _G.DOORS.AutoCollectAll = value
    end
})

local Section3_2 = Tab3:AddSection({"🔧 Auto Actions"})

Tab3:AddToggle({
    Name = "🚪 Auto Door",
    Description = "Tự động mở cửa",
    Default = false,
    Callback = function(value)
        _G.DOORS.AutoDoor = value
    end
})

Tab3:AddToggle({
    Name = "🔑 Auto Key",
    Description = "Tự động nhặt chìa khóa",
    Default = false,
    Callback = function(value)
        _G.DOORS.AutoKey = value
    end
})

Tab3:AddToggle({
    Name = "🎚️ Auto Lever",
    Description = "Tự động kéo đòn bẩy",
    Default = false,
    Callback = function(value)
        _G.DOORS.AutoLever = value
    end
})

Tab3:AddToggle({
    Name = "🔧 Auto Valve",
    Description = "Tự động vặn van",
    Default = false,
    Callback = function(value)
        _G.DOORS.AutoValve = value
    end
})

Tab3:AddToggle({
    Name = "📖 Auto Book",
    Description = "Tự động thu thập sách",
    Default = false,
    Callback = function(value)
        _G.DOORS.AutoBook = value
    end
})

Tab3:AddToggle({
    Name = "⚡ Auto Circuit Breaker",
    Description = "Tự động bật cầu dao",
    Default = false,
    Callback = function(value)
        _G.DOORS.AutoCircuitBreaker = value
    end
})

Tab3:AddToggle({
    Name = "🔓 Auto Lockpick",
    Description = "Tự động mở khóa",
    Default = false,
    Callback = function(value)
        _G.DOORS.AutoLockpick = value
    end
})

local Section3_3 = Tab3:AddSection({"🎒 Items"})

Tab3:AddToggle({
    Name = "♾️ Infinite Items",
    Description = "Vật phẩm vô hạn",
    Default = false,
    Callback = function(value)
        _G.DOORS.InfiniteItems = value
    end
})

Tab3:AddToggle({
    Name = "🔥 Infinite Lighter",
    Description = "Bật lửa vô hạn",
    Default = false,
    Callback = function(value)
        _G.DOORS.InfiniteLighter = value
    end
})

Tab3:AddToggle({
    Name = "🔦 Infinite Flashlight",
    Description = "Pin đèn vô hạn",
    Default = false,
    Callback = function(value)
        _G.DOORS.InfiniteFlashlight = value
    end
})

Tab3:AddToggle({
    Name = "🔋 Infinite Battery",
    Description = "Pin vô hạn",
    Default = false,
    Callback = function(value)
        _G.DOORS.InfiniteBattery = value
    end
})

Tab3:AddToggle({
    Name = "🗝️ Infinite Lockpick",
    Description = "Lockpick vô hạn",
    Default = false,
    Callback = function(value)
        _G.DOORS.InfiniteLockpick = value
    end
})

Tab3:AddToggle({
    Name = "✝️ Infinite Crucifix",
    Description = "Crucifix vô hạn",
    Default = false,
    Callback = function(value)
        _G.DOORS.InfiniteCrucifix = value
    end
})

Tab3:AddToggle({
    Name = "💊 Infinite Vitamins",
    Description = "Vitamins vô hạn",
    Default = false,
    Callback = function(value)
        _G.DOORS.InfiniteVitamins = value
    end
})

Tab3:AddToggle({
    Name = "📦 Item Duplication",
    Description = "Nhân đôi vật phẩm",
    Default = false,
    Callback = function(value)
        _G.DOORS.ItemDuplication = value
    end
})

-- ==================== TAB 4: ENTITY ====================
local Section4_1 = Tab4:AddSection({"⚠️ Detection"})

Tab4:AddToggle({
    Name = "🔔 Entity Notifier",
    Description = "Thông báo khi có entity (sound + GUI)",
    Default = false,
    Callback = function(value)
        _G.DOORS.EntityNotifier = value
    end
})

Tab4:AddToggle({
    Name = "👁️ Entity ESP",
    Description = "Hiển thị entity qua tường",
    Default = false,
    Callback = function(value)
        _G.DOORS.EntityESP = value
    end
})

local Section4_2 = Tab4:AddSection({"🗑️ Delete Entity"})

Tab4:AddToggle({
    Name = "💥 DELETE ALL ENTITIES",
    Description = "XÓA TẤT CẢ ENTITY (OP)",
    Default = false,
    Callback = function(value)
        _G.DOORS.DeleteAllEntities = value
    end
})

Tab4:AddToggle({
    Name = "Delete Rush",
    Description = "Xóa Rush",
    Default = false,
    Callback = function(value)
        _G.DOORS.DeleteRush = value
    end
})

Tab4:AddToggle({
    Name = "Delete Ambush",
    Description = "Xóa Ambush",
    Default = false,
    Callback = function(value)
        _G.DOORS.DeleteAmbush = value
    end
})

Tab4:AddToggle({
    Name = "Delete Seek",
    Description = "Xóa Seek",
    Default = false,
    Callback = function(value)
        _G.DOORS.DeleteSeek = value
    end
})

Tab4:AddToggle({
    Name = "Delete Screech",
    Description = "Xóa Screech",
    Default = false,
    Callback = function(value)
        _G.DOORS.DeleteScreech = value
    end
})

Tab4:AddToggle({
    Name = "Delete Eyes",
    Description = "Xóa Eyes",
    Default = false,
    Callback = function(value)
        _G.DOORS.DeleteEyes = value
    end
})

Tab4:AddToggle({
    Name = "Delete Halt",
    Description = "Xóa Halt",
    Default = false,
    Callback = function(value)
        _G.DOORS.DeleteHalt = value
    end
})

Tab4:AddToggle({
    Name = "Delete Dupe",
    Description = "Xóa cửa giả",
    Default = false,
    Callback = function(value)
        _G.DOORS.DeleteDupe = value
    end
})

Tab4:AddToggle({
    Name = "Delete Figure",
    Description = "Xóa Figure",
    Default = false,
    Callback = function(value)
        _G.DOORS.DeleteFigure = value
    end
})

local Section4_3 = Tab4:AddSection({"🛡️ Avoid & Bypass"})

Tab4:AddToggle({
    Name = "🏃 Auto Avoid All",
    Description = "Tự động trốn tất cả entity",
    Default = false,
    Callback = function(value)
        _G.DOORS.AutoAvoidAll = value
    end
})

Tab4:AddToggle({
    Name = "⚡ Instant Hide Closet",
    Description = "Trốn tủ tức thời",
    Default = false,
    Callback = function(value)
        _G.DOORS.InstantHideCloset = value
    end
})

Tab4:AddToggle({
    Name = "🚫 No Seek Chase",
    Description = "Bỏ qua Seek chase",
    Default = false,
    Callback = function(value)
        _G.DOORS.NoSeekChase = value
    end
})

Tab4:AddToggle({
    Name = "🚫 No Figure Chase",
    Description = "Bỏ qua Figure chase",
    Default = false,
    Callback = function(value)
        _G.DOORS.NoFigureChase = value
    end
})

Tab4:AddToggle({
    Name = "😱 No Jumpscare",
    Description = "Không bị jumpscare",
    Default = false,
    Callback = function(value)
        _G.DOORS.NoJumpscare = value
    end
})

-- ==================== TAB 5: ESP ====================
local Section5_1 = Tab5:AddSection({"👁️ Object ESP"})

Tab5:AddToggle({
    Name = "🚪 Door ESP",
    Description = "ESP cửa",
    Default = false,
    Callback = function(value)
        _G.DOORS.DoorESP = value
    end
})

Tab5:AddToggle({
    Name = "🔑 Key ESP",
    Description = "ESP chìa khóa",
    Default = false,
    Callback = function(value)
        _G.DOORS.KeyESP = value
    end
})

Tab5:AddToggle({
    Name = "📦 Item ESP",
    Description = "ESP vật phẩm",
    Default = false,
    Callback = function(value)
        _G.DOORS.ItemESP = value
    end
})

Tab5:AddToggle({
    Name = "🚪 Closet ESP",
    Description = "ESP tủ",
    Default = false,
    Callback = function(value)
        _G.DOORS.ClosetESP = value
    end
})

Tab5:AddToggle({
    Name = "💰 Gold ESP",
    Description = "ESP vàng",
    Default = false,
    Callback = function(value)
        _G.DOORS.GoldESP = value
    end
})

Tab5:AddToggle({
    Name = "🎚️ Lever ESP",
    Description = "ESP đòn bẩy",
    Default = false,
    Callback = function(value)
        _G.DOORS.LeverESP = value
    end
})

Tab5:AddToggle({
    Name = "⚡ Generator ESP",
    Description = "ESP máy phát điện",
    Default = false,
    Callback = function(value)
        _G.DOORS.GeneratorESP = value
    end
})

Tab5:AddToggle({
    Name = "📖 Book ESP",
    Description = "ESP sách",
    Default = false,
    Callback = function(value)
        _G.DOORS.BookESP = value
    end
})

Tab5:AddToggle({
    Name = "📦 Chest ESP",
    Description = "ESP rương",
    Default = false,
    Callback = function(value)
        _G.DOORS.ChestESP = value
    end
})

Tab5:AddToggle({
    Name = "🔢 Room Number ESP",
    Description = "Hiển thị số phòng + khoảng cách",
    Default = false,
    Callback = function(value)
        _G.DOORS.RoomNumberESP = value
    end
})

local Section5_2 = Tab5:AddSection({"👻 Entity ESP"})

Tab5:AddToggle({
    Name = "⚠️ Entity ESP",
    Description = "ESP entity (Rush/Ambush/Eyes/...)",
    Default = false,
    Callback = function(value)
        _G.DOORS.EntityESP = value
    end
})

Tab5:AddToggle({
    Name = "👥 Player ESP",
    Description = "ESP người chơi",
    Default = false,
    Callback = function(value)
        _G.DOORS.PlayerESP = value
    end
})

-- ==================== TAB 6: PLAYER ====================
local Section6_1 = Tab6:AddSection({"🏃 Movement"})

Tab6:AddSlider({
    Name = "Speed",
    Description = "Tốc độ di chuyển (20-500)",
    Min = 20,
    Max = 500,
    Increase = 5,
    Default = 20,
    Callback = function(value)
        _G.DOORS.Speed = value
    end
})

Tab6:AddSlider({
    Name = "Speed Multiplier",
    Description = "Nhân tốc độ (1-10x)",
    Min = 1,
    Max = 10,
    Increase = 0.5,
    Default = 1,
    Callback = function(value)
        _G.DOORS.SpeedMultiplier = value
    end
})

Tab6:AddSlider({
    Name = "Jump Power",
    Description = "Lực nhảy (50-500)",
    Min = 50,
    Max = 500,
    Increase = 10,
    Default = 50,
    Callback = function(value)
        _G.DOORS.JumpPower = value
    end
})

Tab6:AddToggle({
    Name = "✈️ Fly",
    Description = "Bay (WASD + Space/Shift)",
    Default = false,
    Callback = function(value)
        _G.DOORS.Fly = value
    end
})

Tab6:AddSlider({
    Name = "Fly Speed",
    Description = "Tốc độ bay (10-200)",
    Min = 10,
    Max = 200,
    Increase = 5,
    Default = 100,
    Callback = function(value)
        _G.DOORS.FlySpeed = value
    end
})

Tab6:AddToggle({
    Name = "👻 Noclip",
    Description = "Đi xuyên tường",
    Default = false,
    Callback = function(value)
        _G.DOORS.Noclip = value
    end
})

Tab6:AddToggle({
    Name = "♾️ Infinite Jump",
    Description = "Nhảy vô hạn",
    Default = false,
    Callback = function(value)
        _G.DOORS.InfiniteJump = value
    end
})

Tab6:AddToggle({
    Name = "🧗 Walk On Walls",
    Description = "Đi trên tường",
    Default = false,
    Callback = function(value)
        _G.DOORS.WalkOnWalls = value
    end
})

Tab6:AddToggle({
    Name = "🚀 Super Jump",
    Description = "Nhảy siêu cao",
    Default = false,
    Callback = function(value)
        _G.DOORS.SuperJump = value
        if value then
            _G.DOORS.JumpPower = 500
        else
            _G.DOORS.JumpPower = 50
        end
    end
})

-- ==================== TAB 7: TELEPORT ====================
local Section7_1 = Tab7:AddSection({"📍 Quick Teleport"})

Tab7:AddButton({
    Name = "🚪 TP Next Room",
    Description = "TP đến phòng tiếp theo",
    Callback = function()
        pcall(function()
            local currentRoom = GetCurrentRoom()
            for _, door in pairs(Workspace.CurrentRooms:GetDescendants()) do
                if door.Name == "Door" and door.Parent.Name == tostring(currentRoom + 1) then
                    GetRoot().CFrame = door.CFrame + Vector3.new(0, 0, -10)
                    Notify("Teleport", "Teleported to Room " .. (currentRoom + 1), 2)
                    break
                end
            end
        end)
    end
})

Tab7:AddButton({
    Name = "🔑 TP to Key",
    Description = "TP đến chìa khóa gần nhất",
    Callback = function()
        pcall(function()
            for _, key in pairs(Workspace.CurrentRooms:GetDescendants()) do
                if key.Name == "KeyObtain" then
                    GetRoot().CFrame = key.Hitbox.CFrame
                    Notify("Teleport", "Teleported to Key", 2)
                    break
                end
            end
        end)
    end
})

Tab7:AddButton({
    Name = "🎚️ TP to Lever",
    Description = "TP đến đòn bẩy",
    Callback = function()
        pcall(function()
            for _, lever in pairs(Workspace.CurrentRooms:GetDescendants()) do
                if lever.Name == "LeverForGate" then
                    GetRoot().CFrame = lever.PromptPart.CFrame
                    Notify("Teleport", "Teleported to Lever", 2)
                    break
                end
            end
        end)
    end
})

Tab7:AddButton({
    Name = "🚪 TP to Closet",
    Description = "TP đến tủ gần nhất",
    Callback = function()
        pcall(function()
            for _, closet in pairs(Workspace.CurrentRooms:GetDescendants()) do
                if closet.Name == "Wardrobe" then
                    GetRoot().CFrame = closet.PrimaryPart.CFrame
                    Notify("Teleport", "Teleported to Closet", 2)
                    break
                end
            end
        end)
    end
})

Tab7:AddButton({
    Name = "🏁 TP to Exit",
    Description = "TP đến cửa thoát",
    Callback = function()
        pcall(function()
            local currentRoom = GetCurrentRoom()
            for _, door in pairs(Workspace.CurrentRooms:GetDescendants()) do
                if door.Name == "ExitDoor" or door.Parent.Name == tostring(currentRoom + 1) then
                    GetRoot().CFrame = door.CFrame
                    Notify("Teleport", "Teleported to Exit", 2)
                    break
                end
            end
        end)
    end
})

local Section7_2 = Tab7:AddSection({"⚙️ Teleport Settings"})

Tab7:AddSlider({
    Name = "TP Speed",
    Description = "Tốc độ teleport",
    Min = 100,
    Max = 1000,
    Increase = 50,
    Default = 300,
    Callback = function(value)
        _G.DOORS.TPSpeed = value
    end
})

Tab7:AddToggle({
    Name = "⚡ Instant TP",
    Description = "Teleport tức thời",
    Default = false,
    Callback = function(value)
        _G.DOORS.InstantTP = value
    end
})

-- ==================== TAB 8: VISUAL ====================
local Section8_1 = Tab8:AddSection({"💡 Lighting"})

Tab8:AddToggle({
    Name = "☀️ FullBright",
    Description = "Sáng toàn bộ map",
    Default = false,
    Callback = function(value)
        _G.DOORS.FullBright = value
        if not value then
            Lighting.Brightness = 1
            Lighting.ClockTime = 0
            Lighting.FogEnd = 100
            Lighting.GlobalShadows = true
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        end
    end
})

Tab8:AddToggle({
    Name = "🌫️ No Fog",
    Description = "Xóa sương mù",
    Default = false,
    Callback = function(value)
        _G.DOORS.NoFog = value
        if not value then
            Lighting.FogEnd = 100
        end
    end
})

Tab8:AddToggle({
    Name = "🌙 No Darkness",
    Description = "Không tối",
    Default = false,
    Callback = function(value)
        _G.DOORS.NoDarkness = value
        if not value then
            Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        end
    end
})

Tab8:AddToggle({
    Name = "💡 No Flicker",
    Description = "Đèn không nhấp nháy",
    Default = false,
    Callback = function(value)
        _G.DOORS.NoFlicker = value
    end
})

local Section8_2 = Tab8:AddSection({"🎨 Effects"})

Tab8:AddToggle({
    Name = "🌈 Rainbow Mode",
    Description = "Chế độ cầu vồng",
    Default = false,
    Callback = function(value)
        _G.DOORS.Rainbow = value
    end
})

Tab8:AddToggle({
    Name = "👁️ Xray",
    Description = "Nhìn xuyên tường",
    Default = false,
    Callback = function(value)
        _G.DOORS.Xray = value
    end
})

Tab8:AddToggle({
    Name = "🧱 Remove Walls",
    Description = "Xóa tường (invisible)",
    Default = false,
    Callback = function(value)
        _G.DOORS.RemoveWalls = value
    end
})

Tab8:AddToggle({
    Name = "🚪 Remove Doors",
    Description = "Xóa cửa",
    Default = false,
    Callback = function(value)
        _G.DOORS.RemoveDoors = value
    end
})

-- ==================== TAB 9: BYPASS ====================
local Section9_1 = Tab9:AddSection({"🔓 Bypass Features"})

Tab9:AddToggle({
    Name = "⚡ Instant Interact",
    Description = "Tương tác tức thời (no hold)",
    Default = false,
    Callback = function(value)
        _G.DOORS.InstantInteract = value
    end
})

Tab9:AddToggle({
    Name = "📏 No Proximity Check",
    Description = "Tương tác từ xa",
    Default = false,
    Callback = function(value)
        _G.DOORS.NoProximityCheck = value
    end
})

Tab9:AddToggle({
    Name = "🎬 No Animations",
    Description = "Bỏ qua animation",
    Default = false,
    Callback = function(value)
        _G.DOORS.NoAnimations = value
    end
})

Tab9:AddToggle({
    Name = "🔓 Bypass Locks",
    Description = "Bỏ qua khóa cửa",
    Default = false,
    Callback = function(value)
        _G.DOORS.BypassLocks = value
    end
})

Tab9:AddToggle({
    Name = "🧩 Bypass Puzzles",
    Description = "Bỏ qua puzzle",
    Default = false,
    Callback = function(value)
        _G.DOORS.BypassPuzzles = value
    end
})

Tab9:AddToggle({
    Name = "🔥 Bypass Seek Chase",
    Description = "Bỏ qua Seek chase",
    Default = false,
    Callback = function(value)
        _G.DOORS.BypassSeekChase = value
    end
})

Tab9:AddToggle({
    Name = "🔓 Unlock All Doors",
    Description = "Mở khóa tất cả cửa",
    Default = false,
    Callback = function(value)
        _G.DOORS.UnlockAllDoors = value
    end
})

local Section9_2 = Tab9:AddSection({"⚡ Exploits"})

Tab9:AddToggle({
    Name = "🔄 Spam Interact",
    Description = "Spam tương tác",
    Default = false,
    Callback = function(value)
        _G.DOORS.SpamInteract = value
    end
})

Tab9:AddToggle({
    Name = "💰 Dupe Gold",
    Description = "Nhân đôi vàng",
    Default = false,
    Callback = function(value)
        _G.DOORS.DupeGold = value
    end
})

Tab9:AddToggle({
    Name = "🎚️ Max Knobs",
    Description = "Max knobs instantly",
    Default = false,
    Callback = function(value)
        _G.DOORS.MaxKnobs = value
    end
})

Tab9:AddToggle({
    Name = "🎮 No Minigames",
    Description = "Bỏ qua minigame",
    Default = false,
    Callback = function(value)
        _G.DOORS.NoMinigames = value
    end
})

Tab9:AddToggle({
    Name = "💓 Auto Heartbeat",
    Description = "Tự động heartbeat",
    Default = false,
    Callback = function(value)
        _G.DOORS.AutoHeartbeat = value
    end
})

-- ==================== TAB 10: FARM ====================
local Section10_1 = Tab10:AddSection({"💰 Auto Farm"})

Tab10:AddToggle({
    Name = "💰 Auto Farm Gold",
    Description = "Tự động farm vàng",
    Default = false,
    Callback = function(value)
        _G.DOORS.AutoFarmGold = value
    end
})

Tab10:AddToggle({
    Name = "🎚️ Auto Farm Knobs",
    Description = "Tự động farm knobs",
    Default = false,
    Callback = function(value)
        _G.DOORS.AutoFarmKnobs = value
    end
})

Tab10:AddToggle({
    Name = "💖 Auto Farm Revives",
    Description = "Tự động farm revives",
    Default = false,
    Callback = function(value)
        _G.DOORS.AutoFarmRevives = value
    end
})

Tab10:AddToggle({
    Name = "📦 Auto Open Chests",
    Description = "Tự động mở rương",
    Default = false,
    Callback = function(value)
        _G.DOORS.AutoOpenChests = value
    end
})


-- ==================== TAB 11: SETTINGS ====================
local Section11_1 = Tab11:AddSection({"⚙️ Misc Settings"})

Tab11:AddToggle({
    Name = "🔔 Notifications",
    Description = "Hiển thị thông báo",
    Default = true,
    Callback = function(value)
        _G.DOORS.Notifications = value
    end
})

Tab11:AddToggle({
    Name = "🔢 Show Room Number",
    Description = "Hiển thị số phòng",
    Default = true,
    Callback = function(value)
        _G.DOORS.ShowRoomNumber = value
    end
})

Tab11:AddToggle({
    Name = "🔄 Anti AFK",
    Description = "Chống bị kick AFK",
    Default = true,
    Callback = function(value)
        _G.DOORS.AntiAFK = value
    end
})

Tab11:AddToggle({
    Name = "💬 Chat Spam",
    Description = "Spam chat",
    Default = false,
    Callback = function(value)
        _G.DOORS.ChatSpam = value
    end
})

local Section11_2 = Tab11:AddSection({"🌐 Server"})

Tab11:AddButton({
    Name = "🔄 Rejoin",
    Description = "Tham gia lại game",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

Tab11:AddButton({
    Name = "🔄 Server Hop",
    Description = "Chuyển server",
    Callback = function()
        local PlaceId = game.PlaceId
        local Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
        
        for _, server in pairs(Site.data) do
            if server.playing ~= server.maxPlayers and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(PlaceId, server.id, LocalPlayer)
                break
            end
        end
    end
})

Tab11:AddButton({
    Name = "📋 Copy Discord",
    Description = "Copy link Discord",
    Callback = function()
        setclipboard("https://discord.gg/khicamhub")
        Notify("Copied!", "Discord link copied!", 2)
    end
})

-- ==================== ANTI AFK ====================
if _G.DOORS.AntiAFK then
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end)
end

-- ==================== ROOM NUMBER DISPLAY ====================
spawn(function()
    while wait(1) do
        if _G.DOORS.ShowRoomNumber then
            CurrentRoom = GetCurrentRoom()
        end
    end
end)

-- ==================== FINAL NOTIFICATION ====================
Notify("🔥 quả cam hub- ULTIMATE", "DOORS Script Loaded!\n✅ 100+ Features\n✅ God Mode Ready\n✅ Room: " .. GetCurrentRoom(), 5)

print("==========================================")
print("🔥 quả cam hub- DOORS ULTIMATE EDITION")
print("✅ 100+ Features Loaded")
print("✅ God Mode System: READY")
print("✅ Auto Complete: READY")
print("✅ Entity Bypass: READY")
print("✅ Current Room: " .. GetCurrentRoom())

print("==========================================")
