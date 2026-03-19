-- MALIGNANT COMPACT PRO - LOADER
local Malignant = {}

-- Carrega configurações
local config = require(script.config)

-- Carrega módulos
local ui = require(script.modules.ui.main)
local services = require(script.modules.utils.services)
local aimbot = require(script.modules.features.aimbot)

-- Inicializa a UI
ui:Initialize()

-- Inicializa features
aimbot:Initialize()

-- Atalho CTRL para abrir/fechar
services.UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.LeftControl then
        ui:Toggle()
    end
end)

return Malignant