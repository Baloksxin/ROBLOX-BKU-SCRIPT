local FluentSource = game:HttpGet("https://raw.githubusercontent.com/Baloksxin/ROBLOX-BKU-SCRIPT/refs/heads/main/UI.txt")
local FluentChunk, FluentErr = loadstring(FluentSource)
if not FluentChunk then
	error("Ui加载错误:" .. tostring(FluentErr), 0)
end
local Fluent = FluentChunk()
if not Fluent then
	error("Ui加载错误:没有返回", 0)
end
pcall(function()
	if type(getgenv) == "function" then
		local e = getgenv()
		if type(e) == "table" then
			e.Fluent = Fluent
		end
	end
end)

local Window = Fluent:CreateWindow({
	Title = "服务器选择",
	SubTitle = "BKU",
	TabWidth = 140,
	Size = UDim2.fromOffset(520, 420),
	Acrylic = true,
	Theme = "Pearl White",
	MinimizeKey = Enum.KeyCode.LeftControl,
})

local MainTab = Window:AddTab({ Title = "服务器选择", Icon = "lucide/server" })

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

MainTab:AddSection("更新日志")
MainTab:AddParagraph({ Title = "关闭修复", Content = "" })
MainTab:AddParagraph({ Title = "最后更新时间:????/??/??", Content = "" })

MainTab:AddSection("可选服务器")
MainTab:AddButton({
	Title = "通用",
	Callback = function()
		ExecuteScript("https://flowauth.net/v1/loaders/6f850a94a5646376fc5691ce77e76ec7.lua")
	end,
})
MainTab:AddButton({
	Title = "致命狒狒",
	Callback = function()
		ExecuteScript("https://flowauth.net/v1/loaders/d241b8942fce99fbd848fd6051a13d44.lua")
	end,
})
MainTab:AddButton({
	Title = "Ear Game",
	Callback = function()
		ExecuteScript("https://flowauth.net/v1/loaders/9ecaaf715ddfd8184e9069c4dcf0fd8f.lua")
	end,
})
MainTab:AddButton({
	Title = "致命猴子",
	Callback = function()
		ExecuteScript("https://flowauth.net/v1/loaders/8f4b24028431b8ba0d9bb2e199a36753.lua")
	end,
})
