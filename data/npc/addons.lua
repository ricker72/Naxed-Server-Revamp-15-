local keywordTable = {
    "addon",
    "addons",
    "first addon",
    "second addon",
    "yes",
    "no"
}

-- Definición del NPC (Datos extraídos del XML original)
local npc = NPC.create({
    name = "Addons", 
    defaultOutfit = 134, -- Look type 134
    defaultFlags = Flag.FLAG_MOVEABLE,
    plugin = 0
})

-- Configuración detallada del Outfit (Head, Body, Legs, Feet, Addons)
npc:setOutfit({
    type = 134, 
    head = 78, 
    body = 88, 
    legs = 0, 
    feet = 88, 
    addons = 3
})

-- Tabla para rastrear en qué parte de la conversación está el jugador
local playerState = {}

-- Función lógica para procesar la compra
local function buyAddons(player, addon, cost, premiumRequired)
    if premiumRequired and not player:getPremium() then
        npc:say("I only serve customers with premium accounts.", 0)
        return false
    end

    if player:removeMoney(cost) then
        player:addAddon(addon)
        npc:say('There, you are now able to use all addons!', 0)
    else
        npc:say('Sorry, you do not have enough money.', 0)
    end
    return true
end

-- Callback principal de diálogos
npc:setcallback(function(cid, desc)
    local player = Player(cid)
    if not player then return false end

    -- Diálogo General
    if desc == "addon" or desc == "addons" then
        npc:say("I sell the first addons set for 5000 gold coins and the second addons set for 10000 gold coins.", 0)
        playerState[cid] = nil -- Reset state

    -- Flujo Primera Adición
    elseif desc == "first addon" then
        npc:say("Do you want to buy the first addons set for 5000 gold coins?", 0)
        playerState[cid] = "ask_first"

    -- Flujo Segunda Adición
    elseif desc == "second addon" then
        npc:say("Would you like to buy the second addons set for 10000 gold coins?", 0)
        playerState[cid] = "ask_second"

    -- Respuestas Yes/No
    elseif desc == "yes" then
        local state = playerState[cid]
        if state == "ask_first" then
            buyAddons(player, 1, 5000, true)
            playerState[cid] = nil
        elseif state == "ask_second" then
            buyAddons(player, 2, 10000, true)
            playerState[cid] = nil
        else
            npc:say("I'm sorry, I didn't understand what you want to buy.", 0)
        end

    elseif desc == "no" then
        npc:say("Too expensive, eh?", 0)
        playerState[cid] = nil
    end

    return true
end)

npc:setkeywordTable(keywordTable)
npc:register()
