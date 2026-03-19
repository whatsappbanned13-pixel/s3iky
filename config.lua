-- Configurações globais
local config = {
    Aimbot = {
        Radius = 100,
        ShowFOV = false,
        Smoothness = 5,
        MaxDistance = 1000,
        Hitbox = "Head",
        TargetMode = "Closest",
        TeamCheck = true,
        AutoLocking = false
    },
    
    UI = {
        Colors = {
            Neon = Color3.fromRGB(0, 255, 120),
            Background = Color3.fromRGB(35, 35, 35),
            Sidebar = Color3.fromRGB(28, 28, 28),
            Line = Color3.fromRGB(55, 55, 55)
        },
        Sizes = {
            MainWidth = 780,
            MainHeight = 400,
            SidebarWidth = 160
        }
    }
}

-- Estado global das seções
config.SectionStates = {}

return config