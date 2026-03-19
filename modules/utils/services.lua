-- Cache de serviços para evitar chamadas repetidas
local services = {
    Players = game:GetService("Players"),
    UserInputService = game:GetService("UserInputService"),
    RunService = game:GetService("RunService"),
    TweenService = game:GetService("TweenService"),
    LocalPlayer = nil
}

-- Inicializa LocalPlayer
services.LocalPlayer = services.Players.LocalPlayer

return services