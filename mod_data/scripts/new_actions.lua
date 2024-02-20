local function table_insert_all (new_actions)
	for i,v in ipairs(new_actions) do
		table.insert (actions, v)
	end
end

local new_actions = {
	{
		id          = "FOLLOW_CURSOR",
		name 		= "Cursor following",
		description = "Makes a projectile follow your crosshair",
		sprite 		= "mods/nobys_things/mod_data/images/ui_gfx/cursor_follow.png",
		sprite_unidentified = "data/images/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "mods/nobys_things/mod_data/entities/cursor_follow.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5,6", -- HOMING
		spawn_probability                 = "0.1,0.4,0.4,0.4,0.4,0.4", -- HOMING
		price = 220,
		mana = 40,
		action 		= function()
			c.extra_entities = c.extra_entities .. "mods/nobys_things/mod_data/entities/misc/cursor_follow.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "HOMING_CURSOR_REAL",
		name 		= "Cursor homing",
		description = "Makes a projectile accelerate towards your crosshair",
		sprite 		= "mods/nobys_things/mod_data/images/ui_gfx/cursor_homing.png",
		sprite_unidentified = "data/images/ui_gfx/gun_actions/sinewave_unidentified.png",
		related_extra_entities = { "mods/nobys_things/mod_data/entities/cursor_homing.xml" },
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "1,2,3,4,5,6", -- HOMING
		spawn_probability                 = "0.1,0.4,0.4,0.4,0.4,0.4", -- HOMING
		price = 220,
		mana = 60,
		action 		= function()
			c.extra_entities = c.extra_entities .. "mods/nobys_things/mod_data/entities/misc/cursor_homing.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "DRAW_EAT",
		name 		= "Eat 1 draw",
		description = "Takes 1 place in a multicast but self-discards",
		sprite 		= "mods/nobys_things/mod_data/images/ui_gfx/eat_draw.png",
		sprite_unidentified = "data/images/ui_gfx/gun_actions/i_shape_unidentified.png",
		type 		= ACTION_TYPE_OTHER,
		spawn_level                       = "10", -- I_SHAPE
		spawn_probability                 = "0.3", -- I_SHAPE
		price = 30,
		mana = 0,
		--max_uses = 100,
		action = function()
			local data = hand[#hand]
			if (#hand > 0) and (data.id == "DRAW_EAT") then
				table.insert( discarded, data )
				table.remove( hand, #hand )
			end
		end,
	},
	{
		id          = "GRAVITY_DISABLE",
		name 		= "Disable gravity",
		description = "Makes projectile unaffected by gravity",
		sprite 		= "mods/nobys_things/mod_data/images/ui_gfx/gravity_disable.png",
		sprite_unidentified = "data/images/ui_gfx/gun_actions/i_shape_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "2,3,4,5,6,10", -- GRAVITY_ANTI
		spawn_probability                 = "0.5,0.4,0.4,0.3,0.3,0.3", -- GRAVITY_ANTI
		price = 30,
		mana = 10,
		--max_uses = 100,
		action = function()
			c.gravity = 0
			c.extra_entities = c.extra_entities .. "mods/nobys_things/mod_data/entities/misc/gravity_disable.xml,"
			draw_actions( 1, true )
		end,
	},
	{
		id          = "INFINITE_LIFETIME",
		name 		= "$action_lifetime_infinite",
		description = "Makes projectile last forever",
		sprite 		= "data/images/ui_gfx/gun_actions/lifetime_infinite.png",
		sprite_unidentified = "data/images/ui_gfx/gun_actions/spread_reduce_unidentified.png",
		type 		= ACTION_TYPE_MODIFIER,
		spawn_level                       = "6,10", -- LIFETIME
		spawn_probability                 = "0.1,0.1", -- LIFETIME
		price = 350,
		mana = 120,
		max_uses = 3,
		custom_xml_file = "data/entities/misc/custom_cards/lifetime_infinite.xml",
		action 		= function()
			c.extra_entities = c.extra_entities .. "mods/nobys_things/mod_data/entities/misc/infinite_lifetime.xml,"
			c.fire_rate_wait = c.fire_rate_wait + 13
			draw_actions( 1, true )
		end,
	},
}

table_insert_all(new_actions)