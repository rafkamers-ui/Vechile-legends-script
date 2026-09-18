--[[
    Vehicle Legends | Pro Hub v2.1
    Auto Update + Auto Farm + Auto Race + Vehicle Mods
    UI: LinoriaLib
    GitHub: rafkamers-ui/Vechile-legends-script
    Last Updated: 2026
]]

-- ========== KONFIGURASI AUTO UPDATE ==========
local SCRIPT_VERSION = "2.1.0"
local SCRIPT_URL = "https://raw.githubusercontent.com/rafkamers-ui/Vechile-legends-script/main/vechilelegends.lua"

-- ========== LOAD LIBRARY ==========
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Progoonerfrfr/LinoriaLib/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Progoonerfrfr/LinoriaLib/main/addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Progoonerfrfr/LinoriaLib/main/addons/SaveManager.lua"))()

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- ========== CEK UPDATE ==========
task.spawn(function()
    pcall(function()
        local latestVersion = game:HttpGet("https://raw.githubusercontent.com/rafkamers-ui/Vechile-legends-script/main/vechilelegends.version")
        if latestVersion and latestVersion ~= SCRIPT_VERSION then
            Library:Notify("⚠️ Versi baru tersedia! Script akan di-update otomatis.", 5)
            task.wait(2)
            loadstring(game:HttpGet(SCRIPT_URL))()
            return
        end
    end)
end)

