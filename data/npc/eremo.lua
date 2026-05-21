local keywordTable = {
    "hi", "hola",
    "blessing", "blessings", "bless",
    "blessed", "supreme", "divine",
    "yes", "no"
}

-- Definición de Eremo
local npc = NPC.create({
    name = "Eremo", 
    defaultOutfit = 134, -- Outfit de mago/ermitaño (Puedes cambiarlo)
    defaultFlags = Flag.FLAG_MOVEABLE,
    plugin = 0
})

-- Outfit sugerido para Eremo (Místico/Ermitaño)
npc:setOutfit({
    type = 134, 
    head = 114, 
    body = 12, 
    legs = 90, 
    feet = 115, 
    addons = 0
})

-- =========================================================================================
-- CONFIGURACIÓN DE BENDICIONES (Sigue la fórmula de Tibia RL)
-- Precio Final = Precio Base + (Nivel del Jugador * 100)
-- =========================================================================================
local blessingConfigs = {
    [1] = {name = "Blessed", basePrice = 20000},
    [2] = {name = "Supreme", basePrice = 50000},
    [3] = {name = "Divine", basePrice = 100000},
}
-- =========================================================================================

local playerState = {}

-- Función para calcular el costo dinámico según el nivel
local function calculateCost(player, type)
    local level = player:getLevel()
    return blessingConfigs[type].basePrice + (level * 100)
end

-- Callback de diálogos
npc:setcallback(function(cid, desc)
    local player = Player(cid)
    if not player then return false end

    -- Saludo
    if desc == "hi" or desc == "hola" then
        npc:say("Greetings, traveler. I can grant you the protection of the gods. Do you seek a blessing?", 0)
        playerState[cid] = nil

    -- Menú de Bendiciones
    elseif desc == "blessing" or desc == "blessings" or desc == "bless" then
        npc:say("I can offer you three levels of protection:", 0)
        npc:say("- Blessed Blessing", 0)
        npc:say("- Supreme Blessing", 0)
        npc:say("- Divine Blessing", 0)
        npc:say("Which one do you desire?", 0)
        playerState[cid] = nil

    -- Selección: Blessed
    elseif desc == "blessed" then
        local cost = calculateCost(player, 1)
        npc:say("A Blessed Blessing will cost you " .. cost .. " gold coins. Do you accept?", 0)
        playerState[cid] = 1

    -- Selección: Supreme
    elseif desc == "supreme" then
        local cost = calculateCost(player, 2)
        npc:say("A Supreme Blessing will cost you " .. cost .. " gold coins. Do you accept?", 0)
        playerState[cid] = 2

    -- Selección: Divine
    elseif desc == "divine" then
        local cost = calculateCost(player, 3)
        npc:say("A Divine Blessing will cost you " .. cost .. " gold coins. Do you accept?", 0)
        playerState[cid] = 3

    -- Confirmación de compra
    elseif desc == "yes" then
        local type = playerState[cid]
        if type and blessingConfigs[type] then
            -- Verificación de Cuenta Premium (Requisito de Tibia RL)
            if not player:getPremium() then
                npc:say("Only premium members can receive my blessings.", 0)
                playerState[cid] = nil
                return true
            end

            local cost = calculateCost(player, type)
            if player:removeMoney(cost) then
                player:addBlessing(type)
                npc:say("It is done. You are now blessed!", 0)
            else
                npc:say("You do not have enough gold coins for this blessing.", 0)
            end
            playerState[cid] = nil
        else
            npc:say("Please, tell me first which blessing you wish to receive.", 0)
        end

    elseif desc == "no" then
        npc:say("As you wish. May the gods guide you.", 0)
        playerState[cid] = nil
    end

    return true
end)

npc:setkeywordTable(keywordTable)
npc:register()
