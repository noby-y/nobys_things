dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()  

local comp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
if comp == nil then return end

ComponentSetValue2( comp, "gravity_x", 0)
ComponentSetValue2( comp, "gravity_y", 0)

-- ComponentSetValue2( comp, "mGravity", gravity_x, gravity_y)

