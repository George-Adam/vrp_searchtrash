vRPtrashC = {}
Tunnel.bindInterface("vRP_trash",vRPtrashC)
Proxy.addInterface("vRP_trash",vRPtrashC)
vRP = Proxy.getInterface("vRP")
vRPStrash = Tunnel.getInterface("vRP_trash","vRP_trash")

local trashCans = {
    {'prop_bin_01a'},
    {'prop_bin_03a'},
    {'prop_bin_05a'},
    {'prop_dumpster_01a'},
    {'prop_dumpster_02a'},
    {'prop_dumpster_02b'},
    {'prop_dumpster_4a'},
    {'prop_dumpster_4b'}
}

configC = {
    searchDuration = 15000,
    searchText1 = "~o~Apasa ",
    searchText2 = " ~o~pentru a cauta in gunoi"
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local ply = GetPlayerPed(-1)
        local plyCoords = GetEntityCoords(ply, 0)
        for k, v in pairs(trashCans) do
            local trash = GetClosestObjectOfType(plyCoords["x"], plyCoords["y"], plyCoords["z"], 1.0, GetHashKey(v[1]), true, true, true)
            SetEntityAsMissionEntity(trash, true, true)
            if DoesEntityExist(trash) then
                trashCoords = GetEntityCoords(trash, 0)
            end
        end
    end 
end)

Citizen.CreateThread(function()
    while true do
        Wait(10)
        local ply = GetPlayerPed(-1)
        local plyCoords = GetEntityCoords(ply, 0)
        if trashCoords ~= nil then
            local distance = GetDistanceBetweenCoords(plyCoords["x"], plyCoords["y"], plyCoords["z"], trashCoords["x"], trashCoords["y"], trashCoords["z"])
            if distance > 2 then
                trashCoords = nil
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        local ply = GetPlayerPed(-1)
        local plyCoords = GetEntityCoords(ply, 0)
        if trashCoords ~= nil then
            if (GetDistanceBetweenCoords(plyCoords["x"], plyCoords["y"], plyCoords["z"], trashCoords["x"], trashCoords["y"], trashCoords["z"] < 1)) and (not IsPedInAnyVehicle(ply)) then
                DrawText3D(trashCoords["x"], trashCoords["y"], trashCoords["z"]+1.5, configC.searchText1 .. "~r~E" .. configC.searchText2, 150)
                if (GetDistanceBetweenCoords(plyCoords["x"], plyCoords["y"], plyCoords["z"], trashCoords["x"], trashCoords["y"], trashCoords["z"] < 0.5)) then
                    if IsControlPressed(1, 51) then
                        vRPStrash.searchTrash()
                        trashAnim()
                    end
                end
            end
        end
    end
end)

function DrawText3D(x,y,z, text, alpha)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    if onScreen then
        SetTextScale(0.5, 0.5)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, alpha)
        SetTextDropshadow(0, 0, 0, 0, alpha)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        SetDrawOrigin(x,y,z, 0)
        DrawText(0.0, 0.0)
        ClearDrawOrigin()
    end
end

function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function trashAnim()
    TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
    Citizen.Wait(configC.searchDuration)
    ClearPedTasks(PlayerPedId())
end
