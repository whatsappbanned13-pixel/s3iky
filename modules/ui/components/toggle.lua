local toggle = {}
local tweenService = game:GetService("TweenService")
local config = require(script.Parent.Parent.Parent.config)

function toggle.new(parent, sectionName, callback)
    local bg = Instance.new("TextButton")
    bg.Size = UDim2.new(0, 26, 0, 14)
    bg.Position = UDim2.new(1, -35, 0.5, -7)
    bg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    bg.Text = ""
    bg.Parent = parent
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 10, 0, 10)
    knob.Position = UDim2.new(0, 2, 0.5, -5)
    knob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    knob.Parent = bg
    
    -- Adicionar bordas arredondadas
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    
    bg.MouseButton1Click:Connect(function()
        config.SectionStates[sectionName] = not config.SectionStates[sectionName]
        local state = config.SectionStates[sectionName]
        
        tweenService:Create(knob, TweenInfo.new(0.1), {
            Position = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
        }):Play()
        
        bg.BackgroundColor3 = state and config.UI.Colors.Neon or Color3.fromRGB(60, 60, 60)
        
        if callback then
            callback(state)
        end
    end)
end

return toggle