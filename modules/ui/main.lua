-- Loader MALIGNANT
local repo = "https://raw.githubusercontent.com/whatsappbanned13-pixel/s3iky/main/"

local function carregar(caminho)
    local url = repo .. caminho
    local conteudo = game:HttpGet(url)
    if conteudo and conteudo ~= "404: Not Found" then
        return loadstring(conteudo)()
    end
    return nil
end

print("🚀 Iniciando Malignant GUI...")

local config = carregar("config.lua") or {
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

local services = carregar("modules/utils/services.lua") or {
    Players = game:GetService("Players"),
    UserInputService = game:GetService("UserInputService"),
    RunService = game:GetService("RunService"),
    TweenService = game:GetService("TweenService"),
    LocalPlayer = game:GetService("Players").LocalPlayer
}

local criarUI = carregar("modules/ui/main.lua")
if criarUI then
    local ui = criarUI(config, services)
    ui:Initialize()
    
    print("✅ GUI do Malignant inicializada!")
    print("▶️ Pressione CTRL para abrir/fechar")
    
    services.UserInputService.InputBegan:Connect(function(input, proc)
        if not proc and input.KeyCode == Enum.KeyCode.LeftControl then
            ui:Toggle()
        end
    end)
else
    warn("❌ Falha ao carregar UI")
end
