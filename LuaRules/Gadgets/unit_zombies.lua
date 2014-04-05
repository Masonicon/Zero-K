local version = "0.1.0"

function gadget:GetInfo()
	return {
		name		= "Zombies!",
		desc		= "Features are dangerous, reclaim them, as fast, as possible! Version "..version,
		author		= "Tom Fyuri",		-- original gadget was mapmod for trololo by banana_Ai, this is revamped version as a zk anymap gamemode
		date		= "Mar 2014",
		license		= "GPL v2 or later",
		layer		= -3,
		enabled	 	= true
	}
end

--SYNCED-------------------------------------------------------------------

--TODO need rumble gfx/sfx to tell players something is gonna res. Ambient sfx is there is ANY feature that's gonna res, and per unit gfx.. maybe some dust like puppies do...

-- changelog
-- 5 april 2014 - 0.1.0. Release.

local modOptions = Spring.GetModOptions()
if (gadgetHandler:IsSyncedCode()) then

local getMovetype = Spring.Utilities.getMovetype
  
VFS.Include("LuaRules/Configs/CAI/accessory/targetReachableTester.lua")

local spGetGroundHeight			= Spring.GetGroundHeight
local spGetUnitPosition			= Spring.GetUnitPosition
local spGetTeamInfo			= Spring.GetTeamInfo
local spGetFeaturePosition		= Spring.GetFeaturePosition
local spCreateUnit			= Spring.CreateUnit
local spGetUnitDefID			= Spring.GetUnitDefID
local GaiaTeamID			= Spring.GetGaiaTeamID()
local spGetUnitTeam			= Spring.GetUnitTeam
local spGetAllUnits			= Spring.GetAllUnits
local spGetGameFrame			= Spring.GetGameFrame
local spGetAllFeatures			= Spring.GetAllFeatures
local spGiveOrderToUnit			= Spring.GiveOrderToUnit
local spGetCommandQueue			= Spring.GetCommandQueue
local spDestroyFeature			= Spring.DestroyFeature
local spGetFeatureResurrect		= Spring.GetFeatureResurrect
local spGetUnitIsDead	  		= Spring.GetUnitIsDead
local spGiveOrderArrayToUnitArray	= Spring.GiveOrderArrayToUnitArray
local spGetUnitsInCylinder		= Spring.GetUnitsInCylinder

local waterLevel = modOptions.waterlevel and tonumber(modOptions.waterlevel) or 0
local GaiaAllyTeamID					= select(6,spGetTeamInfo(GaiaTeamID))

local random = math.random

local mapWidth
local mapHeight

local zombies_to_spawn = {}
local zombies = {}

local ZOMBIES_REZ_MIN = tonumber(modOptions.zombies_delay)
if (tonumber(ZOMBIES_REZ_MIN)==nil) then ZOMBIES_REZ_MIN = 3 end -- minimum of 3 seconds, max is determined by rez speed
local ZOMBIES_REZ_SPEED = tonumber(modOptions.zombies_rezspeed)
if (tonumber(ZOMBIES_REZ_SPEED)==nil) then ZOMBIES_REZ_SPEED = 25 end -- 25m/s, big units have a really long time to respawn

local CMD_REPEAT = CMD.REPEAT
local CMD_MOVE_STATE = CMD.MOVE_STATE
local CMD_INSERT = CMD.INSERT
local CMD_FIGHT = CMD.FIGHT
local CMD_OPT_SHIFT = CMD.OPT_SHIFT
local CMD_GUARD = CMD.GUARD

