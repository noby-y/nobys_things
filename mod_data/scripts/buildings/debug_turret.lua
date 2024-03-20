dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
x, y = EntityGetTransform( entity_id )

local projectile_file
local vel_x = 0
local vel_y = 600

local variablestorages = EntityGetComponent( entity_id, "VariableStorageComponent" )

if ( variablestorages ~= nil ) then
	for j,storage_id in ipairs(variablestorages) do
		local var_name = ComponentGetValue2( storage_id, "name" )

		if ( var_name == "projectile_file" ) then
			projectile_file = ComponentGetValue2( storage_id, "value_string" )
			if #projectile_file == 0 then
				return
			end
		end

		if ( var_name == "vel_x" ) then
			vel_x = ComponentGetValue2( storage_id, "value_int" )
		end

		if ( var_name == "vel_y" ) then
			vel_y = ComponentGetValue2( storage_id, "value_int" )
		end
	end
end

shoot_projectile( entity_id, projectile_file, x, y + 4, vel_x, vel_y )