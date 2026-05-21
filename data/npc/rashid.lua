local keywordTable = {
    "hi", "hola",
    "trade", "vender",
    "yes", "no"
}

-- =========================================================================================
-- CONFIGURACIÓN DE COMPRA (NPC compra estos ítems del jugador)
// Formato: [ItemID] = Precio que el NPC paga al jugador
// Extraído directamente de tu parámetro shop_sellable
-- =========================================================================================
local shopSell = {
    -- Armors
    [2472] = 150000, -- Magic Plate Armor
    [2470] = 70000,  -- Golden Legs
    [2503] = 20000,  -- Dwarven Armor
    [2466] = 20000,  -- Golden Armor
    [2492] = 40000,  -- Dragon Scale Mail
    [3968] = 1000,   -- Leopard Armor
    [7463] = 6000,   -- Mammoth Fur Cape

    -- Shields
    [2536] = 9000,   -- Medusa Shield
    [2514] = 50000,  -- Mastermind Shield
    [2520] = 30000,  -- Demon Shield
    [2535] = 5000,   -- Castle Shield
    [2540] = 2000,   -- Scarab Shield
    [2521] = 400,    -- Dark Shield
    [6131] = 150,    -- Tortoise Shield
    [2541] = 80,     -- Bone Shield

    -- Boots
    [2645] = 20000,  -- Steel Boots
    [5462] = 3000,   -- Pirate Boots
    [7457] = 2000,   -- Fur Boots
    [3982] = 1000,   -- Crocodile Boots

    -- Legs / Accessories
    [5918] = 200,    -- Pirate Knee Breeches
    [7462] = 400,    -- Ragnir Helmet
    [7461] = 200,    -- Krimhorn Helmet
    [6095] = 500,    -- Pirate Shirt

    -- Helmets
    [5741] = 40000,  -- Skull Helmet
    [3972] = 7500,   -- Beholder Helmet
    [2462] = 1000,   -- Devil Helmet
    [6096] = 1000,   -- Pirate Hat

    -- Amulets
    [2142] = 200,    -- Ancient Amulet
    [2135] = 200,    -- Scarab Amulet

    -- Weapons
    [7402] = 15000,  -- Dragon Slayer
    [2454] = 9000,   -- War Axe
    [2442] = 90,     -- Heavy Machete
    [2439] = 110,    -- Daramanian Mace
    [7381] = 300,    -- Mammoth Whopper
    [2402] = 500,    -- Silver Dagger
    [7425] = 500,    -- Taurus Mace
    [7449] = 600,    -- Crystal Sword
    [7432] = 1000,   -- Furry Club
    [2440] = 1000,   -- Daramanian Axe
    [7408] = 1500,   -- Wyvern Fang
    [7379] = 1500,   -- Brutetamers Staff
    [3962] = 1500,   -- Beastslayer Axe
    [7430] = 3000,   -- Dragonbone Staff
    [7387] = 3000,   -- Diamond Sceptre
    [7451] = 5000,   -- Lunar Staff
    [7437] = 7000,   -- Sapphire Hammer
    [7426] = 8000,   -- Amber Staff

    -- Tools
    [5710] = 300,    -- Light Shovel
    [5918] = 200,    -- Pirate Knee Breeches (ya listado arriba, pero lo mantengo por claridad)
}
-- =========================================================================================

-- Definición de Rashid
local npc = NPC.create({
    name = "Rashid", 
    defaultOutfit = 146, 
    defaultFlags = Flag.FLAG_MOVEABLE,
    plugin = 0,
    walkinterval = 2000, -- Intervalo de caminata solicitado
    shopSell = shopSell  -- Activa la función de compra (NPC paga al jugador)
})

-- Outfit exacto solicitado
npc:setOutfit({
    type = 146, 
    head = 12, 
    body = 101, 
    legs = 122, 
    feet = 115, 
    addons = 2
})

-- Callback de diálogos
npc:setcallback(function(cid, desc)
    local player = Player(cid)
    if not player then return false end

    -- Saludo inicial (con nombre del jugador)
    if desc == "hi" or desc == "hola" then
        npc:say("Hello " .. player:getName() .. ". I buy helmets, armors, legs, boots, weapons and shields, just {trade}.", 0)

    -- Abrir ventana de comercio para vender ítems
    elseif desc == "trade" or desc == "vender" then
        npc:say("Sure! Show me what you have to sell.", 0)
        player:openTrade(npc) -- Abre la ventana donde el jugador puede vender ítems a Rashid

    elif desc == "yes" then
        npc:say("I'm waiting for your items in the trade window.", 0)
    elseif desc == "no" then
        npc:say("No problem! Come back when you have something to sell.", 0)
    end

    return true
end)

npc:setkeywordTable(keywordTable)
npc:register()
