-- modules/ui/main.lua (VERSÃO PARA LOADSTRING - NÃO USA REQUIRE)
local ui = {}

-- Recebe as dependências por parâmetro em vez de require
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
        local lineH = Instance.new("Frame")
        lineH.Name = "GlobalLineH"
        lineH.Size = UDim2.new(1, 0, 0, 1)
        lineH.Position = UDim2.new(0, 0, 0, 45)
        lineH.BackgroundColor3 = colorLine
        lineH.BorderSizePixel = 0
        lineH.Parent = mainFrame
        
        local lineV = Instance.new("Frame")
        lineV.Name = "GlobalLineV"
        lineV.Size = UDim2.new(0, 1, 1, 0)
        lineV.Position = UDim2.new(0, config.UI.Sizes.SidebarWidth, 0, 0)
        lineV.BackgroundColor3 = colorLine
        lineV.BorderSizePixel = 0
        lineV.Parent = mainFrame
    end

    function ui:CreateSideMenu()
        local sideMenu = Instance.new("Frame")
        sideMenu.Size = UDim2.new(0, config.UI.Sizes.SidebarWidth, 1, 0)
        sideMenu.BackgroundColor3 = config.UI.Colors.Sidebar
        sideMenu.BorderSizePixel = 0
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
            btn.BorderSizePixel = 0
            btn.Text = "      " .. cat
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 12
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Parent = btnContainer
            
            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(0, 3, 1, 0)
            bar.BackgroundColor3 = colorNeon
            bar.Visible = false
            bar.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                for _, page in pairs(pages) do
                    page.Visible = false
                end
                if pages[cat] then
                    pages[cat].Visible = true
                end
                for _, b in pairs(btnContainer:GetChildren()) do
                    if b:IsA("TextButton") then
                        b.TextColor3 = Color3.fromRGB(180, 180, 180)
                        if b.Frame then b.Frame.Visible = false end
                    end
                end
                bar.Visible = true
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            end)
        end
    end

    function ui:CreatePages()
        local contentArea = Instance.new("Frame")
        contentArea.Size = UDim2.new(1, -config.UI.Sizes.SidebarWidth, 1, 0)
        contentArea.Position = UDim2.new(0, config.UI.Sizes.SidebarWidth, 0, 0)
        contentArea.BackgroundTransparency = 1
        contentArea.Parent = mainFrame
        
        -- PÁGINA COMBAT COM CONTEÚDO
        local combatPage = Instance.new("Frame")
        combatPage.Name = "COMBAT_Page"
        combatPage.Size = UDim2.new(1, 0, 1, -45)
        combatPage.Position = UDim2.new(0, 0, 0, 45)
        combatPage.BackgroundTransparency = 1
        combatPage.Visible = true
        combatPage.Parent = contentArea
        
        -- SEÇÃO AIMBOT
        local section = Instance.new("Frame")
        section.Size = UDim2.new(0, 190, 0, 200)
        section.Position = UDim2.new(0.5, -95, 0.5, -100)
        section.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
        section.Parent = combatPage
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = section
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = colorLine
        stroke.Parent = section
        
        local title = Instance.new("TextLabel")
        title.Text = "AIMBOT"
        title.Size = UDim2.new(1, -20, 0, 30)
        title.Position = UDim2.new(0, 10, 0, 5)
        title.TextColor3 = colorNeon
        title.Font = Enum.Font.GothamBold
        title.TextSize = 12
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.BackgroundTransparency = 1
        title.Parent = section
        
        local separator = Instance.new("Frame")
        separator.Size = UDim2.new(1, -20, 0, 1)
        separator.Position = UDim2.new(0, 10, 0, 35)
        separator.BackgroundColor3 = colorLine
        separator.BorderSizePixel = 0
        separator.Parent = section
        
        -- CHECKBOX EXEMPLO
        local checkboxFrame = Instance.new("Frame")
        checkboxFrame.Size = UDim2.new(1, -20, 0, 25)
        checkboxFrame.Position = UDim2.new(0, 10, 0, 45)
        checkboxFrame.BackgroundTransparency = 1
        checkboxFrame.Parent = section
        
        local checkboxLabel = Instance.new("TextLabel")
        checkboxLabel.Text = "Enabled"
        checkboxLabel.Size = UDim2.new(1, -25, 1, 0)
        checkboxLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        checkboxLabel.Font = Enum.Font.Gotham
        checkboxLabel.TextSize = 11
        checkboxLabel.TextXAlignment = Enum.TextXAlignment.Left
        checkboxLabel.BackgroundTransparency = 1
        checkboxLabel.Parent = checkboxFrame
        
        local checkbox = Instance.new("TextButton")
        checkbox.Size = UDim2.new(0, 16, 0, 16)
        checkbox.Position = UDim2.new(1, -18, 0.5, -8)
        checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        checkbox.Text = ""
        checkbox.Parent = checkboxFrame
        
        local checkCorner = Instance.new("UICorner")
        checkCorner.CornerRadius = UDim.new(0, 3)
        checkCorner.Parent = checkbox
        
        -- OUTRAS PÁGINAS
        local otherPages = {"VISUALS", "MOVEMENT", "MISC"}
        for _, name in ipairs(otherPages) do
            local page = Instance.new("Frame")
            page.Name = name .. "_Page"
            page.Size = UDim2.new(1, 0, 1, -45)
            page.Position = UDim2.new(0, 0, 0, 45)
            page.BackgroundTransparency = 1
            page.Visible = false
            page.Parent = contentArea
            
            local label = Instance.new("TextLabel")
            label.Text = name .. " (Em breve)"
            label.Size = UDim2.new(1, 0, 1, 0)
            label.TextColor3 = Color3.fromRGB(150, 150, 150)
            label.Font = Enum.Font.Gotham
            label.TextSize = 18
            label.BackgroundTransparency = 1
            label.Parent = page
            
            pages[name] = page
        end
        
        pages["COMBAT"] = combatPage
    end

    function ui:CreateWindowControls()
        local close = Instance.new("TextButton")
        close.Size = UDim2.new(0, 14, 0, 14)
        close.Position = UDim2.new(1, -24, 0, 15)
        close.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        close.Text = ""
        close.Parent = mainFrame
        
        local closeCorner = Instance.new("UICorner")
        closeCorner.CornerRadius = UDim.new(1, 0)
        closeCorner.Parent = close
        
        local mini = Instance.new("TextButton")
        mini.Size = UDim2.new(0, 14, 0, 14)
        mini.Position = UDim2.new(1, -44, 0, 15)
        mini.BackgroundColor3 = Color3.fromRGB(255, 220, 90)
        mini.Text = ""
        mini.Parent = mainFrame
        
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
            for _, page in pairs(pages) do
                page.Visible = false
            end
            pages[pageName].Visible = true
        end
    end

    function ui:Initialize()
        self:Cleanup()
        
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "Malignant"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = services.Players.LocalPlayer:WaitForChild("PlayerGui")
        
        mainFrame = self:CreateMainFrame()
        self:CreateDividers()
        self:CreateSideMenu()
        self:CreatePages()
        self:CreateWindowControls()
        self:ShowPage("COMBAT")
        
        print("✅ UI do Malignant inicializada!")
    end

    function ui:Toggle()
        if mainFrame then
            mainFrame.Visible = not mainFrame.Visible
        end
    end

    return ui
end

-- A função principal que será chamada pelo loader
return function(config, services)
    return criarUI(config, services)
end
