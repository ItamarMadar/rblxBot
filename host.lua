local websock = syn.websocket.connect("ws://localhost:46928")
local AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))();
function notify(title,description,duration)
    AkaliNotif.Notify({
        Description = description,
        Title = title,
        Duration = duration
    })
end

function removeFromTable(table, value)
    for i,v in pairs(table) do
        if v == value then
            table.remove(table, i)
        end
    end
end

local bots = {

}

websock.OnMessage:Connect(function(msg)
    local data = msg:split("|")
    if data[1] == "rblxBot" then
        if data[2] == "botConnect" then
            notify("New Bot Connection",string.format("%s has connected.", data[3]), 2.5)
            table.insert(bots,data[3])
        elseif data[2] == "Unsuccessful" then
            notify("Failed to run command.", "Bot returned unsuccessful.", 2.5)
        end
    end
 end)

game:GetService("Players").PlayerRemoving:Connect(function(player)
    if table.find(bots, player.Name) then
        notify("Bot Disconnected",string.format("%s has disconnected.", player.Name), 2.5)
        removeFromTable(bots, player.Name)
    end
end)

local CBar, CRemote, Connected = game:GetService("Players").LocalPlayer['PlayerGui']:WaitForChild('Chat')['Frame'].ChatBarParentFrame['Frame'].BoxFrame['Frame'].ChatBar, game:GetService('ReplicatedStorage').DefaultChatSystemChatEvents['SayMessageRequest'], {}

local prefix = "/"

local HookChat = function(Bar)
    coroutine.wrap(function()
        if not table.find(Connected,Bar) then
            local Connect = Bar['FocusLost']:Connect(function(Enter)
                if Enter ~= false and Bar['Text'] ~= '' then
                    local Message = Bar['Text']
                    Bar['Text'] = '';
                    if Message:sub(1,1) == prefix then
                        local cmdmsg = Message:split(" ")
                        local cmd = cmdmsg[1]:sub(2, string.len(cmdmsg[1]))

                            --process commands here [host]

                            if cmd == "to" then

                                if cmdmsg[2] ~= nil then
                                    websock:Send("rblxBot|Command|to|"..cmdmsg[2])
                                    notify("rblxBot", string.format("Teleporting all bots to %s", cmdmsg[2]), 2.5)
                                end

                            elseif cmd == "noname" then
                            
                                websock:Send("rblxBot|Command|noname")
                                notify("rblxBot", "Removing all bots nametag", 2.5)

                            elseif cmd == "chat" then

                                local toChat = string.gsub(Message, "/chat ", "")
                                websock:Send("rblxBot|Command|chat|"..toChat)

                            elseif cmd == "fly" then

                                websock:Send("rblxBot|Command|fly")
                                notify("rblxBot", "Toggling fly on all bots", 2.5)

                            elseif cmd == "follow" then

                                websock:Send("rblxBot|Command|follow|"..cmdmsg[2])
                                notify("rblxBot", "Making all bots follow "..cmdmsg[2], 2.5)

                            elseif cmd == "aifollow" then

                                websock:Send("rblxBot|Command|aifollow|"..cmdmsg[2])
                                notify("rblxBot", "Making all bots AI follow "..cmdmsg[2], 2.5)

                            elseif cmd == "unfollow" then

                                websock:Send("rblxBot|Command|unfollow")
                                notify("rblxBot", "Making all bots stop following", 2.5)

                            elseif cmd == "clooptp" then

                                websock:Send("rblxBot|Command|clooptp|"..cmdmsg[2])
                                notify("rblxBot", "CLoopTPing all bots to "..cmdmsg[2], 2.5)

                            elseif cmd == "unlooptp" then

                                websock:Send("rblxBot|Command|unlooptp")
                                notify("rblxBot", "UnloopTPing all bots", 2.5)

                            elseif cmd == "emote" then

                                websock:Send("rblxBot|Command|emote|"..cmdmsg[2])
                                notify("rblxBot", "Making all bots do emote '"..cmdmsg[2].."'", 2.5)
            
                            elseif cmd == "stopemote" then
            
                                websock:Send("rblxBot|Command|stopemotes")
                                notify("rblxBot", "Making all bots stop emoting", 2.5)

                            elseif cmd == "iy" then

                                local toExec = string.gsub(Message, "/iy ", "")
                                websock:Send("rblxBot|Command|iy|"..toExec)
                                    
                            end

                    else
                        game:GetService('Players'):Chat(Message); CRemote:FireServer(Message,'All')
                    end
                end
            end)
            Connected[#Connected+1] = Bar; Bar['AncestryChanged']:Wait(); Connect:Disconnect()
        end
    end)()
end

_G.evalAllBots = function(code)
    websock:Send("rblxBot|Command|eval|"..code")
end

HookChat(CBar); local BindHook = Instance.new('BindableEvent')

local MT = getrawmetatable(game); local NC = MT.__namecall; setreadonly(MT, false)

MT.__namecall = newcclosure(function(...)
    local Method, Args = getnamecallmethod(), {...}
    if rawequal(tostring(Args[1]),'ChatBarFocusChanged') and rawequal(Args[2],true) then 
        if game:GetService("Players").LocalPlayer['PlayerGui']:FindFirstChild('Chat') then
            BindHook:Fire()
        end
    end
    return NC(...)
end)

BindHook['Event']:Connect(function()
    CBar = game:GetService("Players").LocalPlayer['PlayerGui'].Chat['Frame'].ChatBarParentFrame['Frame'].BoxFrame['Frame'].ChatBar
    HookChat(CBar)
end)

 notify("RblxBot is ready!", "", 2.5)
