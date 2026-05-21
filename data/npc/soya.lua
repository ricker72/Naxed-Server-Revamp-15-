local keywordTable = {
    "hi", "hola",
    "shop", "trade", "vender", "comprar",
    "yes", "no"
}

-- =========================================================================================
-- CONFIGURACIÓN DE COMPRA (shopSell)
-- Formato: [ItemID] = Precio que el NPC paga
-- =========================================================================================
local shopSell = {
    -- Helmets
    [2494] = 40000, -- Royal Helmet
    [2491] = 6000,  -- Warrior Helmet
    [2492] = 9000,  -- Crusader Helmet
    [2493] = 5000,  -- Crown Helmet
    [2490] = 4000,  -- Devil Helmet
    [2488] = 35,    -- Chain Helmet
    [2487] = 30,    -- Iron Helmet
    [2486] = 500,   -- Mystic Turban

    -- Boots
    [2554] = 100000, -- Golden Boots
    [2553] = 40000,  -- Steel Boots
    [2552] = 40000,  -- Boots of Haste

    -- Armors
    [2480] = 30000, -- Golden Armor
    [2481] = 20000, -- Crown Armor
    [2482] = 5000,  -- Knight Armor
    [2483] = 7500,  -- Lady Armor
    [2472] = 400,   -- Plate Armor
    [2471] = 200,   -- Brass Armor
    [2470] = 100,   -- Chain Armor
    [2474] = 100000, -- MPA
    [2475] = 60000,  -- DSM
    [2476] = 15000,  -- Blue Robes

    -- Legs
    [2464] = 80000, -- Golden Legs
    [2465] = 15000, -- Crown Legs
    [2466] = 6000,  -- Knight Legs
    [2462] = 500,   -- Plate Legs
    [2461] = 100,   -- Brass Legs

    -- Shields
    [2501] = 150000, -- Blessed Shield
    [2502] = 100000, -- Great Shield
    [2503] = 40000,  -- Demon Shield
    [2504] = 25000,  -- Vampire Shield
    [2505] = 8000,   -- Medusa Shield
    [2506] = 4000,   -- Amazon Shield
    [2507] = 5000,   -- Crown Shield
    [2508] = 4000,   -- Tower Shield
    [2509] = 3000,   -- Dragon Shield
    [2510] = 2000,   -- Guardian Shield
    [2511] = 1000,   -- Beholder Shield
    [2512] = 100,    -- Dwarven Shield
    [2513] = 80000,  -- MMS

    -- Swords
    [3000] = 10000,  -- Giant Sword
    [3001] = 6000,   -- Bright Sword
    [3002] = 3000,   -- Fire Sword
    [3003] = 1500,   -- Serpent Sword
    [3004] = 800,    -- Spike Sword
    [3005] = 400,    -- Two Handed Sword
    [3006] = 4000,   -- Ice Rapier
    [3007] = 150000, -- Magic Longsword
    [3008] = 90000,  -- Magic Sword
    [3009] = 100000, -- Warlord Sword
    [3010] = 70,     -- Broad Sword
    [3011] = 30,     -- Short Sword
    [3012] = 25,     -- Sabre
    [3013] = 25,     -- Sword

    -- Axes
    [3100] = 10000,  -- Fire Axe
    [3101] = 7500,   -- Guardian Halberd
    [3102] = 2000,   -- Knight Axe
    [3103] = 200,    -- Double Axe
    [3104] = 100,    -- Battle Axe
    [3105] = 10000,  -- Dragon Lance
    [3106] = 90000,  -- Stonecutters Axe
    [3107] = 200,    -- Halberd
    [3108] = 20,     -- Hatchet

    -- Clubs
    [3200] = 90000,  -- Thunder Hammer
    [3201] = 6000,   -- War Hammer
    [3202] = 2000,   -- Dragon Hammer
    [3203] = 60,     -- Battle Hammer
    [3204] = 10000,  -- Skull Staff
    [3205] = 200,    -- Clerical Mace
}

-- Definición de Soya
local npc = NPC.create({
    name = "Soya", 
    defaultOutfit = 139, 
    defaultFlags = Flag.FLAG_MOVEABLE,
    plugin = 0,
    shopSell = shopSell -- Aquí activamos la función de compra automática
})

-- Outfit solicitado
npc:setOutfit({
    type = 139, head = 20, body = 39, legs = 45, feet = 7, addons = 0
})

-- Callback de diálogos
npc:setcallback(function(cid, desc)
    local player = Player(cid)
    if not player then return false end

    -- Saludos
    if desc == "hi" or desc == "hola" then
        npc:say("Hello! I am Soya. I buy rare equipment. Just say 'shop' or 'trade' to see my offer!", 0)

    -- Abrir ventana de Trade
    elseif desc == "shop" or desc == "trade" or desc == "vender" or desc == "comprar" then
        npc:say("Sure! Let's see what you have there.", 0)
        player:openTrade(npc) -- Abre la ventana de comercio oficial

    elseif desc == "yes" then
        npc:say("I'm waiting for your items in the trade window.", 0)
    elseif desc == "no" then
        npc:say("No problem! Come back when you have some gear to sell.", 0)
    end

    return true
end)

npc:setkeywordTable(keywordTable)
npc:register()
