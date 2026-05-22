-- ============================================================
-- RAID: ORC DAILY INVASION (Activo de 9:00 a 17:00 todos los días)
-- ============================================================
local raid = Raid.create("Orc Daily Invasion")

-- ============================================================
-- CONFIGURACIÓN DE TIEMPO
-- Intervalo: 1 minuto (verifica cada minuto si estamos en horario)
-- Margen: 0 (sin variación aleatoria, queremos precisión)
-- ============================================================
raid:setInterval(1)     -- Revisa cada minuto
raid:setMargin(0)       -- Sin desviación aleatoria
raid:setRefType(RaidRefType.BLOCK) -- Tipo BLOCK (el raid permanece "activo" mientras se ejecuta)

-- ============================================================
-- FUNCIÓN DE INICIO DEL RAID (Aquí verificamos el horario)
-- ============================================================
local function onStart(raidInstance)
    -- Obtener hora actual del servidor (formato 24h)
    local time = os.date("*t")
    local currentHour = time.hour
    
    -- Verificar si estamos fuera del horario permitido (9:00-17:00)
    if currentHour < 9 or currentHour >= 17 then
        -- Fuera de horario: cancelamos esta instancia del raid
        return false 
    end
    
    -- ============================================================
    -- HORARIO VÁLIDO (9:00-17:00): PROCEDER CON EL SPAWN
    -- ============================================================
    
    -- Centro del raid (coordenadas exactas solicitadas)
    local center = Position(160, 50, 7)
    local radius = 3 -- Radio de aparición (ajustable: 3 = área de 7x7 tiles)
    
    -- Configuración de spawns (pesos para distribución equilibrada)
    local spawnConfig = {
        {name = "Orc",        weight = 50},  -- 50% probabilidad
        {name = "Orc Raider", weight = 30},  -- 30% probabilidad
        {name = "Orc Berserker", weight = 15},-- 15% probabilidad
        {name = "Orc Leader", weight = 5}    -- 5% probabilidad
    }
    
    -- Función auxiliar para elegir un monstruo basado en pesos
    local function chooseMonster()
        local totalWeight = 0
        for _, v in ipairs(spawnConfig) do
            totalWeight = totalWeight + v.weight
        end
        
        local random = math.random(1, totalWeight)
        local cumulative = 0
        
        for _, v in ipairs(spawnConfig) do
            cumulative = cumulative + v.weight
            if random <= cumulative then
                return v.name
            end
        end
        return spawnConfig[#spawnConfig].name -- Fallback
    end
    
    -- Spawnear 15 monstruos en total (ajusta este número según necesites)
    local totalMonsters = 15
    for i = 1, totalMonsters do
        -- Elegir tipo de orco aleatoriamente según pesos
        local monsterName = chooseMonster()
        
        -- Generar posición aleatoria dentro del radio
        local spawnPos = center:getRandomPosition(radius)
        
        -- Crear el monstruo
        Game.createMonster(monsterName, spawnPos, false, true)
    end
    
    -- Mensaje opcional para GM/debug (descomenta si necesitas ver logs)
    -- Game.broadcastMessage("Orc Daily Invasion spawned at " .. center.x .. "," .. center.y .. "," .. center.z, MessageStatus.OUTPUT_CHANNEL)
    
    return true -- Indica que el raid se ejecutó exitosamente
end

-- ============================================================
-- ASIGNAR FUNCIÓN DE INICIO Y REGISTRAR EL RAID
-- ============================================================
raid:setOnStart(onStart)
raid:register()
