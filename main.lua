local RepoweredPack = RegisterMod("Repowered Pack", 1)

local game = Game()

local Constants = {
		FULL_HEART = 2,
		HALF_HEART = 1,
		DEFAULT_COLLECTIBLE = Isaac.GetItemIdByName("Breakfast")
	}

--Plush heart start
RepoweredPack.COLLECTIBLE_PLUSH_HEART = Isaac.GetItemIdByName("Plush Heart")

function RepoweredPack:ActivateItemPlushSqueeze(collectible, RNG, player, flags, activeItemSlot, data)
	if (player:GetHearts()>Constants.FULL_HEART or (player:GetSoulHearts()>=Constants.HALF_HEART and player:GetHearts()>=Constants.FULL_HEART)) then
		--Player has enough red health.
		local rng = RNG:RandomFloat() --float between 0.0000... and 1
  
		player:AnimateHappy() --Thumbs up
		player:AddHearts(-Constants.FULL_HEART) --Remove a full red heart from Isaacs health (max hearts stay the same) 
    
		if player:HasCollectible(Isaac.GetItemIdByName("Humbling Bundle")) then
			--Humbling Bundle Synergy
			if (rng < 0.20) then 
				--20% chance
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_DOUBLEPACK, player.Position, player.Velocity, player)
			elseif (rng < 0.9) then 
				--70% chance
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, player.Position, player.Velocity, player)
			else 
				--10% chance
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SCARED, player.Position, player.Velocity, player)
			end
		else
			if (rng < 0.75) then 
				--75% chance
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, player.Position, player.Velocity, player)
			else 
				--25% chance
				Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SCARED, player.Position, player.Velocity, player)
			end
		end
	else
		--Player doesn't have enough red hearts.
		player:AnimateSad()
	end
end

RepoweredPack:AddCallback(ModCallbacks.MC_USE_ITEM, RepoweredPack.ActivateItemPlushSqueeze, RepoweredPack.COLLECTIBLE_PLUSH_HEART)

--EID
RepoweredPack:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	if EID then
		EID:addCollectible(
				RepoweredPack.COLLECTIBLE_PLUSH_HEART, 
				"Activate: empty a {{Heart}} to spawn a {{Heart}} pick-up#25%: {{ColorRed}}Scared Heart{{ColorText}}#{{Blank}}#{{Collectible203}} 20%: {{ColorRed}}Double Heart#{{Blank}} 10%: {{ColorRed}}Scared Heart", 
				"Plush Heart", 
				"en_us"
			)
	end
end)

--Plush heart end

--Chaotic D6 start
RepoweredPack.COLLECTIBLE_CHAOTIC_D6 = Isaac.GetItemIdByName("Chaotic D6")

