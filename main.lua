local RepoweredPack = RegisterMod("Repowered Pack", 1)

local game = Game()

local Constants <const> = {
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
