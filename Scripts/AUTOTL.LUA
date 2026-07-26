local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local function sendNotification(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 3
        })
    end)
end

local httpRequest = (syn and syn.request) or (http and http.request) or http_request or request
if not httpRequest then
    sendNotification("汉化失败", "当前 Executor 不支持 HTTP 请求！", 5)
    return
end

local translationCache = {}
local pendingBatch = {}
local isBatchProcessing = false

local function containsChinese(text)
    return text:find("[\228-\233]") ~= nil
end

local function batchGoogleTranslate(textList)
    if #textList == 0 then return {} end
    
    local queryText = table.concat(textList, "\n|||\n")
    local url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=zh-CN&dt=t&q=" .. HttpService:UrlEncode(queryText)
    
    local success, response = pcall(function()
        return httpRequest({
            Url = url,
            Method = "GET"
        })
    end)

    if success and response and response.StatusCode == 200 and response.Body then
        local ok, decoded = pcall(function()
            return HttpService:JSONDecode(response.Body)
        end)
        if ok and decoded and decoded[1] and type(decoded[1]) == "table" then
            local fullTranslated = ""
            for _, seg in ipairs(decoded[1]) do
                if seg[1] then
                    fullTranslated = fullTranslated .. seg[1]
                end
            end
            
            local results = {}
            for _, translatedSeg in ipairs(string.split(fullTranslated, "\n|||\n")) do
                table.insert(results, vim and vim.trim(translatedSeg) or translatedSeg:gsub("^%s+", ""):gsub("%s+$", ""))
            end
            return results
        end
    end
    
    return textList
end

local function flushBatch()
    if isBatchProcessing or #pendingBatch == 0 then return end
    isBatchProcessing = true

    task.spawn(function()
        while #pendingBatch > 0 do
            local currentBatch = {}
            local batchLimit = 40
            
            while #pendingBatch > 0 and #currentBatch < batchLimit do
                table.insert(currentBatch, table.remove(pendingBatch, 1))
            end
            
            local textList = {}
            for _, item in ipairs(currentBatch) do
                table.insert(textList, item.text)
            end
            
            local translatedList = batchGoogleTranslate(textList)
            
            for i, item in ipairs(currentBatch) do
                local translated = translatedList[i]
                local instance = item.instance
                local originalText = item.text
                
                if instance and instance.Parent and translated and translated ~= "" and translated ~= originalText then
                    pcall(function()
                        instance.Text = translated
                        instance.FontFace = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                    end)
                    translationCache[originalText] = translated
                end
            end
            
            task.wait(0.01)
        end
        isBatchProcessing = false
    end)
end

local function enqueueTranslation(instance)
    local currentText = instance.Text
    if type(currentText) == "string" and #currentText > 0 and not containsChinese(currentText) and not tonumber(currentText) then
        if translationCache[currentText] then
            pcall(function()
                instance.Text = translationCache[currentText]
                instance.FontFace = Font.new("rbxasset://fonts/families/Nunito.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
            end)
        else
            table.insert(pendingBatch, {
                instance = instance,
                text = currentText
            })
            flushBatch()
        end
    end
end

local function processInstance(inst)
    if inst:IsA("TextLabel") or inst:IsA("TextButton") then
        enqueueTranslation(inst)
        
        inst:GetPropertyChangedSignal("Text"):Connect(function()
            if not containsChinese(inst.Text) then
                enqueueTranslation(inst)
            end
        end)
    end
end

local function scanContainer(container)
    if not container then return end
    pcall(function()
        for _, desc in ipairs(container:GetDescendants()) do
            processInstance(desc)
        end
        container.DescendantAdded:Connect(function(desc)
            processInstance(desc)
        end)
    end)
end

sendNotification("汉化", "开始中", 3)

if LocalPlayer then
    local playerGui = LocalPlayer:WaitForChild("PlayerGui", 5)
    if playerGui then
        scanContainer(playerGui)
    end
end

pcall(function()
    scanContainer(CoreGui)
end)

scanContainer(Workspace)

task.delay(1, function()
    sendNotification("汉化", "汉化完成!", 3)
end)