--Helper function for Chaotic D6. Required param: possiblePools of type Table. Table must contain possible item pool values. Changes all item pedestals in the room to a possible item from the possible pool.
local function ChaosReroll(possiblePools)
	local entities = Isaac.GetRoomEntities()
  
	for k,entity in pairs(entities) do
		if 	entity.Type == EntityType.ENTITY_PICKUP --checks if entity is pickup
			and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE --checks if entity is collectible (active or passive)
			and entity.SubType > 0 --checks if pedestal is not empty
		then
			local newItem = game:GetItemPool():GetCollectible(possiblePools[math.random(#possiblePools)] , true, Random(), Constants.DEFAULT_COLLECTIBLE) --Selects a random pool from possiblePools variable. Rolls for a new item from that pool. If there are no more items, it will spawn breakfast.
			local pickup = entity:ToPickup() --gets the EntityPickup from the entity "class" to access its methods
			pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItem, true) --transforms the existing entity into a new one with the new collectible
		end
	end
end

--Start of active item functionality. Determins the current gamemode
function RepoweredPack:ActivateItemChaoticD6()
	if (game.Difficulty == Difficulty.DIFFICULTY_NORMAL or game.Difficulty == Difficulty.DIFFICULTY_HARD) then --gamemode check
		local possibleNormalPools = {ItemPoolType.POOL_TREASURE, ItemPoolType.POOL_SHOP, ItemPoolType.POOL_BOSS, ItemPoolType.POOL_DEVIL, ItemPoolType.POOL_ANGEL, ItemPoolType.POOL_SECRET, ItemPoolType.POOL_LIBRARY, ItemPoolType.POOL_SHELL_GAME, ItemPoolType.POOL_GOLDEN_CHEST, ItemPoolType.POOL_RED_CHEST, ItemPoolType.POOL_BEGGAR, ItemPoolType.POOL_DEMON_BEGGAR, ItemPoolType.POOL_CURSE, ItemPoolType.POOL_KEY_MASTER, ItemPoolType.POOL_BATTERY_BUM, ItemPoolType.POOL_MOMS_CHEST, ItemPoolType.POOL_CRANE_GAME, ItemPoolType.POOL_BOMB_BUM, ItemPoolType.POOL_PLANETARIUM, ItemPoolType.POOL_OLD_CHEST, ItemPoolType.POOL_BABY_SHOP, ItemPoolType.POOL_WOODEN_CHEST, ItemPoolType.POOL_ROTTEN_BEGGAR}
    
		ChaosReroll(possibleNormalPools) --Executes the reroll with the normal and hard mode item pools
	elseif (game.Difficulty == Difficulty.DIFFICULTY_GREED or game.Difficulty == Difficulty.DIFFICULTY_GREEDIER) then
		local possibleGreedPools = {ItemPoolType.POOL_GREED_TREASUREL, ItemPoolType.POOL_GREED_SHOP, ItemPoolType.POOL_GREED_BOSS, ItemPoolType.POOL_GREED_DEVIL, ItemPoolType.POOL_GREED_ANGEL, ItemPoolType.POOL_GREED_SECRET, ItemPoolType.POOL_SHELL_GAME, ItemPoolType.POOL_GOLDEN_CHEST, ItemPoolType.POOL_RED_CHEST, ItemPoolType.POOL_BEGGAR, ItemPoolType.POOL_DEMON_BEGGAR, ItemPoolType.POOL_GREED_CURSE, ItemPoolType.POOL_KEY_MASTER, ItemPoolType.POOL_BATTERY_BUM, ItemPoolType.POOL_BOMB_BUM, ItemPoolType.POOL_OLD_CHEST, ItemPoolType.POOL_BABY_SHOP, ItemPoolType.POOL_WOODEN_CHEST, ItemPoolType.POOL_ROTTEN_BEGGAR}
    
		ChaosReroll(possibleNormalPools) --Executes the reroll with the greed and greedier mode item pools
	end
end

RepoweredPack:AddCallback(ModCallbacks.MC_USE_ITEM, RepoweredPack.ActivateItemChaoticD6, RepoweredPack.COLLECTIBLE_CHAOTIC_D6)

RepoweredPack:AddCallback(ModCallbacks.MC_POST_RENDER, function()
	if EID then
		EID:addCollectible(
				RepoweredPack.COLLECTIBLE_CHAOTIC_D6, 
				"Activate: Rerolls all pedestals in the room#{{Warning}} Ignores item pools like {{Collectible402}}", 
				"Chaotic D6", 
				"en_us"
			)
	end
end)
--Chaotic D6 end

--Arachnophobia start
RepoweredPack.COLLECTIBLE_ARACHNOPHOBIA = Isaac.GetItemIdByName("Arachnophobia")

local playerWithArachnophobia = nil
local spiderItemListRemoved = false
local spiderItemList = {
		--Actives
			Isaac.GetItemIdByName("Box of Spiders"),
			Isaac.GetItemIdByName("Spider Butt"),
		--Passives
			Isaac.GetItemIdByName("Mutant Spider"),
			Isaac.GetItemIdByName("Spider Bite"),
			Isaac.GetItemIdByName("Spider Baby"),
			Isaac.GetItemIdByName("Spider Mod"),
			Isaac.GetItemIdByName("Keeper's Kin"),
			Isaac.GetItemIdByName("The Intruder"),
		
			Isaac.GetItemIdByName("Daddy Longlegs"),
			Isaac.GetItemIdByName("Hive Mind"),
			Isaac.GetItemIdByName("Infestation 2"),
			Isaac.GetItemIdByName("Juicy Sack"),
			Isaac.GetItemIdByName("Sissy Longlegs"),
			Isaac.GetItemIdByName("Bursting Sack"),
			Isaac.GetItemIdByName("Sticky Bombs"),
			Isaac.GetItemIdByName("Parasitoid"),
		--Modded Actives
		
		--Modded Passives
			RepoweredPack.COLLECTIBLE_ARACHNOPHOBIA
		}

local function PickupArachnophobia()
	for i = 1, #spiderItemList, 1 do
		local output = game:GetItemPool():RemoveCollectible(spiderItemList[i])
		Isaac.DebugString("Removed item "..tostring(spiderItemList[i]).." from item pool: "..tostring(output))
	end
	
	spiderItemListRemoved = true
end

local function TableContainsValue(value, table)
	for i, v in ipairs(table) do
		if value == v then return true end
	end
	
	return false
end

function RepoweredPack:EffectArachnophobia(pickup, collider)
	local player = collider:ToPlayer()
	
	if not player == nil
		and pickup.then
		Isaac.DebugString(tostring(player:GetNumBlueSpiders()))
		local CurrentPool = game:GetItemPool()
		
		if not spiderItemListRemoved then PickupArachnophobia() end
    		
		for k,entity in pairs(entities) do
			if 	entity.Type == EntityType.ENTITY_PICKUP --checks if entity is pickup
				and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE --checks if entity is collectible (active or passive)
				and entity.SubType > 0 --checks if pedestal is not empty
			then
				if TableContainsValue(entity.SubType, spiderItemList) then
					local newItem = game:GetItemPool():GetCollectible(CurrentPool:GetLastPool() , true, Random(), Constants.DEFAULT_COLLECTIBLE)
					Isaac.DebugString("Changed pedestal item "..entity.SubType.." to "..newItem)
					local pickup = entity:ToPickup() --gets the EntityPickup from the entity "class" to access its methods
					pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItem, true) --transforms the existing entity into a new one with the new collectible
				end
			end
		end
		
		player::AddBlueFlies(player:GetNumBlueSpiders(), player.Position, player)
		
		Isaac.DebugString("Changed "..player:GetNumBlueSpiders().." Blue Spiders to Blue Flies")
		
		while player:GetNumBlueSpiders() > 0 do
			player:RemoveBlueSpider()
		end
		
		for i=0,game:GetNumPlayers()-1, 1 do
			if game:GetPlayer(i):HasCollectible(RepoweredPack.COLLECTIBLE_ARACHNOPHOBIA) then 
				playerWithArachnophobia = game:GetPlayer(i) 
			end
		end
	end
end

RepoweredPack:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, RepoweredPack.EffectArachnophobia)
RepoweredPack:AddCallback(ModCallbacks.MC_NPC_UPDATE, RepoweredPack.ArachnophobiaESpider, EntityType.ENTITY_SPIDER)
RepoweredPack:AddCallback(ModCallbacks.MC_NPC_UPDATE, RepoweredPack.ArachnophobiaEBigSpider, EntityType.ENTITY_BIGSPIDER)
RepoweredPack:AddCallback(ModCallbacks.MC_NPC_UPDATE, RepoweredPack.ArachnophobiaENest, EntityType.ENTITY_NEST)
RepoweredPack:AddCallback(ModCallbacks.MC_NPC_UPDATE, RepoweredPack.ArachnophobiaEBabyLongLegs, EntityType.ENTITY_BABY_LONG_LEGS)
RepoweredPack:AddCallback(ModCallbacks.MC_NPC_UPDATE, RepoweredPack.ArachnophobiaECrazyLongLegs, EntityType.ENTITY_CRAZY_LONG_LEGS)

