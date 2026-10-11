local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Baloksxin/ROBLOX-BKU-SCRIPT/refs/heads/main/UI.txt"))()

local Window = OrionLib:MakeWindow({
    Name = "服务器选择",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "ServerSelect",
    IntroEnabled = true,
    IntroText = "服务器选择",
    IntroIcon = "rbxassetid://8834748103",
    Icon = "rbxassetid://8834748103",
})

local MainTab = Window:MakeTab({
    Name = "服务器选择",
    Icon = "server",
})

local function ExecuteScript(url)
    pcall(function()
        local result = game:HttpGet(url)
        local func = loadstring(result)
        if func then
            func()
        end
    end)
end

MainTab:AddSection({ Name = "更新日志" })
MainTab:AddLabel("暂时封闭")
MainTab:AddLabel("最后更新时间:????/??/??")

MainTab:AddSection({ Name = "Nothing....." })
OrionLib:Init()