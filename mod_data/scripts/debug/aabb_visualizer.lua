function visualize_entity(entity_id)
	--* Component types:
	--* 	"HitboxComponent",
	--* 	"AreaDamageComponent",
	--* 	"CharacterDataComponent",
	--* 	"CollisionTriggerComponent",
	--* 	"MaterialAreaCheckerComponent",
	
	local comps = EntityGetAllComponents(entity_id)
	local comp_type
	
	
	local aabb = {}
	if ( comps ~= nil ) then
		for i,comp in ipairs( comps ) do
			comp_type = ComponentGetTypeName(comp)
			
			local alpha = ComponentGetIsEnabled(comp) and 0.5 or 0.2
			local color = "blue"
			--* Colors:
			-- "blue"
			-- "cyan"
			-- "green"
			-- "pink"
			-- "red"
			-- "yellow"
			
			local a, b, c, d = 0, 0, 0, 0
			if comp_type == "HitboxComponent" then
				color = "green"
				a = ComponentGetValue2(comp, "aabb_min_x")
				b = ComponentGetValue2(comp, "aabb_min_y")
				c = ComponentGetValue2(comp, "aabb_max_x")
				d = ComponentGetValue2(comp, "aabb_max_y")
			elseif comp_type == "AreaDamageComponent" then
				color = "red"
				a, b = ComponentGetValue2(comp, "aabb_min")
				c, d = ComponentGetValue2(comp, "aabb_max")
			elseif comp_type == "MaterialAreaCheckerComponent" then
				color = "cyan"
				a, b, c, d = ComponentGetValue2(comp, "area_aabb")
			elseif comp_type == "CharacterDataComponent" then
				color = "pink"
				a = ComponentGetValue2(comp, "collision_aabb_min_x")
				b = ComponentGetValue2(comp, "collision_aabb_min_y")
				c = ComponentGetValue2(comp, "collision_aabb_max_x")
				d = ComponentGetValue2(comp, "collision_aabb_max_y")
			elseif comp_type == "CollisionTriggerComponent" then
				color = "yellow"
				local width = ComponentGetValue2(comp, "width")
				local height = ComponentGetValue2(comp, "height")
				a, b = -width / 2, -height / 2
				c, d = width / 2, height / 2
			else
				goto skip_comp
			end
			
			aabb.min_x = a
			aabb.min_y = b
			aabb.max_x = c
			aabb.max_y = d
			local width = aabb.max_x - aabb.min_x
			local height = aabb.max_y - aabb.min_y

			local scale_x = width / 10
			local scale_y = height / 10
			
			local visualizer_entity = EntityCreateNew()
			-- local x, y, rot = EntityGetTransform(entity_id)
			-- EntitySetTransform(ent, x, y, rot)
			EntityAddComponent2(visualizer_entity, "InheritTransformComponent", {
				rotate_based_on_x_scale = true
			})
			EntityAddChild(entity_id, visualizer_entity)
			local image_path = "mods/nobys_things/mod_data/images/debug_gfx/" .. color .. ".png"

			-- * HORIZONTAL LINE TOP
			EntityAddComponent2(visualizer_entity, "SpriteComponent", {
				image_file = image_path,
				special_scale_x = width,
				special_scale_y = 1,
				offset_x = -aabb.min_x / width,
				offset_y = -aabb.min_y,
				has_special_scale = true,
				alpha = alpha,
				z_index = -99,
				smooth_filtering = true,
			})
		
			-- * HORIZONTAL LINE BOTTOM
			EntityAddComponent2(visualizer_entity, "SpriteComponent", {
				image_file = image_path,
				special_scale_x = width,
				special_scale_y = 1,
				offset_x = -aabb.min_x / width,
				offset_y = -aabb.max_y,
				has_special_scale = true,
				alpha = alpha,
				z_index = -99,
				smooth_filtering = true,
			})

			-- * VERTICAL LINE LEFT
			EntityAddComponent2(visualizer_entity, "SpriteComponent", {
				image_file = image_path,
				special_scale_x = 1,
				special_scale_y = height,
				offset_x = -aabb.min_x,
				offset_y = -aabb.min_y / height,
				has_special_scale = true,
				alpha = alpha,
				z_index = -99,
				smooth_filtering = true,
			})
		
			-- * VERTICAL LINE RIGHT
			EntityAddComponent2(visualizer_entity, "SpriteComponent", {
				image_file = image_path,
				special_scale_x = 1,
				special_scale_y = height,
				offset_x = -aabb.max_x,
				offset_y = -aabb.min_y / height,
				has_special_scale = true,
				alpha = alpha,
				z_index = -99,
				smooth_filtering = true,
			})

			::skip_comp::
		end
		
		-- local entity_id = GetUpdatedEntityID()
		-- visualize_aabb(entity_id)
	end
end

print("Hey, dofile works!")
	-- local component
	-- for i, t in ipairs(types) do
	-- 	component = EntityGetFirstComponent(entity_id, t)
	-- 	if component then
	-- 		comp_type = t
	-- 		break
	-- 	end
	-- end
	