local function CheckZombieOrders(unitID)	-- i can't rely on Idle because if for example unit is unloaded it doesnt count as idle... weird
	for unitID, _ in pairs(zombies) do
		local cQueue = spGetCommandQueue(unitID, 1)
		if not(cQueue) or not(#cQueue > 0) then -- oh
			BringingDownTheHeavens(unitID)
		end
	end
end

local function disSQ(x1,y1,x2,y2)
	return (x1 - x2)^2 + (y1 - y2)^2
end

local function GetUnitNearestAlly(unitID, range)
	local best_ally
	local best_dist
	local x,y,z = spGetUnitPosition(unitID)
	local units = spGetUnitsInCylinder(x,z,range)
	for i=1, #units do
		local allyID = units[i]
		local allyTeam = spGetUnitTeam(allyID)
		local allyDefID = spGetUnitDefID(allyID)
		if (allyID ~= unitID) and (allyTeam == GaiaTeamID) and (getMovetype(UnitDefs[allyDefID]) ~= false) then
			local ox,oy,oz = spGetUnitPosition(allyID)
			local dist = disSQ(x,z,ox,oz)
			if IsTargetReallyReachable(unitID, ox, oy, oz, x, y, z) and ((best_dist == nil) or (dist < best_dist)) then
				best_ally = allyID
				best_dist = dist
			end
		end
	end
	return best_ally
end

-- in halloween gadget, sometimes giving order to unit would result in crash because unit happened to be dead at the time order was given
-- TODO probably same units in groups could get same orders...
local function BringingDownTheHeavens(unitID)
	if (spGetUnitIsDead(unitID) == false) then
		local rx,rz,ry
		local orders = {}
		local unitDefID = spGetUnitDefID(unitID)
		local near_ally
		if (UnitDefs[unitDefID].canAttack) then
			near_ally = GetUnitNearestAlly(unitID, 300)
			if (near_ally) then
				local cQueue = spGetCommandQueue(near_ally, 1)
				if cQueue and (#cQueue > 0) and cQueue[1].id == CMD_GUARD then -- oh
					near_ally = nil -- i dont want chain guards...
				end
			end
		end
		local x,y,z = spGetUnitPosition(unitID)
		if (near_ally) and random(0,5)<4 then -- 60% chance to guard nearest ally
			orders[#orders+1] =  { CMD_GUARD, {near_ally}, {} }
		end
		for i=1,random(10,30) do
			rx = random(0,mapWidth)
			rz = random(0,mapHeight)
			ry = spGetGroundHeight(rx,rz)
			if IsTargetReallyReachable(unitID, rx, ry, rz, x, y, z) then
				orders[#orders+1] = { CMD_FIGHT, {rx,ry,rz}, CMD_OPT_SHIFT }
			end
		end
		if (#orders > 0) then
			if (spGetUnitIsDead(unitID) == false) then
				spGiveOrderArrayToUnitArray({unitID},orders)
-- 			else
-- 				zombies[unitID] = nil
			end
		end
-- 	else
-- 		zombies[unitID] = nil
	end
end

function gadget:GameFrame(f)
	if (f%32)==0 then
		for id, time_to_spawn in pairs(zombies_to_spawn) do
			if time_to_spawn <= f then
				zombies_to_spawn[id] = nil
				local resName,face=spGetFeatureResurrect(id)
				local x,y,z=spGetFeaturePosition(id)
				spDestroyFeature(id)
				local unitID=spCreateUnit(resName,x,y,z,face,GaiaTeamID)
				if (unitID) then
					spGiveOrderToUnit(unitID,CMD_REPEAT,{1},{})
					spGiveOrderToUnit(unitID,CMD_MOVE_STATE,{2},{})
					BringingDownTheHeavens(unitID)
					zombies[unitID] = true
				end
			end
		end
	end
	if (f%96)==1 then
		CheckZombieOrders()
	end
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam)
	if zombies[unitID] then
		zombies[unitID] = nil
	end
end

function gadget:UnitTaken(unitID, unitDefID, teamID, newTeamID)
	if zombies[unitID] and newTeamID~=GaiaTeamID then
		zombies[unitID] = nil
	elseif newTeamID==GaiaTeamID then
		spGiveOrderToUnit(unitID,CMD_REPEAT,{1},{})
		spGiveOrderToUnit(unitID,CMD_MOVE_STATE,{2},{})
		BringingDownTheHeavens(unitID)
		zombies[unitID] = true
	end
end

function gadget:FeatureCreated(featureID, allyTeam)
	local resName, face = spGetFeatureResurrect(featureID)
	if resName and face then
		if UnitDefNames[resName] then
			local rez_time = UnitDefNames[resName].metalCost / ZOMBIES_REZ_SPEED
			if (rez_time < ZOMBIES_REZ_MIN) then
				  rez_time = ZOMBIES_REZ_MIN
			end
-- 			Spring.Echo("will respawn "..resName.." in "..rez_time.." seconds")
			zombies_to_spawn[featureID] = spGetGameFrame()+(rez_time*32)
		end
	end
end

function gadget:FeatureDestroyed(featureID, allyTeam)
	if (zombies_to_spawn[featureID]) then
		zombies_to_spawn[featureID]=nil
	end
end

local function ReInit(reinit)
	mapWidth = Game.mapSizeX
	mapHeight = Game.mapSizeZ
	if (reinit) then
		local units = spGetAllUnits()
		for i=1,#units do
			local unitID = units[i]
			local unitTeam = spGetUnitTeam(unitID)
			if (unitTeam == GaiaTeamID) then
				spGiveOrderToUnit(unitID,CMD_REPEAT,{1},{})
				spGiveOrderToUnit(unitID,CMD_MOVE_STATE,{2},{})
				BringingDownTheHeavens(unitID)
				zombies[unitID] = true
			end
		end
		local features = spGetAllFeatures()
		for i=1,#features do
			gadget:FeatureCreated(features[i], 1) -- doesnt matter who is owner of feature
		end
	end
end
		
function gadget:Initialize()
	if not (tonumber(modOptions.zombies) == 1) then
		gadgetHandler:RemoveGadget()
		return
	end
	if (spGetGameFrame() > 1) then
		ReInit(true)
	end
end

function gadget:GameStart()
	if (tonumber(modOptions.zombies) == 1) then
		ReInit(false)
	end
end

end