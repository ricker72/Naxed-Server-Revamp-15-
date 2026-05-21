local keywordTable = {
    "hi", "hola",
    "shop", "trade", "comprar", "vender",
    "ham", "meat", "carrot", "apple", "bread", "mushroom", "egg",
    "yes", "no"
}

-- =========================================================================================
-- CONFIGURACIÓN DE VENTAS (shopBuy)
-- Formato: [ItemID] = Precio que el jugador paga
-- =========================================================================================
local shopBuy = {
    [2691] = 8,  -- Brown bread
    [2671] = 8,  -- Ham
    [2684] = 8,  -- Carrot
    [2666] = 8,  -- Meat
    [2674] = 8,  -- Apple
    [2789] = 8,  -- Brown mushroom
    [2695] = 8,  -- Egg
}
-- =========================================================================================

-- Definición de Donald
local npc = NPC.create({
    name = "Donald", 
    defaultOutfit = 128, 
    defaultFlags = Flag.FLAG_MOVEABLE,
    plugin = 0,
    walkinterval = 2000, -- Intervalo de caminata solicitado
    shopBuy = shopBuy    -- Activa la tienda de venta
})

-- Outfit exacto solicitado
npc:setOutfit({
    type = 128, 
    head = 20, 
    body = 100, 
    legs = 50, 
    feet = 99, 
    addons = 0
})

-- Callback de diálogos
npc:setcallback(function(cid, desc)
    local player = Player(cid)
    if not player then return false end

    -- Saludo inicial (Copiado exactamente de tu parámetro message_greet)
    if desc == "hi" or desc == "hola" then
        npc:say("Hello " .. player:getName() .. ". I sell ham, meat, carrots, apples, brown breads, brown mushrooms and eggs (everything for 8 gold coins)!", 0)

    -- Abrir ventana de Trade
    elseif desc == "shop" or desc == "trade" or desc == "comprar" or desc == "vender" then
        npc:say("Sure! Here is my stock. Everything is 8 gold coins.", 0)
        player:openTrade(npc)

    -- Respuesta simple a los ítems (para darle más naturalidad)
    elseif desc == "ham" or desc == "meat" or desc == "carrot" or desc == "apple" or desc == "bread" or desc == "mushroom" or desc == "egg" then
        npc:say("I have plenty of that! Just open the trade window to buy it.", 0)

    elseif desc == "yes" then
        npc:say("I'm waiting for your order in the trade window.", 0)
    elseif desc == "no" then
        npc:say("No problem! Come back when you are hungry.", 0)
    end

    return true
end)

npc:setkeywordTable(keywordTable)
npc:register()
