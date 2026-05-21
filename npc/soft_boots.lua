local keywordTable = {
    "hi", "hello",
    "soft boots", "buy", "purchase",
    "repair", "fix",
    "yes", "no"
}

-- Definición del NPC (Nombre: "soft boots")
local npc = NPC.create({
    name = "soft boots", 
    defaultOutfit = 128, -- Outfit de mercader estándar (ajustable)
    defaultFlags = Flag.FLAG_MOVEABLE,
    plugin = 0,
    walkinterval = 2000 -- Camina cada 2 segundos (como en tus otros NPCs)
})

-- Outfit (Puedes ajustarlo si conoces el outfit exacto de Aldo en tu servidor)
npc:setOutfit({
    type = 128, 
    head = 20, 
    body = 100, 
    legs = 50, 
    feet = 99, 
    addons = 0
})

-- Estado temporal para seguimiento de acciones (compra/reparación)
local playerState = {}

-- Callback principal de diálogos
npc:setcallback(function(cid, desc)
    local player = Player(cid)
    if not player then return false end

    local pid = player:getId()

    -- ==============================
    -- SALUDO INICIAL
    -- ==============================
    if desc == "hi" or desc == "hello" then
        npc:say("Hello! I sell and repair soft boots. What can I do for you?", 0)
        playerState[pid] = nil
        return true

    -- ==============================
    -- COMPRA DE SOFT BOOTS
    -- ==============================
    elseif desc == "soft boots" or desc == "buy" or desc == "purchase" then
        npc:say("A pair of soft boots costs 10000 gold coins. Do you want to buy it?", 0)
        playerState[pid] = {action = "buy"}
        return true

    -- ==============================
    -- REPARACIÓN DE SOFT BOOTS
    -- ==============================
    elseif desc == "repair" or desc == "fix" then
        -- Verificar si el jugador tiene soft boots
        local item = player:getItemById(6132, true) -- Busca en inventario y contenedores
        if not item then
            npc:say("You don't have any soft boots to repair.", 0)
            playerState[pid] = nil
            return true
        end

        local charge = item:getCharge()
        if charge >= 100 then
            npc:say("Your soft boots are already fully charged!", 0)
            playerState[pid] = nil
            return true
        end

        local missingCharges = 100 - charge
        local cost = missingCharges * 100
        npc:say("Repairing your soft boots will cost " .. cost .. " gold coins. Do you want to proceed?", 0)
        playerState[pid] = {action = "repair"} -- Guardamos la intención (recalcularemos costo al confirmar)
        return true

    -- ==============================
    -- CONFIRMACIÓN DE ACCIÓN (YES/NO)
    -- ==============================
    elseif desc == "yes" then
        local state = playerState[pid]
        if not state then
            npc:say("What would you like to do?", 0)
            return true
        end

        if state.action == "buy" then
            -- Proceso de compra
            if player:removeMoney(10000) then
                player:addItem(6132, 1) -- Da soft boots nuevo (ID 6132)
                npc:say("Here are your soft boots!", 0)
            else
                npc:say("Sorry, you do not have enough money.", 0)
            end

        elseif state.action == "repair" then
            -- Proceso de reparación (re-verificamos el item y su cargo actual)
            local item = player:getItemById(6132, true)
            if not item or item:getId() ~= 6132 then
                npc:say("It seems you no longer have the soft boots you wanted to repair.", 0)
                playerState[pid] = nil
                return true
            end

            local currentCharge = item:getCharge()
            if currentCharge >= 100 then
                npc:say("Your soft boots are already fully charged!", 0)
                playerState[pid] = nil
                return true
            end

            local missingCharges = 100 - currentCharge
            local cost = missingCharges * 100
            if player:removeMoney(cost) then
                item:setCharge(100) -- Restaura a carga máxima
                npc:say("Your soft boots have been fully repaired!", 0)
            else
                npc:say("Sorry, you do not have enough money.", 0)
            end
        end

        playerState[pid] = nil -- Limpiamos el estado
        return true

    elseif desc == "no" then
        npc:say("No problem! Come back when you need my services.", 0)
        playerState[pid] = nil
        return true
    end

    return true
end)

npc:setkeywordTable(keywordTable)
npc:register()
