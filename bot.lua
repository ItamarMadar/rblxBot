local websock = syn.websocket.connect("ws://localhost:46928")
local AkaliNotif = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))();
function notify(title,description,duration)
    AkaliNotif.Notify({
        Description = description,
        Title = title,
        Duration = duration
    })
end
local function findPlayer(stringg)
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
         if stringg:lower() == (v.Name:lower()):sub(1, #stringg) then
               return v
         end
    end
end

local clooptp = false
local looptp = false
local looptptarget = nil
game:GetService("RunService").RenderStepped:Connect(function()
    if clooptp and looptptarget then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=looptptarget.Character.HumanoidRootPart.CFrame*CFrame.new(math.random(-3,3),math.random(0,3),math.random(-3,3))
    end
end)

websock.OnMessage:Connect(function(msg)
    local data = msg:split("|")
    if data[1] == "rblxBot" then
        if data[2] == "Command" then

                --process commands here [bot]
                local success = false
                if data[3] == "to" then
                
                    _G.exec("to "..data[4])
                    success = true
                
                elseif data[3] == "noname" then
                
                    _G.exec("noname")
                    success = true
                
                elseif data[3] == "chat" then

                    game:GetService('Players'):Chat(data[4])
                    game:GetService('ReplicatedStorage').DefaultChatSystemChatEvents['SayMessageRequest']:FireServer(data[4], 'All')
                    success = true

                elseif data[3] == "fly" then

                    _G.exec("togglevfly")
                    success = true

                elseif data[3] == "follow" then

                    _G.exec("walkto "..data[4])
                    success = true

                elseif data[3] == "aifollow" then

                    _G.exec("pathfindwalkto "..data[4])
                    success = true

                elseif data[3] == "unfollow" then

                    _G.exec("unwalkto")
                    success = true

                elseif data[3] == "clooptp" then

                    looptptarget = findPlayer(data[4])
                    clooptp = true
                    success = true

                elseif data[3] == "unlooptp" then
                    
                    looptptarget = nil
                    looptp = false
                    clooptp = false
                    success = true

                elseif data[3] == "emote" then

                    _G.exec("e_"..data[4])
                    success = true

                elseif data[3] == "stopemote" then

                    _G.exec("noemotes")
                    success = true

                elseif data[3] == "iy" then

                    _G.exec(data[4])
                    success = true

                elseif data[3] == "eval" then

                    local successful,errmsg = pcall(function() loadstring(data[4)() end))
                    if successful then success = true else success = false end

                end
                if success == true then
                    notify("Successfully processed command.","cmd: "..data[3], 2.5)
                else
                    websock:Send("rblxBot|Unsuccessful")
                end

        end
    end
 end)

websock:Send(string.format("rblxBot|botConnect|%s", game:GetService("Players").LocalPlayer.Name))
notify("Connection Established.", "Successfully connected to host.", 2.5)
