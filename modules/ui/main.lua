local ui = {}
local services = require(script.Parent.Parent.utils.services)
local config = require(script.Parent.Parent.config)

local screenGui
local mainFrame
local pages = {}
local currentPage = nil

-- Cores e estilos
local colorNeon = config.UI.Colors.Neon
local colorLine = config.UI.Colors.Line

function ui:Cleanup()
    -- Remove instância anterior se existir
    local playerGui = services.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui and playerGui:FindFirstChild("Malignant") then
        playerGui.Malignant:Destroy()
    end
end

function ui:CreateMainFrame()
    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, config.UI.Sizes.MainWidth, 0, config.UI.Sizes.MainHeight)
    frame.Position = UDim2.new(0.5, -config.UI.Sizes.MainWidth/2, 0.5, -config.UI.Sizes.MainHeight/2)
    frame.BackgroundColor3 = config.UI.Colors.Background
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = screenGui
    
    -- Cantos arredondados
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    return frame
end

function ui:CreateDividers()
    -- Linha horizontal no topo
    local lineH = Instance.new("Frame")
    lineH.Name = "GlobalLineH"
    lineH.Size = UDim2.new(1, 0, 0, 1)
    lineH.Position = UDim2.new(0, 0, 0, 45)
    lineH.BackgroundColor3 = colorLine
    lineH.BorderSizePixel = 0
    lineH.Parent = mainFrame
    
    -- Linha vertical separadora do menu
    local lineV = Instance.new("Frame")
    lineV.Name = "GlobalLineV"
    lineV.Size = UDim2.new(0, 1, 1, 0)
    lineV.Position = UDim2.new(0, config.UI.Sizes.SidebarWidth, 0, 0)
    lineV.BackgroundColor3 = colorLine
    lineV.BorderSizePixel = 0
    lineV.Parent = mainFrame
end

function ui:CreateSideMenu()
    -- Menu lateral
    local sideMenu = Instance.new("Frame")
    sideMenu.Size = UDim2.new(0, config.UI.Sizes.SidebarWidth, 1, 0)
    sideMenu.BackgroundColor3 = config.UI.Colors.Sidebar
    sideMenu.BorderSizePixel = 0
    sideMenu.Parent = mainFrame
    
    -- Cantos arredondados no menu
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = sideMenu
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Text = "MALIGNANT"
    title.Size = UDim2.new(1, 0, 0, 45)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.FredokaOne
    title.TextSize = 20
    title.Parent = sideMenu
    
    -- Container dos botões de categoria
    local btnContainer = Instance.new("Frame")
    btnContainer.Size = UDim2.new(1, 0, 1, -50)
    btnContainer.Position = UDim2.new(0, 0, 0, 50)
    btnContainer.BackgroundTransparency = 1
    btnContainer.Parent = sideMenu
    
    -- Layout dos botões
    local layout = Instance.new("UIListLayout")
    layout.Parent = btnContainer
    
    -- Criar botões das categorias
    local categories = {"COMBAT", "VISUALS", "MOVEMENT", "MISC"}
    for _, cat in ipairs(categories) do
        self:CreateCategoryButton(btnContainer, cat)
    end
end

function ui:CreateCategoryButton(parent, name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = config.UI.Colors.Sidebar
    btn.BorderSizePixel = 0
    btn.Text = "      " .. name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = parent
    
    -- Barra indicadora
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 3, 1, 0)
    bar.BackgroundColor3 = colorNeon
    bar.Visible = false
    bar.Parent = btn
    
    -- Gradiente
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new(colorNeon, config.UI.Colors.Sidebar)
    grad.Transparency = NumberSequence.new(0.5, 1)
    grad.Enabled = false
    grad.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        -- Esconder todas as páginas
        for _, page in pairs(pages) do
            page.Visible = false
        end
        -- Mostrar a página selecionada
        if pages[name] then
            pages[name].Visible = true
        end
        
        -- Resetar todos os botões
        for _, b in pairs(parent:GetChildren()) do
            if b:IsA("TextButton") then
                b.TextColor3 = Color3.fromRGB(180, 180, 180)
                if b.Frame then b.Frame.Visible = false end
                if b.UIGradient then b.UIGradient.Enabled = false end
            end
        end
        
        -- Ativar botão atual
        grad.Enabled = true
        bar.Visible = true
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

function ui:CreatePages()
    -- Área de conteúdo
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -config.UI.Sizes.SidebarWidth, 1, 0)
    contentArea.Position = UDim2.new(0, config.UI.Sizes.SidebarWidth, 0, 0)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame
    
    -- Criar páginas
    local pageNames = {"COMBAT", "VISUALS", "MOVEMENT", "MISC"}
    for _, name in ipairs(pageNames) do
        local page = Instance.new("Frame")
        page.Name = name .. "_Page"
        page.Size = UDim2.new(1, 0, 1, -45)
        page.Position = UDim2.new(0, 0, 0, 45)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Parent = contentArea
        
        -- Layout da página
        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.Padding = UDim.new(0, 10)
        layout.Parent = page
        
        pages[name] = page
    end
end

function ui:CreateWindowControls()
    -- Botão fechar
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 14, 0, 14)
    close.Position = UDim2.new(1, -24, 0, 15)
    close.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    close.Text = ""
    close.Parent = mainFrame
    
    -- Cantos arredondados
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = close
    
    -- Botão minimizar
    local mini = Instance.new("TextButton")
    mini.Size = UDim2.new(0, 14, 0, 14)
    mini.Position = UDim2.new(1, -44, 0, 15)
    mini.BackgroundColor3 = Color3.fromRGB(255, 220, 90)
    mini.Text = ""
    mini.Parent = mainFrame
    
    -- Cantos arredondados
    local miniCorner = Instance.new("UICorner")
    miniCorner.CornerRadius = UDim.new(1, 0)
    miniCorner.Parent = mini
    
    close.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    mini.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
    end)
end

function ui:ShowPage(pageName)
    if pages[pageName] then
        -- Esconder todas
        for _, page in pairs(pages) do
            page.Visible = false
        end
        -- Mostrar a selecionada
        pages[pageName].Visible = true
    end
end

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
    
    print("✅ UI do Malignant inicializada!")
end

function ui:Toggle()
    if mainFrame then
        mainFrame.Visible = not mainFrame.Visible
    end
end

return ui
