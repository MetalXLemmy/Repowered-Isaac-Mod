RepoweredPack.COLLECTIBLE_ARACHNAPHOBIA = Isaac.Isaac.GetItemIdByName("Arachnaphobia")

function RepoweredPack:onPickupArachnaphobia()
	local spiderItemList = nil

	for i, itemId in ipairs(CollectibleType) do
		if Isaac.GetItemConfig():GetCollectible(itemId):HasTags(ItemConfigEnums.TAG_SPIDER) then
			local itemRemoved = game:RemoveCollectible(itemId)
			Isaac.DebugString(tostring(itemId).." removed: "..itemRemoved)
		end
	end

	changeBlueSpidersToBlueFlies(EntityPlayer)
	changeSpiderEnemiesToFlyEnemies()
end

RepoweredPack:AddCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, RepoweredPack.onPickupArachnaphobia, RepoweredPack.COLLECTIBLE_ARACHNAPHOBIA)

local function changeBlueSpidersToBlueFlies(EnitityPlayer)
	local numSpiders = EntityPlayer:GetNumBlueSpiders()
	local counter = 1

	for counter,numSpiders,1 do
		EntityPlayer:RemoveBlueSpider()
	end

	EntityPlayer:AddBlueFlies(numSpiders, EntityPlayer.Position, EntityPlayer)
end

RepoweredPack:AddCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, RepoweredPack.onPickupArachnaphobia, RepoweredPack.COLLECTIBLE_ARACHNAPHOBIA)

function RepoweredPack:whileHeldArachnaphobia(entity)
	local hasArachnaphobia = false
	
	for i = game:GetNumPlayers()-1, 0, -1 do
		hasArachnaphobia = Isaac.GetPlayer(i):HasCollectible(RepoweredPack.COLLECTIBLE_ARACHNAPHOBIA)
	end
	
	if hasArachnaphobia then changeSpiderEnemiesToFlyEnemies(entity) end
end

RepoweredPack:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, RepoweredPack.whileHeldArachnaphobia)

local function changeSpiderEnemiesToFlyEnemies(entity)
	if entity.Type == EntityType.ENTITY_SPIDER then
		spawnReplacement(entity:ToNPC(), EntityType.ENTITY_ATTACKFLY, 0)
		
	elseif entity.Type == EntityType.ENTITY_BIGSPIDER then
		spawnReplacement(entity:ToNPC(), EntityType.ENTITY_MOTER, 0)
		
	elseif entity.Type == EntityType.ENTITY_NEST then
		spawnReplacement(entity:ToNPC(), EntityType.ENTITY_MULLIGAN, 0)
		
	elseif entity.Type == EntityType.ENTITY_BABY_LONG_LEGS then
		spawnReplacement(entity:ToNPC(), EntityType.ENTITY_SWARMER, 0)
		
	elseif entity.Type == EntityType.ENTITY_CRAZY_LONG_LEGS then
		spawnReplacement(entity:ToNPC(), EntityType.ENTITY_FULL_FLY, 0)
		
	elseif entity.Type == EntityType.ENTITY_SPIDER_L2 then
		spawnReplacement(entity:ToNPC(), EntityType.ENTITY_FLY_L2, 0)
		
	elseif entity.Type == EntityType.ENTITY_BLISTER then
		spawnReplacement(entity:ToNPC(), EntityType.ENTITY_BOOMFLY, 25)
		
	elseif entity.Type == EntityType.ENTITY_STRIDER then
		spawnReplacement(entity:ToNPC(), EntityType.ENTITY_DART_FLY, 0)
		
	elseif entity.Type == EntityType.ENTITY_ROCK_SPIDER and entity.SubType == 2 then
		spawnReplacement(entity:ToNPC(), EntityType.ENTITY_ARMYFLY, 1)
		
	elseif entity.Type == EntityType.ENTITY_TWITCHY then
		spawnReplacement(entity:ToNPC(), EntityType.ENTITY_GAPER_L2, 0)
		
	elseif entity.Type == EntityType.ENTITY_SWARM_SPIDER then
		spawnReplacement(entity:ToNPC(), EntityType.ENTITY_SWARM, 0)
	
	--Widow
	elseif entity.Type == EntityType.ENTITY_WIDOW and entity.SubType == 0 then
		local bossPool = { 19, 20, 62, 63, 67, 71, 79, 79, 79, 81, 82, 237, 237, 260, 261, 261, 404, 405, 908 }
		local bossSubType = { [79] = math.random(0, 2), [237] = math.random(1, 2), [261] = math.random(0, 1) }
		local newMob = bossPool[ math.random(#bossPool) ]
		
		if newMob == 79 or newMob == 237 or newMob == 261 then
			spawnReplacement(entity, newMob, bossSubType[newMob])
		else
			spawnReplacement(entity, newMob, 0)
		end
	
	--The Wretched
	elseif entity.Type == EntityType.ENTITY_WIDOW and entity.SubType == 1 then
		local bossPool = { 19, 28, 28, 28, 36, 62, 64, 67, 68, 71, 81, 82, 99, 262, 264, 267, 269, 401, 403, 409, 411, 916 }
		local newMob = bossPool[ math.random(#bossPool) ]
		
		if newMob == 19 or newMob == 67 then
			spawnReplacement(entity, newMob, 1)
		elseif newMob == 62 then
			spawnReplacement(entity, newMob, 2)
		elseif newMob == 28 then
			spawnReplacement(entity, newMob, math.random(0,2)
		else
			spawnReplacement(entity, newMob, 0)
		end
	
	--Daddy Long Legs or Triachnid
	elseif entity.Type == EntityType.ENTITY_DADDYLONGLEGS and entity.SubType == 0 then
		local bossPool = { 62, 65, 66, 68, 69, 71, 74, 81, 82, 266, 410, 413 }
		local newMob = bossPool[ math.random(#bossPool) ]
		
		if newMob == 62 or newMob == 65 or newMob == 68 or newMob == 69 or newMob == 71 then
			spawnReplacement(entity, newMob, 1)
		else
			spawnReplacement(entity, newMob, 0)
		end
		
	elseif entity.Type == EntityType.ENTITY_REAP_CREEP then
		local bossPool = { 64, 65, 69, 81, 82, 97, 268, 403, 920 }
		
		spawnReplacement(entity, bossPool[ math.random(#bossPool) ], 0)
	end
end

local function spawnReplacement(entity, replacementId, replacementSubType)
	entity:ToNPC():Morph(replacementId, 0, replacementSubType, entity:ToNPC():GetChampionColorIdx())
	Isaac.DebugString(entity.Type.."."..entity.SubType.." replaced with "..replacementId.."."..replacementSubType)
end

