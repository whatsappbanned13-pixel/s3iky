-- modules/ui/main.lua (VERSÃO COM 3 SEÇÕES NO COMBAT)
local ui = {}

local function criarUI(config, services)
    local screenGui
    local mainFrame
    local pages = {}
    local colorNeon = config.UI.Colors.Neon
    local colorLine = config.UI.Colors.Line

    -- Função auxiliar para criar seções
    local function criarSecao(parent, titulo, posX)
        local section = Instance.new("Frame")
        section.Size = UDim2.new(0, 190, 0, 300)
        section.Position = UDim2.new(0, posX, 0.5, -150)
        section.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
        section.Parent = parent
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = section
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = colorLine
        stroke.Parent = section
        
        local title = Instance.new("TextLabel")
        title.Text = titulo
        title.Size = UDim2.new(1, -20, 0, 30)
        title.Position = UDim2.new(0, 10, 0, 5)
        title.TextColor3 = colorNeon
        title.Font = Enum.Font.GothamBold
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.BackgroundTransparency = 1
        title.Parent = section
        
        local separator = Instance.new("Frame")
        separator.Size = UDim2.new(1, -20, 0, 1)
        separator.Position = UDim2.new(0, 10, 0, 35)
        separator.BackgroundColor3 = colorLine
        separator.BorderSizePixel = 0
        separator.Parent = section
        
        return section
    end
    
    -- Função para criar checkbox
    local function criarCheckbox(parent, texto, yPos)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 25)
        frame.Position = UDim2.new(0, 10, 0, yPos)
        frame.BackgroundTransparency = 1
        frame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Text = texto
        label.Size = UDim2.new(1, -25, 1, 0)
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        label.Parent = frame
        
        local checkbox = Instance.new("TextButton")
        checkbox.Size = UDim2.new(0, 18, 0, 18)
        checkbox.Position = UDim2.new(1, -20, 0.5, -9)
        checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        checkbox.Text = ""
        checkbox.Parent = frame
        
        local checkCorner = Instance.new("UICorner")
        checkCorner.CornerRadius = UDim.new(0, 4)
        checkCorner.Parent = checkbox
        
        -- Efeito de hover
        checkbox.MouseEnter:Connect(function()
            checkbox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end)
        checkbox.MouseLeave:Connect(function()
            checkbox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end)
        
        return checkbox
    end
    
    -- Função para criar slider
    local function criarSlider(parent, texto, yPos, min, max, padrao)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 40)
        frame.Position = UDim2.new(0, 10, 0, yPos)
        frame.BackgroundTransparency = 1
        frame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Text = texto .. ": " .. padrao
        label.Size = UDim2.new(1, 0, 0, 15)
        label.TextColor3 = Color3.fromRGB(160, 160, 160)
        label.Font = Enum.Font.Gotham
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        label.Parent = frame
        
        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1, 0, 0, 4)
        sliderBg.Position = UDim2.new(0, 0, 0, 22)
        sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        sliderBg.Parent = frame
        
        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((padrao-min)/(max-min), 0, 1, 0)
        fill.BackgroundColor3 = colorNeon
        fill.BorderSizePixel = 0
        fill.Parent = sliderBg
        
        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 10, 0, 10)
        knob.Position = UDim2.new(1, -5, 0.5, -5)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.Parent = fill
        
        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = knob
        
        return fill
    end
    
    -- Função para criar seletor
    local function criarSelector(parent, texto, yPos, opcoes)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 25)
        frame.Position = UDim2.new(0, 10, 0, yPos)
        frame.BackgroundTransparency = 1
        frame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Text = texto
        label.Size = UDim2.new(0, 80, 1, 0)
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        label.Parent = frame
        
        local selector = Instance.new("TextButton")
        selector.Size = UDim2.new(0, 70, 0, 20)
        selector.Position = UDim2.new(1, -72, 0.5, -10)
        selector.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        selector.Text = opcoes[1]
        selector.TextColor3 = colorNeon
        selector.Font = Enum.Font.GothamBold
        selector.TextSize = 11
        selector.Parent = frame
        
        local selectorCorner = Instance.new("UICorner")
        selectorCorner.CornerRadius = UDim.new(0, 4)
        selectorCorner.Parent = selector
        
        return selector
    end

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
        
        -- ========== PÁGINA COMBAT COM 3 SEÇÕES ==========
        local combatPage = Instance.new("Frame")
        combatPage.Name = "COMBAT_Page"
        combatPage.Size = UDim2.new(1, 0, 1, -45)
        combatPage.Position = UDim2.new(0, 0, 0, 45)
        combatPage.BackgroundTransparency = 1
        combatPage.Visible = true
        combatPage.Parent = contentArea
        
        -- SEÇÃO 1: AIMBOT (esquerda)
        local aimSection = criarSecao(combatPage, "AIMBOT", 20)
        
        -- Elementos do Aimbot
        local yPos = 45
        criarCheckbox(aimSection, "Enabled", yPos); yPos = yPos + 25
        criarCheckbox(aimSection, "Team Check", yPos); yPos = yPos + 25
        criarCheckbox(aimSection, "Wall Check", yPos); yPos = yPos + 25
        criarCheckbox(aimSection, "Visible Check", yPos); yPos = yPos + 30
        
        local fovSlider = criarSlider(aimSection, "FOV Radius", yPos, 0, 500, 100); yPos = yPos + 45
        local smoothSlider = criarSlider(aimSection, "Smoothness", yPos, 1, 20, 5); yPos = yPos + 45
        
        criarSelector(aimSection, "Hitbox", yPos, {"Head", "Torso", "Random"})
        
        -- SEÇÃO 2: TRIGGERBOT (centro)
        local triggerSection = criarSecao(combatPage, "TRIGGERBOT", 220)
        yPos = 45
        
        criarCheckbox(triggerSection, "Enabled", yPos); yPos = yPos + 25
        criarCheckbox(triggerSection, "On Sight", yPos); yPos = yPos + 25
        criarCheckbox(triggerSection, "On Crosshair", yPos); yPos = yPos + 25
        yPos = yPos + 5
        
        local delaySlider = criarSlider(triggerSection, "Delay (ms)", yPos, 0, 500, 50); yPos = yPos + 45
        
        criarSelector(triggerSection, "Mode", yPos, {"Instant", "Delay", "Hold"})
        
        -- SEÇÃO 3: EXTRA (direita)
        local extraSection = criarSecao(combatPage, "EXTRA", 420)
        yPos = 45
        
        criarCheckbox(extraSection, "Auto Prediction", yPos); yPos = yPos + 25
        criarCheckbox(extraSection, "Dynamic FOV", yPos); yPos = yPos + 25
        criarCheckbox(extraSection, "Show FOV Circle", yPos); yPos = yPos + 25
        criarCheckbox(extraSection, "Auto Shoot", yPos); yPos = yPos + 25
        yPos = yPos + 5
        
        local distanceSlider = criarSlider(extraSection, "Max Distance", yPos, 100, 5000, 1000); yPos = yPos + 45
        
        criarSelector(extraSection, "Target Mode", yPos, {"Closest", "Lowest HP", "Crosshair"})
        
        -- OUTRAS PÁGINAS (vazias por enquanto)
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
            label.TextSize = 24
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
        print("📌 Página COMBAT com 3 seções: Aimbot, Triggerbot e Extra")
    end

    function ui:Toggle()
        if mainFrame then
            mainFrame.Visible = not mainFrame.Visible
        end
    end

    return ui
end

return criarUI