-- ========== WINDOW ==========
local Window = Library:CreateWindow({
    Title = "🚗 Vehicle Legends | Pro Hub v" .. SCRIPT_VERSION,
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

-- ========== TABS ==========
local Tabs = {
    Main = Window:AddTab("Main"),
    Race = Window:AddTab("Race"),
    Vehicle = Window:AddTab("Vehicle"),
    Visual = Window:AddTab("Visual"),
    Teleport = Window:AddTab("Teleport"),
    Stats = Window:AddTab("Stats"),
    Misc = Window:AddTab("Misc"),
    Settings = Window:AddTab("Settings")
}

-- ============================================================
-- TAB MAIN (AUTO FARM MONEY)
-- ============================================================
local MainGroup = Tabs.Main:AddLeftGroupbox("Auto Farm")

MainGroup:AddToggle("AutoFarmMoney", {
    Text = "Auto Farm Money (Mengemudi)",
    Default = false,
    Tooltip = "Menjalankan kendaraan otomatis untuk mengumpulkan uang"
})

MainGroup:AddSlider("FarmSpeed", {
    Text = "Farm Speed (detik)",
    Default = 3,
    Min = 1,
    Max = 15,
    Rounding = 0,
    Compact = false
})

MainGroup:AddToggle("AutoCollect", {
    Text = "Auto Collect Items",
    Default = false,
    Tooltip = "Mengumpulkan item di sekitar (jika ada event)"
})

-- ============================================================
-- TAB RACE
-- ============================================================
local RaceGroup = Tabs.Race:AddLeftGroupbox("Race Settings")

RaceGroup:AddDropdown("RaceSelect", {
    Values = {"Race 1", "Race 2", "Race 3", "Race 4", "Race 5", "Race 6", "Offroad 1", "Offroad 2", "Water Race", "Air Race"},
    Default = 1,
    Multi = false,
    Text = "Pilih Race",
    Tooltip = "Pilih race yang ingin diikuti"
})

RaceGroup:AddToggle("AutoRace", {
    Text = "Auto Join Race",
    Default = false,
    Tooltip = "Otomatis join race yang dipilih"
})

RaceGroup:AddToggle("AutoWin", {
    Text = "Auto Win Race",
    Default = false,
    Tooltip = "Otomatis menyelesaikan race"
})

RaceGroup:AddButton("Join Race Sekarang", function()
    Library:Notify("Mencoba join race...", 2)
end)

-- ============================================================
-- TAB VEHICLE
-- ============================================================
local VehicleGroup = Tabs.Vehicle:AddLeftGroupbox("Vehicle Mods")

VehicleGroup:AddToggle("SpeedHack", {
    Text = "Speed Hack",
    Default = false,
    Tooltip = "Menambah kecepatan kendaraan"
})

VehicleGroup:AddSlider("SpeedValue", {
    Text = "Speed Multiplier",
    Default = 2,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Compact = false
})

VehicleGroup:AddToggle("GodMode", {
    Text = "God Mode (Kendaraan)",
    Default = false,
    Tooltip = "Kendaraan tidak bisa hancur"
})

VehicleGroup:AddToggle("InfiniteBoost", {
    Text = "Infinite Boost",
    Default = false,
    Tooltip = "Boost tidak terbatas"
})

VehicleGroup:AddToggle("UnlockCars", {
    Text = "Unlock All Cars",
    Default = false,
    Tooltip = "Membuka semua kendaraan (client-side)"
})

-- ============================================================
-- TAB VISUAL
-- ============================================================
local VisualGroup = Tabs.Visual:AddLeftGroupbox("ESP & Visual")

VisualGroup:AddToggle("ESP", {
    Text = "Player ESP",
    Default = false,
    Tooltip = "Menampilkan nama pemain lain"
})

VisualGroup:AddToggle("FullBright", {
    Text = "Full Bright",
    Default = false,
    Tooltip = "Menerangi seluruh map"
})

-- ============================================================
-- TAB TELEPORT
-- ============================================================
local TpGroup = Tabs.Teleport:AddLeftGroupbox("Teleport")

TpGroup:AddButton("Teleport ke Spawn", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(0, 5, 0)
    end
end)

TpGroup:AddDropdown("PlayerList", {
    Values = {},
    Default = 1,
    Multi = false,
    Text = "Pilih Pemain",
    Tooltip = "Teleport ke pemain yang dipilih"
})

TpGroup:AddButton("Teleport ke Pemain", function()
    local selected = Toggles.PlayerList.Value
    if selected then
        local target = Players:FindFirstChild(selected)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
        end
    end
end)

task.spawn(function()
    while true do
        local playerNames = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                table.insert(playerNames, plr.Name)
            end
        end
        Toggles.PlayerList:SetValues(playerNames)
        task.wait(3)
    end
end)

-- ============================================================
-- TAB STATS
-- ============================================================
local StatsGroup = Tabs.Stats:AddLeftGroupbox("Statistik Pemain")

StatsGroup:AddLabel("Uang: Menghitung...")
StatsGroup:AddLabel("Level: -")
StatsGroup:AddLabel("Kendaraan Aktif: -")

task.spawn(function()
    while true do
        pcall(function()
            local money = LocalPlayer:GetAttribute("Money") or "N/A"
            local level = LocalPlayer:GetAttribute("Level") or "N/A"
        end)
        task.wait(5)
    end
end)

-- ============================================================
-- TAB MISC
-- ============================================================
local MiscGroup = Tabs.Misc:AddLeftGroupbox("Miscellaneous")

MiscGroup:AddToggle("AntiAFK", {
    Text = "Anti AFK",
    Default = true,
    Tooltip = "Mencegah kick karena AFK"
})

MiscGroup:AddButton("Rejoin Server", function()
    TeleportService:Teleport(game.PlaceId)
end)

-- ============================================================
-- TAB SETTINGS
-- ============================================================
local SettingsGroup = Tabs.Settings:AddLeftGroupbox("UI Settings")

SettingsGroup:AddButton("Unload Script", function()
    Library:Unload()
end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- ============================================================
-- LOGIC HANDLER
-- ============================================================

-- Auto Farm Money
Toggles.AutoFarmMoney:OnChanged(function()
    if Toggles.AutoFarmMoney.Value then
        task.spawn(function()
            while Toggles.AutoFarmMoney.Value do
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        local vehicle = char:FindFirstChildOfClass("VehicleSeat")
                        if vehicle then
                            vehicle.Throttle = 1
                            vehicle.Steer = math.sin(tick())
                        end
                    end
                end)
                task.wait(Toggles.FarmSpeed.Value)
            end
        end)
    end
end)

-- Auto Collect
Toggles.AutoCollect:OnChanged(function()
    if Toggles.AutoCollect.Value then
        task.spawn(function()
            while Toggles.AutoCollect.Value do
                pcall(function()
                    for _, item in ipairs(workspace:GetChildren()) do
                        if item:IsA("BasePart") and item.Name ~= "Baseplate" then
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                LocalPlayer.Character.HumanoidRootPart.CFrame = item.CFrame
                                task.wait(0.2)
                            end
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    end
end)

-- Speed Hack
Toggles.SpeedHack:OnChanged(function()
    pcall(function()
        local speed = Toggles.SpeedHack.Value and Sliders.SpeedValue.Value or 1
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16 * speed
            end
            local vehicle = char:FindFirstChildOfClass("VehicleSeat")
            if vehicle then
                vehicle.MaxSpeed = vehicle.MaxSpeed * speed
            end
        end
    end)
end)

-- God Mode
Toggles.GodMode:OnChanged(function()
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.MaxHealth = Toggles.GodMode.Value and math.huge or 100
                humanoid.Health = humanoid.MaxHealth
            end
        end
    end)
end)

-- Infinite Boost
Toggles.InfiniteBoost:OnChanged(function()
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            local vehicle = char:FindFirstChildOfClass("VehicleSeat")
            if vehicle then
                vehicle:SetAttribute("Boost", Toggles.InfiniteBoost.Value and 9999 or 0)
            end
        end
    end)
end)

-- Unlock All Cars
Toggles.UnlockCars:OnChanged(function()
    pcall(function()
        if Toggles.UnlockCars.Value then
            Library:Notify("Unlock All Cars diaktifkan (client-side).", 3)
        end
    end)
end)

-- ESP
Toggles.ESP:OnChanged(function()
    task.spawn(function()
        while Toggles.ESP.Value do
            pcall(function()
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        local head = plr.Character:FindFirstChild("Head")
                        if head and not head:FindFirstChild("ESPName") then
                            local billboard = Instance.new("BillboardGui")
                            billboard.Name = "ESPName"
                            billboard.Size = UDim2.new(0, 100, 0, 50)
                            billboard.Adornee = head
                            billboard.Parent = head
                            local text = Instance.new("TextLabel")
                            text.Size = UDim2.new(1, 0, 1, 0)
                            text.BackgroundTransparency = 1
                            text.Text = plr.Name
                            text.TextColor3 = Color3.new(1, 0, 0)
                            text.Parent = billboard
                        end
                    end
                end
            end)
            task.wait(1)
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then
                local head = plr.Character:FindFirstChild("Head")
                if head then
                    local esp = head:FindFirstChild("ESPName")
                    if esp then esp:Destroy() end
                end
            end
        end
    end)
end)

-- Full Bright
Toggles.FullBright:OnChanged(function()
    pcall(function()
        if Toggles.FullBright.Value then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 2
            Lighting.ClockTime = 12
        else
            Lighting.Ambient = Color3.fromRGB(0, 0, 0)
            Lighting.Brightness = 1
        end
    end)
end)

-- Anti AFK
Toggles.AntiAFK:OnChanged(function()
    if Toggles.AntiAFK.Value then
        LocalPlayer.Idled:Connect(function()
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end
end)

-- ========== NOTIFIKASI ==========
Library:Notify("🚗 Vehicle Legends Pro Hub v" .. SCRIPT_VERSION .. " Loaded!", 3)
