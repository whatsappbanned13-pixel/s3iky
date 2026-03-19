local ui = {}
local services = require(script.Parent.Parent.utils.services)
local config = require(script.Parent.Parent.config)
local components = script.Parent.components
local pages = script.Parent.pages

local screenGui
local mainFrame
local currentPage = nil

function ui:Initialize()
    -- Limpa instâncias antigas
    self:Cleanup()
    
    -- Cria GUI principal
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Malignant"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = services.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Cria frame principal
    mainFrame = self:CreateMainFrame()
    
    -- Cria elementos da UI
    self:CreateDividers()
    self:CreateSideMenu()
    self:CreatePages()
    self:CreateWindowControls()
    
    -- Mostra página inicial
    self:ShowPage("COMBAT")
end

function ui:Toggle()
    if mainFrame then
        mainFrame.Visible = not mainFrame.Visible
    end
end

-- [Implementar outros métodos: CreateMainFrame, CreateDividers, etc.]

return ui