-- modules/ui/main.lua (UI VERDADEIRA - NÃO É O LOADER)
local ui = {}

local function criarUI(config, services)
    local screenGui
    local mainFrame
    local pages = {}
    local colorNeon = config.UI.Colors.Neon
    local colorLine = config.UI.Colors.Line

    function ui:Cleanup()
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
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame
        return frame
    end

    function ui:CreateDividers()
        -- Linha horizontal (separa título)
        local lineH = Instance.new("Frame")
        lineH.Size = UDim2.new(1, 0, 0, 1)
        lineH.Position = UDim2.new(0, 0, 0, 45)
        lineH.BackgroundColor3 = colorLine
        lineH.Parent = mainFrame
        
        -- Linha vertical (separa menu)
        local lineV = Instance.new("Frame")
        lineV.Size = UDim2.new(0, 1, 1, 0)
        lineV.Position = UDim2.new(0, config.UI.Sizes.SidebarWidth, 0, 0)
        lineV.BackgroundColor3 = colorLine
        lineV.Parent = mainFrame
    end

    function ui:CreateSideMenu()
        local sideMenu = Instance.new("Frame")
        sideMenu.Size = UDim2.new(0, config.UI.Sizes.SidebarWidth, 1, 0)
        sideMenu.BackgroundColor3 = config.UI.Colors.Sidebar
        sideMenu.Parent = mainFrame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = sideMenu
        
        local title = Instance.new("TextLabel")
        title.Text = "MALIGNANT"
        title.Size = UDim2.new(1, 0, 0, 45)
        title.BackgroundTransparency = 1
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.Font = Enum.Font.FredokaOne
        title.TextSize = 20
        title.Parent = sideMenu
        
        local btnContainer = Instance.new("Frame")
        btnContainer.Size = UDim2.new(1, 0, 1, -50)
        btnContainer.Position = UDim2.new(0, 0, 0, 50)
        btnContainer.BackgroundTransparency = 1
        btnContainer.Parent = sideMenu
        
        local layout = Instance.new("UIListLayout")
        layout.Parent = btnContainer
        
        local categories = {"COMBAT", "VISUALS", "MOVEMENT", "MISC"}
        for _, cat in ipairs(categories) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 40)
            btn.BackgroundColor3 = config.UI.Colors.Sidebar
            btn.Text = "      " .. cat
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 12
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Parent = btnContainer
            
            btn.MouseButton1Click:Connect(function()
                for _, page in pairs(pages) do
                    page.Visible = false
                end
                if pages[cat] then
                    pages[cat].Visible = true
                end
            end)
        end
    end

    function ui:CreatePages()
        local contentArea = Instance.new("Frame")
        contentArea.Size = UDim2.new(1, -config.UI.Sizes.SidebarWidth, 1, 0)
        contentArea.Position = UDim2.new(0, config.UI.Sizes.SidebarWidth, 0, 0)
        contentArea.BackgroundTransparency = 1
        contentArea.Parent = mainFrame
        
        -- Página COMBAT
        local combatPage = Instance.new("Frame")
        combatPage.Name = "COMBAT_Page"
        combatPage.Size = UDim2.new(1, 0, 1, -45)
        combatPage.Position = UDim2.new(0, 0, 0, 45)
        combatPage.BackgroundTransparency = 1
        combatPage.Visible = true
        combatPage.Parent = contentArea
        
        local label = Instance.new("TextLabel")
        label.Text = "PÁGINA COMBAT"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.TextColor3 = colorNeon
        label.Font = Enum.Font.GothamBold
        label.TextSize = 24
        label.BackgroundTransparency = 1
        label.Parent = combatPage
        
        pages["COMBAT"] = combatPage
        
        -- Outras páginas
        local otherPages = {"VISUALS", "MOVEMENT", "MISC"}
        for _, name in ipairs(otherPages) do
            local page = Instance.new("Frame")
            page.Name = name .. "_Page"
            page.Size = UDim2.new(1, 0, 1, -45)
            page.Position = UDim2.new(0, 0, 0, 45)
            page.BackgroundTransparency = 1
            page.Visible = false
            page.Parent = contentArea
            pages[name] = page
        end
    end

    function ui:CreateWindowControls()
        local close = Instance.new("TextButton")
        close.Size = UDim2.new(0, 14, 0, 14)
        close.Position = UDim2.new(1, -24, 0, 15)
        close.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        close.Text = ""
        close.Parent = mainFrame
        
        close.MouseButton1Click:Connect(function()
            screenGui:Destroy()
        end)
    end

    function ui:Initialize()
        self:Cleanup()
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "Malignant"
        screenGui.Parent = services.Players.LocalPlayer:WaitForChild("PlayerGui")
        
        mainFrame = self:CreateMainFrame()
        self:CreateDividers()
        self:CreateSideMenu()
        self:CreatePages()
        self:CreateWindowControls()
        print("✅ UI Inicializada!")
    end

    function ui:Toggle()
        if mainFrame then
            mainFrame.Visible = not mainFrame.Visible
        end
    end

    return ui
end

return criarUI
