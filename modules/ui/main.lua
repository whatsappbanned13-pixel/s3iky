-- modules/ui/main.lua (VERSÃO ULTRA COMPLETA)
local ui = {}

local function criarUI(config, services)
    local screenGui
    local mainFrame
    local pages = {}
    local colorNeon = config.UI.Colors.Neon
    local colorLine = config.UI.Colors.Line

    -- Função para criar seções COM INTERRUPTOR
    local function criarSecao(parent, titulo, posX)
        local section = Instance.new("Frame")
        section.Size = UDim2.new(0, 200, 0, 380)  -- Aumentei altura pra caber mais coisas
        section.Position = UDim2.new(0, posX, 0.5, -190)
        section.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
        section.Parent = parent
        
        -- Cantos arredondados
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = section
        
        -- Borda
        local stroke = Instance.new("UIStroke")
        stroke.Color = colorLine
        stroke.Parent = section
        
        -- Frame do título (para organizar título + interruptor)
        local titleFrame = Instance.new("Frame")
        titleFrame.Size = UDim2.new(1, -20, 0, 35)
        titleFrame.Position = UDim2.new(0, 10, 0, 0)
        titleFrame.BackgroundTransparency = 1
        titleFrame.Parent = section
        
        -- Título da seção (esquerda)
        local title = Instance.new("TextLabel")
        title.Text = titulo
        title.Size = UDim2.new(0, 100, 1, 0)
        title.TextColor3 = colorNeon
        title.Font = Enum.Font.GothamBold
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.BackgroundTransparency = 1
        title.Parent = titleFrame
        
        -- INTERRUPTOR (toggle) - direita do título
        local toggleBg = Instance.new("TextButton")
        toggleBg.Name = "Toggle_" .. titulo
        toggleBg.Size = UDim2.new(0, 36, 0, 18)
        toggleBg.Position = UDim2.new(1, -38, 0.5, -9)
        toggleBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        toggleBg.Text = ""
        toggleBg.Parent = titleFrame
        
        -- Cantos arredondados no interruptor
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(1, 0)
        toggleCorner.Parent = toggleBg
        
        -- Bolinha do interruptor
        local toggleKnob = Instance.new("Frame")
        toggleKnob.Size = UDim2.new(0, 14, 0, 14)
        toggleKnob.Position = UDim2.new(0, 2, 0.5, -7)
        toggleKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        toggleKnob.Parent = toggleBg
        
        local knobCorner = Instance.new("UICorner")
        knobCorner.CornerRadius = UDim.new(1, 0)
        knobCorner.Parent = toggleKnob
        
        -- Estado do interruptor
        local toggleState = false
        toggleBg.MouseButton1Click:Connect(function()
            toggleState = not toggleState
            -- Animar bolinha
            toggleKnob.Position = toggleState and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            toggleBg.BackgroundColor3 = toggleState and colorNeon or Color3.fromRGB(60, 60, 60)
        end)
        
        -- Linha separadora do título (DENTRO da seção)
        local separator = Instance.new("Frame")
        separator.Size = UDim2.new(1, -20, 0, 1)
        separator.Position = UDim2.new(0, 10, 0, 35)
        separator.BackgroundColor3 = colorLine
        separator.BorderSizePixel = 0
        separator.Parent = section
        
        -- Container para os elementos
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -20, 1, -45)
        container.Position = UDim2.new(0, 10, 0, 40)
        container.BackgroundTransparency = 1
        container.Parent = section
        
        return container
    end
    
    -- Função para criar checkbox com ícone de ✓ (não emoji)
    local function criarCheckbox(parent, texto, yPos, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 25)
        frame.Position = UDim2.new(0, 0, 0, yPos)
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
        checkbox.Text = ""  -- Começa vazio
        checkbox.TextColor3 = colorNeon
        checkbox.Font = Enum.Font.GothamBold
        checkbox.TextSize = 14
        checkbox.Parent = frame
        
        local checkCorner = Instance.new("UICorner")
        checkCorner.CornerRadius = UDim.new(0, 4)
        checkCorner.Parent = checkbox
        
        -- Funcionalidade do checkbox com ✓
        local checkState = false
        checkbox.MouseButton1Click:Connect(function()
            checkState = not checkState
            checkbox.Text = checkState and "✓" or ""
            checkbox.BackgroundColor3 = checkState and colorNeon or Color3.fromRGB(50, 50, 50)
            if callback then callback(checkState) end
        end)
        
        return checkbox
    end
    
    -- Função para criar seletor de tecla (Hotkey)
    local function criarHotkeySelector(parent, texto, yPos, teclaPadrao)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 25)
        frame.Position = UDim2.new(0, 0, 0, yPos)
        frame.BackgroundTransparency = 1
        frame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Text = texto
        label.Size = UDim2.new(0, 70, 1, 0)
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        label.Parent = frame
        
        local hotkeyBtn = Instance.new("TextButton")
        hotkeyBtn.Size = UDim2.new(0, 70, 0, 22)
        hotkeyBtn.Position = UDim2.new(1, -72, 0.5, -11)
        hotkeyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        hotkeyBtn.Text = teclaPadrao
        hotkeyBtn.TextColor3 = colorNeon
        hotkeyBtn.Font = Enum.Font.GothamBold
        hotkeyBtn.TextSize = 11
        hotkeyBtn.Parent = frame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = hotkeyBtn
        
        -- Modo de seleção de tecla
        local selecionando = false
        hotkeyBtn.MouseButton1Click:Connect(function()
            selecionando = true
            hotkeyBtn.Text = "..."
            hotkeyBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        end)
        
        -- Detectar tecla pressionada
        services.UserInputService.InputBegan:Connect(function(input, processed)
            if selecionando and not processed and input.KeyCode ~= Enum.KeyCode.Unknown then
                selecionando = false
                local tecla = input.KeyCode.Name
                hotkeyBtn.Text = tecla
                hotkeyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            end
        end)
        
        return hotkeyBtn
    end
    
    -- Função para criar slider com valor mostrado
    local function criarSlider(parent, texto, yPos, min, max, padrao, sufixo)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 40)
        frame.Position = UDim2.new(0, 0, 0, yPos)
        frame.BackgroundTransparency = 1
        frame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Text = texto .. ": " .. padrao .. (sufixo or "")
        label.Size = UDim2.new(1, 0, 0, 15)
        label.TextColor3 = Color3.fromRGB(160, 160, 160)
        label.Font = Enum.Font.Gotham
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        label.Parent = frame
        
        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1, 0, 0, 4)
        sliderBg.Position = UDim2.new(0, 0, 0, 20)
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
        
        -- Funcionalidade do slider
        local dragging = false
        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        services.UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                local valor = math.floor(min + (max - min) * pos)
                fill.Size = UDim2.new(pos, 0, 1, 0)
                label.Text = texto .. ": " .. valor .. (sufixo or "")
            end
        end)
        
        services.UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        return fill
    end
    
    -- Função para criar seletor
    local function criarSelector(parent, texto, yPos, opcoes, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 25)
        frame.Position = UDim2.new(0, 0, 0, yPos)
        frame.BackgroundTransparency = 1
        frame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Text = texto
        label.Size = UDim2.new(0, 70, 1, 0)
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        label.Parent = frame
        
        local selector = Instance.new("TextButton")
        selector.Size = UDim2.new(0, 70, 0, 22)
        selector.Position = UDim2.new(1, -72, 0.5, -11)
        selector.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        selector.Text = opcoes[1]
        selector.TextColor3 = colorNeon
        selector.Font = Enum.Font.GothamBold
        selector.TextSize = 11
        selector.Parent = frame
        
        local selectorCorner = Instance.new("UICorner")
        selectorCorner.CornerRadius = UDim.new(0, 4)
        selectorCorner.Parent = selector
        
        -- Funcionalidade do seletor (ciclo)
        local index = 1
        selector.MouseButton1Click:Connect(function()
            index = index % #opcoes + 1
            selector.Text = opcoes[index]
            if callback then callback(opcoes[index]) end
        end)
        
        return selector
    end
    
    -- Função para criar botão de selecionar jogador
    local function criarPlayerSelector(parent, texto, yPos)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 30)
        frame.Position = UDim2.new(0, 0, 0, yPos)
        frame.BackgroundTransparency = 1
        frame.Parent = parent
        
        local label = Instance.new("TextLabel")
        label.Text = texto
        label.Size = UDim2.new(0, 70, 1, 0)
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.Font = Enum.Font.Gotham
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        label.Parent = frame
        
        local selectBtn = Instance.new("TextButton")
        selectBtn.Size = UDim2.new(0, 100, 0, 24)
        selectBtn.Position = UDim2.new(1, -102, 0.5, -12)
        selectBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        selectBtn.Text = "Todos"
        selectBtn.TextColor3 = colorNeon
        selectBtn.Font = Enum.Font.GothamBold
        selectBtn.TextSize = 11
        selectBtn.Parent = frame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = selectBtn
        
        -- Criar dropdown de jogadores (simplificado)
        selectBtn.MouseButton1Click:Connect(function()
            -- Aqui você implementaria a lista de jogadores
            -- Por enquanto só alterna entre modos
            local modos = {"Todos", "Inimigos", "Aliados", "Específico"}
            local atual = selectBtn.Text
            for i, modo in ipairs(modos) do
                if modo == atual then
                    local proximo = modos[i % #modos + 1]
                    selectBtn.Text = proximo
                    break
                end
            end
        end)
        
        return selectBtn
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
        -- LINHA HORIZONTAL (separa título do conteúdo)
        local lineH = Instance.new("Frame")
        lineH.Name = "GlobalLineH"
        lineH.Size = UDim2.new(1, 0, 0, 1)
        lineH.Position = UDim2.new(0, 0, 0, 45)
        lineH.BackgroundColor3 = colorLine
        lineH.BorderSizePixel = 0
        lineH.Parent = mainFrame
        
        -- LINHA VERTICAL (separa menu lateral)
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
        
        -- LINHA DIVISÓRIA DO TÍTULO DO MENU
        local titleSeparator = Instance.new("Frame")
        titleSeparator.Size = UDim2.new(1, -20, 0, 1)
        titleSeparator.Position = UDim2.new(0, 10, 0, 45)
        titleSeparator.BackgroundColor3 = colorLine
        titleSeparator.BorderSizePixel = 0
        titleSeparator.Parent = sideMenu
        
        local btnContainer = Instance.new("Frame")
        btnContainer.Size = UDim2.new(1, 0, 1, -60)
        btnContainer.Position = UDim2.new(0, 0, 0, 55)
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
            
            -- Barra indicadora (lateral esquerda)
            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(0, 3, 1, 0)
            bar.BackgroundColor3 = colorNeon
            bar.Visible = false
            bar.Parent = btn
            
            -- Gradiente (efeito de brilho)
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
                -- Mostrar página selecionada
                if pages[cat] then
                    pages[cat].Visible = true
                end
                
                -- Resetar todos os botões
                for _, b in pairs(btnContainer:GetChildren()) do
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
        
        -- SEÇÃO 1: AIMBOT (esquerda) - COM TODOS OS NOVOS ELEMENTOS
        local aimContainer = criarSecao(combatPage, "AIMBOT", 10)
        local yPos = 0
        
        -- Hotkey selector
        criarHotkeySelector(aimContainer, "Hotkey", yPos, "X"); yPos = yPos + 30
        
        -- Player selector
        criarPlayerSelector(aimContainer, "Target", yPos); yPos = yPos + 35
        
        -- Checkboxes básicos
        criarCheckbox(aimContainer, "Team Check", yPos); yPos = yPos + 25
        criarCheckbox(aimContainer, "Wall Check", yPos); yPos = yPos + 25
        criarCheckbox(aimContainer, "Visible Check", yPos); yPos = yPos + 25
        
        -- FOV Circle checkbox
        criarCheckbox(aimContainer, "FOV Circle", yPos); yPos = yPos + 30
        
        -- Sliders
        criarSlider(aimContainer, "FOV Radius", yPos, 0, 500, 100, "px"); yPos = yPos + 45
        criarSlider(aimContainer, "Smooth", yPos, 1, 20, 5, ""); yPos = yPos + 45
        criarSlider(aimContainer, "Curve", yPos, 0, 100, 0, "%"); yPos = yPos + 45
        criarSlider(aimContainer, "Aim Distance", yPos, 0, 5000, 1000, "m"); yPos = yPos + 45
        
        -- Seletores
        criarSelector(aimContainer, "Hitbox", yPos, {"Head", "Torso", "Random"}); yPos = yPos + 30
        criarSelector(aimContainer, "Mode", yPos, {"Closest", "Lowest HP", "Crosshair"})
        
        -- SEÇÃO 2: TRIGGERBOT (centro) - AJUSTADO PARA 220
        local triggerContainer = criarSecao(combatPage, "TRIGGERBOT", 220)
        yPos = 0
        
        criarHotkeySelector(triggerContainer, "Hotkey", yPos, "C"); yPos = yPos + 30
        criarCheckbox(triggerContainer, "Enabled", yPos); yPos = yPos + 25
        criarCheckbox(triggerContainer, "On Sight", yPos); yPos = yPos + 25
        criarCheckbox(triggerContainer, "On Crosshair", yPos); yPos = yPos + 25
        yPos = yPos + 5
        
        criarSlider(triggerContainer, "Delay", yPos, 0, 500, 50, "ms"); yPos = yPos + 45
        
        criarSelector(triggerContainer, "Mode", yPos, {"Instant", "Delay", "Hold"}); yPos = yPos + 30
        criarSelector(triggerContainer, "Hitbox", yPos, {"Head", "Torso", "Random"})
        
        -- SEÇÃO 3: EXTRA (direita) - AJUSTADO PARA 430 (DENTRO DA GUI)
        local extraContainer = criarSecao(combatPage, "EXTRA", 430)
        yPos = 0
        
        criarCheckbox(extraContainer, "Auto Prediction", yPos); yPos = yPos + 25
        criarCheckbox(extraContainer, "Dynamic FOV", yPos); yPos = yPos + 25
        criarCheckbox(extraContainer, "Auto Shoot", yPos); yPos = yPos + 25
        criarCheckbox(extraContainer, "Auto Wallbang", yPos); yPos = yPos + 25
        yPos = yPos + 5
        
        criarSlider(extraContainer, "Prediction", yPos, 0, 100, 50, "%"); yPos = yPos + 45
        criarSlider(extraContainer, "Max Distance", yPos, 100, 5000, 1000, "m"); yPos = yPos + 45
        
        criarSelector(extraContainer, "Priority", yPos, {"Health", "Distance", "Threat"})
        
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
            label.Text = name .. "\n(Em breve)"
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
        -- BOTÃO FECHAR (vermelho, redondo)
        local close = Instance.new("TextButton")
        close.Size = UDim2.new(0, 14, 0, 14)
        close.Position = UDim2.new(1, -24, 0, 15)
        close.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        close.Text = ""
        close.Parent = mainFrame
        
        local closeCorner = Instance.new("UICorner")
        closeCorner.CornerRadius = UDim.new(1, 0)
        closeCorner.Parent = close
        
        -- BOTÃO MINIMIZAR (amarelo, redondo)
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
        
        print("✅ UI ULTRA COMPLETA DO MALIGNANT!")
        print("📌 Aimbot (10) | Triggerbot (220) | Extra (430) - TODAS DENTRO")
        print("📌 Ícones de ✓ nos checkboxes")
        print("📌 Divisórias no título e categorias")
        print("▶️ CTRL para abrir/fechar")
    end

    function ui:Toggle()
        if mainFrame then
            mainFrame.Visible = not mainFrame.Visible
        end
    end

    return ui
end

return criarUI
