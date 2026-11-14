// Heavily inspired from: https://www.youtube.com/watch?v=ib2atnKTLrs
shader_type spatial;
render_mode unshaded, fog_disabled, depth_test_disabled, depth_draw_never, cull_disabled;

uniform sampler2D depth_texture : hint_depth_texture, filter_nearest;
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform vec3 water_primary_color : source_color = vec3(0.0, 0.0, 1.0);
uniform vec3 water_secondary_color : source_color = vec3(0.0, 0.0, 1.0);
uniform float depth_distance : hint_range(0.0, 100.0, 0.1) = 20.0;
uniform float beers_law : hint_range(0.0, 20.0, 0.1) = 1.0;
uniform float water_transparency : hint_range(0.0, 1.0, 0.01) = 0.05;
uniform float basic_fresnel : hint_range(0.0, 1.0, 0.01) = 0.0;

void vertex() {
    POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
    float depth = texture(depth_texture, SCREEN_UV).x;

    // please see <https://docs.godotengine.org/en/stable/tutorials/shaders/advanced_postprocessing.html#depth-texture>
    #if CURRENT_RENDERER == RENDERER_COMPATIBILITY
    vec3 ndc = vec3(SCREEN_UV, depth) * 2.0 - 1.0;
    #else
    vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
    #endif

    vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
    view.xyz /= view.w;
    float linear_depth = -view.z;

    float depth_blend = exp(-beers_law * clamp(linear_depth / depth_distance, 0.0, 1.0));
    
    vec3 depth_color = mix(water_secondary_color, water_primary_color, depth_blend);
    vec3 scene_color = texture(screen_texture, SCREEN_UV).rgb;
    vec3 final_color = mix(depth_color, scene_color, water_transparency);
    
    ALBEDO = mix(final_color, scene_color, depth_blend * (1.0 - basic_fresnel));
}
