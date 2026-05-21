local keywordTable = {
    "blessing",
    "blessings",
    "blessed",
    "supreme",
    "divine",
    "yes",
    "no"
}

-- Definición de Alice
local npc = NPC.create({
    name = "Alice", 
    defaultOutfit = 139, 
    defaultFlags = Flag.FLAG_MOVEABLE,
    plugin = 0
})

-- Outfit exacto solicitado
npc:setOutfit({
    type = 139, 
    head = 20, 
    body = 39, 
    legs = 45, 
    feet = 7, 
    addons = 0
})

-- Precios base de las bendiciones (El costo final es: Base + (Level * 100))
local blessingCosts = {
    [1] = {name = "Blessed", base = 20000},
    [2] = {name = "Supreme", base = 50000},
    [3] = {name = "Divine", base = 100000},
}

local playerState = {}

-- Función para calcular el costo real según el nivel
local function getBlessingPrice(player, type)
    local level = player:getLevel()
    return blessingCosts[type].base + (level * 100)
end

-- Callback de diálogos
npc:setcallback(function(cid, desc)
    local player = Player(cid)
    if not player then return false end

    -- Menú Principal
    if desc == "blessing" or desc == "blessings" then
        npc:say("I can give you the following blessings:", 0)
        npc:say("- Blessed Blessing", 0)
        npc:say("- Supreme Blessing", 0)
        npc:say("- Divine Blessing", 0)
        npc:say("Which one would you like?", 0)
        playerState[cid] = nil

    -- Selección de Blessed
    elseif desc == "blessed" then
        local cost = getBlessingPrice(player, 1)
        npc:say("A Blessed Blessing costs " .. cost .. " gold coins. Do you want it?", 0)
        playerState[cid] = 1

    -- Selección de Supreme
    elseif desc == "supreme" then
        local cost = getBlessingPrice(player, 2)
        npc:say("A Supreme Blessing costs " .. cost .. " gold coins. Do you want it?", 0)
        playerState[cid] = 2

    -- Selección de Divine
    elseif desc == "divine" then
        local cost = getBlessingPrice(player, 3)
        npc:say("A Divine Blessing costs " .. cost .. " gold coins. Do you want it?", 0)
        playerState[cid] = 3

    -- Confirmación de compra
    elseif desc == "yes" then
        local type = playerState[cid]
        if type and blessingCosts[type] then
            local cost = getBlessingPrice(player, type)
            if player:removeMoney(cost) then
                player:addBlessing(type)
                npc:say("There you go! You are now blessed.", 0)
            else
                npc:say("Sorry, you do not have enough money.", 0)
            end
            playerState[cid] = nil
        else
            npc:say("Please tell me which blessing you want first.", 0)
        end

    elseif desc == "no" then
        npc:say("No problem. Let me know if you change your mind.", 0)
        playerState[cid] = nil
    end

    return true
end)

npc:setkeywordTable(keywordTable)
npc:register()
