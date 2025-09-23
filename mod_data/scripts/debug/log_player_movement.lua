dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()

local velocity_comp = EntityGetFirstComponent( entity_id, "VelocityComponent")
if velocity_comp == nil then return end
local vel_x,vel_y = ComponentGetValueVector2( velocity_comp, "mVelocity")

if math.abs(vel_x) >= 0.1 or math.abs(vel_y) >= 0.1 then 
    print("VELOCITY: vel_x = " .. vel_x .. ", vel_y = " .. vel_y)

    local frame_number
    local vsc = EntityGetComponent( entity_id, "VariableStorageComponent" )
    for i,comp in ipairs(vsc) do
        local name = ComponentGetValue( comp, "name" )
        
        if ( name == "frame_counter" ) then
            frame_number = ComponentGetValue2( comp, "value_int" )
            ComponentSetValue2( comp, "value_int", frame_number + 1 )
            break
        end
    end
    print("FRAME: " .. frame_number)

    local x, y = EntityGetTransform( entity_id )
    print("POSITION: pos_x = " .. x .. ", pos_y = " .. y)
else
    local vsc = EntityGetComponent( entity_id, "VariableStorageComponent" )
    for i,comp in ipairs(vsc) do
        local name = ComponentGetValue( comp, "name" )
        if ( name == "frame_counter" ) then
            ComponentSetValue2( comp, "value_int", 0)
            break
        end
    end
end
