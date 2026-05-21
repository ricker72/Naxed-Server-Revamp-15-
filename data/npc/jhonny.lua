local keywordTable = {
    "hi", "hola",
    "promot", "promote", "promotion", "promocion",
    "epic", "epicize",
    "yes", "no"
}

-- Definición de Johnny
local npc = NPC.create({
    name = "Johnny", 
    defaultOutfit = 133, 
    defaultFlags = Flag.FLAG_MOVEABLE,
    plugin = 0,
    walkinterval = 2000, -- Intervalo de caminata solicitado
})

-- Outfit exacto solicitado
npc:setOutfit({
    type = 133, 
    head = 114, 
    body = 119, 
    legs = 132, 
    feet = 114, 
    addons = 0
})

-- Configuración de Promociones
local promotionConfigs = {
    ["promotion"] = {id = 1, cost = 20000, level = 20, text = "Congratulations! You are now promoted."},
    ["epic"] = {id = 2, cost = 200000, level = 120, text = "Congratulations! You are now epicized."}
}

local playerState = {}

-- Callback de diálogos
npc:setcallback(function(cid, desc)
    local player = Player(cid)
    if not player then return false end

    -- Saludos
    if desc == "hi" or desc == "hola" then
        npc:say("Hello " .. player:getName() .. ". I can promote you to a higher rank. Just say 'promote' or 'epic'!", 0)
        playerState[cid] = nil

    -- Solicitud de Promoción Básica
    elseif desc == "promot" or desc == "promote" or desc == "promotion" or desc == "promocion" then
        local config = promotionConfigs["promotion"]
        npc:say("I can promote you for " .. config.cost .. " gold coins. Do you want me to promote you?", 0)
        playerState[cid] = "promotion"

    -- Solicitud de Promoción Epic (La que estaba comentada en tu script)
    elseif desc == "epic" or desc == "epicize" then
        local config = promotionConfigs["epic"]
        npc:say("I can epicize you for " .. config.cost .. " gold coins. Do you want me to epicize you?", 0)
        playerState[cid] = "epic"

    -- Confirmación de la acción
    elseif desc == "yes" then
        local choice = playerState[cid]
        if choice and promotionConfigs[choice] then
            local config = promotionConfigs[choice]
            
            -- 1. Verificar Nivel
            if player:getLevel() < config.level then
                npc:say("Sorry, you need to be level " .. config.level .. " to receive this promotion.", 0)
                playerState[cid] = nil
                return true
            end

            -- 2. Verificar si ya está promocionado (para evitar pagar dos veces por lo mismo)
            if player:getPromotion() >= config.id then
                npc:say("You are already promoted to this rank or higher!", 0)
                playerState[cid] = nil
                return true
            end

            -- 3. Cobrar y Promocionar
            if player:removeMoney(config.cost) then
                player:setPromotion(config.id)
                npc:say(config.text, 0)
            else
                npc:say("Sorry, you do not have enough money.", 0)
            end
            playerState[cid] = nil
        else
            npc:say("Please tell me which promotion you want first.", 0)
        end

    elseif desc == "no" then
        npc:say("Alright then, come back when you are ready.", 0)
        playerState[cid] = nil
    end

    return true
end)

npc:setkeywordTable(keywordTable)
npc:register()
