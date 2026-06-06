local config = {
	monsterName = "Gaffir",
	bossPosition = Position(717, 358, 4),
	centerPosition = Position(717, 358, 4),
	rangeX = 50,
	rangeY = 50,
}

local miniBoss = GlobalEvent("gaffir")
function miniBoss.onThink(interval, lastExecution)
	checkBoss(config.centerPosition, config.rangeX, config.rangeY, config.monsterName, config.bossPosition)
	return true
end

miniBoss:interval(15 * 60 * 1000)
miniBoss:register()
