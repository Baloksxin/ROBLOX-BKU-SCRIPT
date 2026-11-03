local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Baloksxin/ROBLOX-BKU-SCRIPT/refs/heads/main/UI.txt"))()
pcall(function()
	if type(getgenv) == "function" then
		local e = getgenv()
		if type(e) == "table" then
			e.OrionLib = OrionLib
		end
	end
end)

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

local _loaded = {}

local function ExecuteScript(url)
	if type(url) ~= "string" or #url == 0 then
		return
	end
	if _loaded[url] then
		warn("[BKU Loader] already loaded:", url)
		return
	end
	_loaded[url] = true
	local ok, err = pcall(function()
		local result = game:HttpGet(url)
		local func, cerr = loadstring(result)
		if type(func) ~= "function" then
			error(tostring(cerr or "loadstring failed"), 0)
		end
		func()
	end)
	if not ok then
		_loaded[url] = nil
		warn("[BKU Loader] load failed:", tostring(err))
	end
end

MainTab:AddSection({ Name = "更新日志" })
MainTab:AddLabel("更新了致命猴子，一些功能稍后推出")
MainTab:AddLabel("...")
MainTab:AddLabel("最后更新时间:2026/11/3")

MainTab:AddSection({ Name = "可选服务器" })
MainTab:AddButton({
	Name = "通用",
	Callback = function()
		ExecuteScript("https://flowauth.net/v1/loaders/6f850a94a5646376fc5691ce77e76ec7.lua")
	end,
	Icon = "rbxassetid://3944703587",
})

MainTab:AddButton({
	Name = "Ear Game",
	Callback = function()
		ExecuteScript("https://flowauth.net/v1/loaders/9ecaaf715ddfd8184e9069c4dcf0fd8f.lua")
	end,
	Icon = "rbxassetid://3944703587",
})

MainTab:AddButton({
	Name = "致命猴子",
	Callback = function()
		ExecuteScript("https://flowauth.net/v1/loaders/8f4b24028431b8ba0d9bb2e199a36753.lua")
	end,
	Icon = "rbxassetid://3944703587",
})

OrionLib:Init()
