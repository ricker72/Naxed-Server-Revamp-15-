local keywordTable = {
    "hi", "hola",
    "travel", "viajar",
    "depot", "magician shop", "ship", "magic carpet", "varkhal", 
    "jhonny", "eremo", "shrines", "mad", "temple",
    "yes", "no"
}

-- =========================================================================================
-- CONFIGURACIÓN DE DESTINOS
-- Formato: ["nombre"] = {x = 0, y = 0, z = 0}
-- =========================================================================================
local destinations = {
    ["depot"] = {x = 356, y = 397, z = 7},
    ["magician shop"] = {x = 352, y = 457, z = 7},
    ["ship"] = {x = 308, y = 507, z = 6},
    ["magic carpet"] = {x = 364, y = 388, z = 4},
    ["varkhal"] = {x = 327, y = 420, z = 5},
    ["jhonny"] = {x = 327, y = 420, z = 6},
    ["eremo"] = {x = 361, y = 436, z = 5},
    ["shrines"] = {x = 352, y = 457, z = 4},
    ["mad"] = {x = 339, y = 436, z = 7},
    ["temple"] = {x = 361, y = 437, z = 6},
}

local travelCost = 0 -- Cambia esto si quieres cobrar por el viaje
-- =========================================================================================

-- Definición de Richard Guide
local npc = NPC.create({
    name = "Richard Guide", 
    defaultOutfit = 273, 
    defaultFlags = Flag.FLAG_MOVEABLE,
    plugin = 0
})

-- Outfit exacto solicitado
npc:setOutfit({
    type = 273, 
    head = 128, 
    body = 19, 
    legs = 80, 
    feet = 125, 
    addons = 3
})

local playerState = {}

-- Función para generar la lista de destinos automáticamente
local function getDestinationsList()
    local list = "I can take you to any of these places:\n"
    for name, _ in pairs(destinations) do
        list = list .. "- " .. name:gsub("^%l", string.upper) .. "\n"
    end
    list = list .. "Where do you want to go?"
    return list
end

-- Callback de diálogos
npc:setcallback(function(cid, desc)
    local player = Player(cid)
    if not player then return false end

    -- Saludo inicial
    if desc == "hi" or desc == "hola" then
        npc:say("Hello " .. player:getName() .. ". Wanna you meet this world?? Say {travel} and I can help you!", 0)
        playerState[cid] = nil

    -- Listar destinos
    elseif desc == "travel" or desc == "viajar" then
        npc:say(getDestinationsList(), 0)
        playerState[cid] = nil

    -- Selección de destino
    elseif destinations[desc] then
        local dest = destinations[desc]
        local costText = travelCost > 0 and " for " .. travelCost .. " gold coins" or " for free"
        
        npc:say("Do you wish to travel to " .. desc:gsub("^%l", string.upper) .. costText .. "?", 0)
        playerState[cid] = desc -- Guardamos el destino elegido

    -- Confirmación de viaje
    elseif desc == "yes" then
        local target = playerState[cid]
        if target and destinations[target] then
            local pos = destinations[target]
            
            if travelCost > 0 then
                if player:removeMoney(travelCost) then
                    player:teleportTo({x = pos.x, y = pos.y, z = pos.z})
                    npc:say("Enjoy your trip!", 0)
                else
                    npc:say("Sorry, you do not have enough money.", 0)
                end
            else
                -- Viaje gratis
                player:teleportTo({x = pos.x, y = pos.y, z = pos.z})
                npc:say("Enjoy your trip!", 0)
            end
            playerState[cid] = nil
        else
            npc:say("Please tell me where you want to go first.", 0)
        end

    elseif desc == "no" then
        npc:say("No problem! Let me know if you change your mind.", 0)
        playerState[cid] = nil
    end

    return true
end)

npc:setkeywordTable(keywordTable)
npc:register()
