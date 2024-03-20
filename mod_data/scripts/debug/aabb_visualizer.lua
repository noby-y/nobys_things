function visualize_entity(entity_id)
	--* Component types:
	--* 	"HitboxComponent",
	--* 	"AreaDamageComponent",
	--* 	"CharacterDataComponent",
	--* 	"CollisionTriggerComponent",
	--* 	"MaterialAreaCheckerComponent",
	
	local comps = EntityGetAllComponents(entity_id)
	local comp_type
	
	if ( comps ~= nil ) then
		for i,comp in ipairs( comps ) do
			comp_type = ComponentGetTypeName(comp)
			
			local alpha = ComponentGetIsEnabled(comp) and 0.6 or 0.2
			local color = "blue"
			--* Colors:
			--*		"blue"
			--*		"cyan"
			--*		"green"
			--*		"pink"
			--*		"red"
			--*		"yellow"
			
			local aabb = {}
			if comp_type == "HitboxComponent" then
				color = "green"
				aabb.min_x = ComponentGetValue2(comp, "aabb_min_x")
				aabb.min_y = ComponentGetValue2(comp, "aabb_min_y")
				aabb.max_x = ComponentGetValue2(comp, "aabb_max_x") - 1
				aabb.max_y = ComponentGetValue2(comp, "aabb_max_y") - 1
			elseif comp_type == "AreaDamageComponent" then
				color = "red"
				aabb.min_x, aabb.min_y = ComponentGetValue2(comp, "aabb_min")
				aabb.max_x, aabb.max_y = ComponentGetValue2(comp, "aabb_max")
				--? AreaDamageComponent scale is weird aff, not accurate at all
				--? 	aabb.min_x = aabb.min_x / 3
				--? 	aabb.min_y = aabb.min_y / 3
				--? 	aabb.max_x = aabb.max_x / 3
				--? 	aabb.max_y = aabb.max_y / 3
			elseif comp_type == "MaterialAreaCheckerComponent" then
				color = "cyan"
				aabb.min_x, aabb.min_y, aabb.max_x, aabb.max_y = ComponentGetValue2(comp, "area_aabb")
			elseif comp_type == "CharacterDataComponent" then
				color = "pink"
				aabb.min_x = ComponentGetValue2(comp, "collision_aabb_min_x")
				aabb.min_y = ComponentGetValue2(comp, "collision_aabb_min_y")
				aabb.max_x = ComponentGetValue2(comp, "collision_aabb_max_x")
				aabb.max_y = ComponentGetValue2(comp, "collision_aabb_max_y")
			elseif comp_type == "CollisionTriggerComponent" then
				color = "yellow"
				local width = ComponentGetValue2(comp, "width")
				local height = ComponentGetValue2(comp, "height")
				aabb.min_x, aabb.min_y = -width / 2, -height / 2
				aabb.max_x, aabb.max_y = width / 2, height / 2
			else
				goto circle_comp_check
			end

			local image_path = "mods/nobys_things/mod_data/images/debug_gfx/" .. color .. ".png"
			create_visualizer(entity_id, comp_type)
			visualize_rectangle(visualizer_entity, aabb, image_path, alpha)
			goto skip_comp
			
			::circle_comp_check::
			
			local circles = {
				"CellEaterComponent",
				"WormAttractorComponent",
				"BlackHoleComponent",
				"DamageNearbyEntitiesComponent",
				"GameAreaEffectComponent",
				"InteractableComponent",
				"LightComponent",
				"LiquidDisplacerComponent",
				"MagicConvertMaterialComponent",
				"MagicXRayComponent",
				"CollisionTriggerComponent",
				"ElectricityReceiverComponent",
				"ElectricitySourceComponent",
				"TelekinesisComponent",
			}
			for i,circle in ipairs(circles) do
				if comp_type == circle then
					aabb.radius = ComponentGetValue2(comp, "radius")
				end
			end
			if comp_type == "AreaDamageComponent" then
				aabb.radius = ComponentGetValue2(comp, "circle_radius")
			else
				goto skip_comp
			end
			
			-- local image_path = "mods/nobys_things/mod_data/images/debug_gfx/" .. color .. ".png"
			create_visualizer(entity_id, comp_type)
			visualize_circle(visualizer_entity, aabb.radius)

			::skip_comp::
		end
	end
end


function create_visualizer(entity_id, comp_type)
	local visualizer_entity = EntityCreateNew("aabb_visualizer: " .. comp_type)
	-- local x, y, rot = EntityGetTransform(entity_id)
	-- EntitySetTransform(visualizer_entity, x, y, rot)
	EntityAddTag(visualizer_entity, "aabb_visualizer")
	print("visualizer_entity = " .. visualizer_entity)
	EntityAddComponent2(visualizer_entity, "InheritTransformComponent", {
		rotate_based_on_x_scale = false
	})
	EntityAddChild(entity_id, visualizer_entity)
end

function visualize_rectangle(visualizer_entity, aabb, image_path, alpha)
	local width = aabb.max_x - aabb.min_x - 1
	local height = aabb.max_y - aabb.min_y + 1

	-- * HORIZONTAL LINE TOP
	EntityAddComponent2(visualizer_entity, "SpriteComponent", {
		image_file = image_path,
		special_scale_x = width,
		special_scale_y = 1,
		offset_x = -(aabb.min_x + 1) / width,
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
		offset_x = -(aabb.min_x + 1) / width,
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
end	
	
function visualize_circle(visualizer_entity, radius)
	EntityAddComponent2(visualizer_entity, "ParticleEmitterComponent", {
		area_circle_radius.min = radius,
		area_circle_radius.max = radius,
		color = 1,
	})
end


print("Dofile works!")