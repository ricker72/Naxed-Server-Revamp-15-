local keywordTable = {
    "travel",
    "vampire volcano",
    "dragon lair",
    "magic cathedral",
    "hell human",
    "giants lair",
    "yes",
    "no"
}

-- Definición de Anderson
local npc = NPC.create({
    name = "Anderson", 
    defaultOutfit = 134, 
    defaultFlags = Flag.FLAG_MOVEABLE,
    plugin = 0
})

-- Outfit exacto solicitado
npc:setOutfit({
    type = 134, 
    head = 114, 
    body = 12, 
    legs = 90, 
    feet = 115, 
    addons = 1
})

-- Tabla de destinos: {nombre, x, y, z, costo}
local destinations = {
    ["vampire volcano"] = {pos = {x = 543, y = 209, z = 7}, cost = 100},
    ["dragon lair"] = {pos = {x = 682, y = 225, z = 7}, cost = 100},
    ["magic cathedral"] = {pos = {x = 866, y = 227, z = 7}, cost = 100},
    ["hell human"] = {pos = {x = 931, y = 113, z = 6}, cost = 100},
    ["giants lair"] = {pos = {x = 629, y = 437, z = 8}, cost = 100},
}

local playerState = {}

-- Callback de diálogos
npc:setcallback(function(cid, desc)
    local player = Player(cid)
    if not player then return false end

    -- Menú General de Viajes
    if desc == "travel" then
        npc:say("I can take you to 'Vampire Volcano', 'Dragon Lair', 'Magic Cathedral', 'Hell Human', or 'Giants Lairs' for just a small fee.", 0)
        playerState[cid] = nil

    -- Lógica de selección de destino
    elseif destinations[desc] then
        local dest = destinations[desc]
        npc:say("Do you wish to travel to " .. desc:gsub("^%l", string.upper) .. " for " .. dest.cost .. " gold coins?", 0)
        playerState[cid] = desc -- Guardamos el destino elegido

    -- Confirmación de viaje
    elseif desc == "yes" then
        local target = playerState[cid]
        if target and destinations[target] then
            local dest = destinations[target]
            
            -- Verificación de Premium (como estaba en el script original)
            if not player:getPremium() then
                npc:say("Sorry, this service is only for premium members.", 0)
                playerState[cid] = nil
                return true
            end

            -- Cobro y Teletransporte
            if player:removeMoney(dest.cost) then
                player:teleportTo({x = dest.pos.x, y = dest.pos.y, z = dest.pos.z})
                npc:say("Safe travels!", 0)
            else
                npc:say("Sorry, you do not have enough money.", 0)
            end
            playerState[cid] = nil
        else
            npc:say("Please tell me where you want to go first.", 0)
        end

    elseif desc == "no" then
        npc:say("Too expensive, eh?", 0)
        playerState[cid] = nil
    end

    return true
end)

npc:setkeywordTable(keywordTable)
npc:register()
