dofile_once("data/scripts/lib/utilities.lua")

local range = 200
local steering_strength = 0.2 -- how much to lerp towards target (0...1)
local scatter = 0.1 -- how much the velocity direction is randomized. radians

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetFirstHitboxCenter( entity_id )

-- get shooter
local comp = EntityGetFirstComponent( entity_id, "ProjectileComponent" )
if comp == nil then return end
local who_shot = ComponentGetValue2( comp, "mWhoShot")


local cursor_x, cursor_y = DEBUG_GetMouseWorld()

-- check los
--if RaytraceSurfacesAndLiquiform(pos_x, pos_y, cursor_x, cursor_y) then return end

-- direction
local dir_x, dir_y = vec_sub(cursor_x, cursor_y, pos_x, pos_y)
dir_x,dir_y = vec_normalize(dir_x, dir_y)

-- get velocity and rotate it to align with ray
local vel_x,vel_y = GameGetVelocityCompVelocity(entity_id)
if vel_x == nil then return end
local speed = get_magnitude(vel_x, vel_y)

-- lerp direction and restore speed
vel_x,vel_y = vec_normalize(vel_x, vel_y)
vel_x = lerp(dir_x, vel_x, steering_strength)
vel_y = lerp(dir_y, vel_y, steering_strength)
vel_x,vel_y = vec_normalize(vel_x, vel_y)
vel_x = vel_x * speed
vel_y = vel_y * speed

-- scatter
SetRandomSeed(pos_x + GameGetFrameNum(), pos_y)
vel_x,vel_y = vec_rotate(vel_x,vel_y, rand(-scatter, scatter))

-- set velocity
comp = EntityGetFirstComponent( entity_id, "VelocityComponent" )
ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y)

-- FX
EntitySetComponentsWithTagEnabled( entity_id, "autoaim_fx", true )