function RepoweredPack:ArachnophobiaESpider(entity)
	if playerWithArachnophobia ~= nil then spawnReplacement(entity:ToNPC(), EntityType.ENTITY_ATTACKFLY, 0) end
end

function RepoweredPack:ArachnophobiaEBigSpider(entity)
	if playerWithArachnophobia ~= nil then spawnReplacement(entity:ToNPC(), EntityType.ENTITY_MOTER, 0) end
end

function RepoweredPack:ArachnophobiaENest(entity)
	if playerWithArachnophobia ~= nil then spawnReplacement(entity:ToNPC(), EntityType.ENTITY_MULLIGAN, 0) end
end

function RepoweredPack:ArachnophobiaEBabyLongLegs(entity)
	if playerWithArachnophobia ~= nil then spawnReplacement(entity:ToNPC(), EntityType.ENTITY_SWARMER, 0) end
end
	
end
local function ChangeSpiderEnemiesToFlyEnemies(entity)
		
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
			spawnReplacement(entity, newMob, math.random(0,2))
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
		
		SpawnReplacement(entity, bossPool[ math.random(#bossPool) ], 0)
	end
end

local function SpawnReplacement(entity, replacementId, replacementSubType)
	entity:ToNPC():Morph(replacementId, 0, replacementSubType, entity:ToNPC():GetChampionColorIdx())
	Isaac.DebugString(entity.Type.."."..entity.SubType.." replaced with "..replacementId.."."..replacementSubType)
end
--Arachnophobia end
