local RepoweredPack = RegisterMod("Repowered Pack", 1)

--Plush heart start
RepoweredPack.COLLECTIBLE_PLUSH_HEART = Isaac.GetItemIdByName("Plush Heart")

function RepoweredPack:ActivateItemPlushSqueeze(CollectibleType,RNG,EntityPlayer,UseFlags,ActiveSlot,CustomVarData)
  
  if (EntityPlayer:GetHearts()>2 or (EntityPlayer:GetSoulHearts()>=1 and EntityPlayer:GetHearts()>=2)) then
    --Player has enough red health.
    local rng = math.random() --float between 0.0000... and 1
  
    EntityPlayer:AnimateHappy()
    EntityPlayer:AddHearts(-2)
    
    if (EntityPlayer:HasCollectible(203)) then --WHYYYYYYYYYYYYY!!!!!!!!!!!
      --Humbling Bundle Synergy
      if (rng < 0.20) then 
        --20% chance
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_DOUBLEPACK, EntityPlayer.Position, EntityPlayer.Velocity, EntityPlayer)
      elseif (rng < 0.8) then 
        --60% chance
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, EntityPlayer.Position, EntityPlayer.Velocity, EntityPlayer)
      else 
        --20% chance
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SCARED, EntityPlayer.Position, EntityPlayer.Velocity, EntityPlayer)
      end
    else
      if (rng < 0.75) then 
        --75% chance
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, EntityPlayer.Position, EntityPlayer.Velocity, EntityPlayer)
      else 
        --25% chance
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SCARED, EntityPlayer.Position, EntityPlayer.Velocity, EntityPlayer)
      end
    end
    
  else
    --Player doesn't have enough red hearts.
    EntityPlayer:AnimateSad()
  end
end

RepoweredPack:AddCallback(ModCallbacks.MC_USE_ITEM, RepoweredPack.ActivateItemPlushSqueeze, RepoweredPack.COLLECTIBLE_PLUSH_HEART)

--EID
RepoweredPack:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function()
	if EID then
		EID:addTrinket(RepoweredPack.COLLECTIBLE_PLUSH_HEART, "", "Plague of Locusts", "en_us")
	end
end)

--Plush heart end

--Chaotic D6 start
RepoweredPack.COLLECTIBLE_CHAOTIC_D6 = Isaac.GetItemIdByName("Chaotic D6")

local function ChaosReroll(possiblePools)
  local entities = Isaac.GetRoomEntities()
  
  for k,entity in pairs(entities) do
		if 	entity.Type == EntityType.ENTITY_PICKUP 
			and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE 
			and entity.SubType > 0
			then
        local newItem = Game():GetItemPool():GetCollectible(possiblePools[math.random(#possiblePools)] , true, Random(), CollectibleType.COLLECTIBLE_BREAKFAST)
        local pickup = entity:ToPickup()
        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, newItem, true)
    end
  end
end

function RepoweredPack:ActivateItemChaoticD6()
  if (Game().Difficulty == Difficulty.DIFFICULTY_NORMAL or Game().Difficulty == Difficulty.DIFFICULTY_HARD) then
    local possibleNormalPools = {ItemPoolType.POOL_TREASURE, ItemPoolType.POOL_SHOP, ItemPoolType.POOL_BOSS, ItemPoolType.POOL_DEVIL, ItemPoolType.POOL_ANGEL, ItemPoolType.POOL_SECRET, ItemPoolType.POOL_LIBRARY, ItemPoolType.POOL_SHELL_GAME, ItemPoolType.POOL_GOLDEN_CHEST, ItemPoolType.POOL_RED_CHEST, ItemPoolType.POOL_BEGGAR, ItemPoolType.POOL_DEMON_BEGGAR, ItemPoolType.POOL_CURSE, ItemPoolType.POOL_KEY_MASTER, ItemPoolType.POOL_BATTERY_BUM, ItemPoolType.POOL_MOMS_CHEST, ItemPoolType.POOL_CRANE_GAME, ItemPoolType.POOL_BOMB_BUM, ItemPoolType.POOL_PLANETARIUM, ItemPoolType.POOL_OLD_CHEST, ItemPoolType.POOL_BABY_SHOP, ItemPoolType.POOL_WOODEN_CHEST, ItemPoolType.POOL_ROTTEN_BEGGAR}
    
    ChaosReroll(possibleNormalPools)
  elseif (Game().Difficulty == Difficulty.DIFFICULTY_GREED or Game().Difficulty == Difficulty.DIFFICULTY_GREEDIER) then
    local possibleGreedPools = {ItemPoolType.POOL_GREED_TREASUREL, ItemPoolType.POOL_GREED_SHOP, ItemPoolType.POOL_GREED_BOSS, ItemPoolType.POOL_GREED_DEVIL, ItemPoolType.POOL_GREED_ANGEL, ItemPoolType.POOL_GREED_SECRET, ItemPoolType.POOL_SHELL_GAME, ItemPoolType.POOL_GOLDEN_CHEST, ItemPoolType.POOL_RED_CHEST, ItemPoolType.POOL_BEGGAR, ItemPoolType.POOL_DEMON_BEGGAR, ItemPoolType.POOL_GREED_CURSE, ItemPoolType.POOL_KEY_MASTER, ItemPoolType.POOL_BATTERY_BUM, ItemPoolType.POOL_BOMB_BUM, ItemPoolType.POOL_OLD_CHEST, ItemPoolType.POOL_BABY_SHOP, ItemPoolType.POOL_WOODEN_CHEST, ItemPoolType.POOL_ROTTEN_BEGGAR}
    
    ChaosReroll(possibleNormalPools)
  end
end

RepoweredPack:AddCallback(ModCallbacks.MC_USE_ITEM, RepoweredPack.ActivateItemChaoticD6, RepoweredPack.COLLECTIBLE_CHAOTIC_D6)
--Chaotic D6 end