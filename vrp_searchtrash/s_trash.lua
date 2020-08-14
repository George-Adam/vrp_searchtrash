local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
MySQL = module("vrp_mysql", "MySQL")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_trash")
vRPCtrash = Tunnel.getInterface("vRP_trash","vRP_trash")

vRPtrash = {}
Tunnel.bindInterface("vRP_trash",vRPtrash)
Proxy.addInterface("vRP_trash",vRPtrash)

configS = {
    searchNotify = "~o~Cauti in gunoi, doamne ce ai ajuns...",
    foundLessMoney = "~g~Ai gasit ",
    foundMoney = "~g~Ai ce manca azi, ai gasit ",
    foundRats = "~r~Te-a muscat un sobolan de mana!",
    tryAgain = "~y~N-ai gasit nimic, incerca din nou!",
    moneyMin = 100,
    moneyMax = 1500,
    searchDuration = 15000 -- Needs to be the same as in c_trash.lua if you want it timed correctly
}

function vRPtrash.searchTrash()
    local user_id = vRP.getUserId({source})
    local target = vRP.getUserSource({user_id})
    local chance = math.random (1, 1000)
    local money = math.random(configS.moneyMin, configS.moneyMax/10)
    local lotsOfMoney = math.random(configS.moneyMin, configS.moneyMax)
    vRPclient.notify(target, {configS.searchNotify})
    Wait(configS.searchDuration)
    if chance == 996 or chance == 997 or chance == 998 then
        vRP.giveMoney({user_id, money})
        vRPclient.notify(target, {configS.foundLessMoney, money .. "$."})
    elseif chance == 999 then
        vRP.giveMoney({user_id, lotsOfMoney})
        vRPclient.notify(target, {configS.foundMoney, money .. "$."})
    elseif chance > 760 and chance <= 799 then
        vRP.giveInventoryItem({user_id, 'water', 1, true})
    elseif chance >= 860 and chance <= 899 then
        vRP.giveInventoryItem({user_id, 'vodka', 1, true})
    elseif chance >= 960 and chance <= 995 then
        vRP.giveInventoryItem({user_id, 'sandwich', 1, true})
    elseif chance >= 400 and chance <= 699 then
        vRPclient.notify(target, {configS.foundRats})
        vRPclient.varyHealth(target,{-20}) 
    else
        vRPclient.notify(target, {configS.tryAgain})
        --TriggerClientEvent('vRPmisc:trashNotify', source, '~r~Nu ai gasit nimic, mai cauta...')
    end
    --TriggerClientEvent('chatMessage', -1, "Sansa: " .. chance)
end
