local oldAutolootStorage = 30063
local flasksStorage = "talkaction.potions.flask"

local function migrate(player)
	local isAutoLoot = player:getStorageValue(oldAutolootStorage)
	if isAutoLoot > 0 then
		player:setFeature(Features.AutoLoot, 1)
		player:setStorageValue(oldAutolootStorage, -1)
	end

	local getOldFlasksStorage = player:kv():get(flasksStorage) or 0
	if getOldFlasksStorage > 0 then
		player:kv():set("talkaction.potions.flask", true)
		player:kv():set(flasksStorage, -1)
	end
end

local migration = Migration("20241708485868_move_some_storages_to_kv")

function migration:onExecute()
	self:forEachPlayer(migrate)
end

migration:register()
