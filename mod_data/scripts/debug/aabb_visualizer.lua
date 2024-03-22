

function visualize_entity(entity_id)
	--* Rect Component types:
	--* 	"HitboxComponent",
	--* 	"AreaDamageComponent",
	--* 	"CharacterDataComponent",
	--* 	"CollisionTriggerComponent",
	--* 	"MaterialAreaCheckerComponent",
	local color = {}
	color.rect = "blue"
	--* Colors:
	--*		"red"
	--*		"green"
	--*		"blue"
	--*		"yellow"
	--*		"purple"
	--*		"cyan"
	
	local comps = EntityGetAllComponents(entity_id)
	local comp_type
	
	if ( comps ~= nil ) then
		for i,comp in ipairs( comps ) do
			comp_type = ComponentGetTypeName(comp)
			local aabb = {}
			local skip_visualizer = false
			local alpha = ComponentGetIsEnabled(comp) and 0.6 or 0.2
			
			--* SQUARES
			
			if comp_type == "HitboxComponent" then
				color.rect= "green"
				aabb.min_x = ComponentGetValue2(comp, "aabb_min_x")
				aabb.min_y = ComponentGetValue2(comp, "aabb_min_y")
				aabb.max_x = ComponentGetValue2(comp, "aabb_max_x") - 1
				aabb.max_y = ComponentGetValue2(comp, "aabb_max_y") - 1
			elseif comp_type == "AreaDamageComponent" then
				color.rect= "red"
				aabb.min_x, aabb.min_y = ComponentGetValue2(comp, "aabb_min")
				aabb.max_x, aabb.max_y = ComponentGetValue2(comp, "aabb_max")
				--? AreaDamageComponent scale is weird aff, not accurate at all
				--? 	aabb.min_x = aabb.min_x / 3
				--? 	aabb.min_y = aabb.min_y / 3
				--? 	aabb.max_x = aabb.max_x / 3
				--? 	aabb.max_y = aabb.max_y / 3
			elseif comp_type == "MaterialAreaCheckerComponent" then
				color.rect= "cyan"
				aabb.min_x, aabb.min_y, aabb.max_x, aabb.max_y = ComponentGetValue2(comp, "area_aabb")
			elseif comp_type == "CharacterDataComponent" then
				color.rect= "purple"
				aabb.min_x = ComponentGetValue2(comp, "collision_aabb_min_x")
				aabb.min_y = ComponentGetValue2(comp, "collision_aabb_min_y")
				aabb.max_x = ComponentGetValue2(comp, "collision_aabb_max_x")
				aabb.max_y = ComponentGetValue2(comp, "collision_aabb_max_y")
			elseif comp_type == "CollisionTriggerComponent" then
				color.rect= "yellow"
				local width = ComponentGetValue2(comp, "width")
				local height = ComponentGetValue2(comp, "height")
				aabb.min_x, aabb.min_y = -width / 2, -height / 2
				aabb.max_x, aabb.max_y = width / 2, height / 2
			else
				skip_visualizer = true
			end

			if not skip_visualizer then
				create_visualizer(entity_id, comp_type)
				visualize_rectangle(visualizer_entity, aabb, color, alpha)
				goto next_comp
			end
			
			--* CIRCLES
			
			skip_visualizer = false

			if comp_type == "AreaDamageComponent" then
				aabb.radius = ComponentGetValue2(comp, "circle_radius")
			else
				skip_visualizer = true
			end

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
					skip_visualizer = false
				end
			end
			
			if not skip_visualizer then
				color.R = 255
				color.G = 0
				color.B = 108
				create_visualizer(entity_id, comp_type)
				visualize_circle(visualizer_entity, aabb.radius, color, alpha)	
			end

			::next_comp::
		end
	end
end


function create_visualizer(entity_id, comp_type)
	visualizer_entity = EntityCreateNew("aabb_visualizer: " .. comp_type)
	-- local x, y, rot = EntityGetTransform(entity_id)
	-- EntitySetTransform(visualizer_entity, x, y, rot)
	EntityAddTag(visualizer_entity, "aabb_visualizer")
	EntityAddComponent2(visualizer_entity, "InheritTransformComponent", {
		rotate_based_on_x_scale = false
	})
	EntityAddChild(entity_id, visualizer_entity)
end

function visualize_rectangle(visualizer_entity, aabb, color, alpha)
	local width = aabb.max_x - aabb.min_x - 1
	local height = aabb.max_y - aabb.min_y + 1

	local image_path = "mods/nobys_things/mod_data/images/debug_gfx/" .. color.rect.. ".png"

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
	
function visualize_circle(visualizer_entity, radius, color, alpha)
	local colorInt = color.R + color.G*256 + color.B*256^2 + 255*256^3

	local comp = EntityAddComponent2(visualizer_entity, "ParticleEmitterComponent", {
		is_emitting = true,
		emitted_material_name = "spark",
		emit_cosmetic_particles = true,
		collide_with_grid = false,
		collide_with_gas_and_fire = false,
		cosmetic_force_create = true,
		custom_alpha = alpha,
		color = colorInt,
		lifetime_min = 0.001,
		lifetime_max = 0.001,
		x_vel_min = 0,
		x_vel_max = 0,
		y_vel_min = 0,
		y_vel_max = 0,
		count_min = math.min( math.ceil(40 * radius), 20000),
		count_max = math.min( math.ceil(40 * radius), 20000),
		emission_interval_min_frames = 1,
		emission_interval_max_frames = 1,
	})
	ComponentSetValue2(comp, "area_circle_radius", radius, radius)
	ComponentSetValue2(comp, "gravity", 0, 0)
end