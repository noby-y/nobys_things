dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local enemies = EntityGetInRadiusWithTag( x, y, 200, "enemy" )

if ( #enemies > 0 ) then
	for _,enemy_id in ipairs(enemies) do
		local ex, ey = EntityGetTransform( enemy_id )
		
		local dist = math.abs( x - ex ) + math.abs( y - ey )
		
		if ( dist < 300 ) and ( EntityHasTag( enemy_id, "boss" ) == false ) and ( EntityHasTag( enemy_id, "this_is_sampo" ) == false ) then
			EntityLoad( "data/entities/particles/destruction.xml", ex, ey )
			EntityLoad( "data/entities/misc/explosion_was_here.xml", ex, ey )
			EntityKill( enemy_id )
		end
	end
end

EntityKill( entity_id )
