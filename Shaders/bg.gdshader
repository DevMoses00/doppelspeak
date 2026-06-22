shader_type canvas_item;

/* ---------- Sway (subtle UV wobble) ---------- */
uniform float sway_amp      : hint_range(0.0, 0.05)  = 0.010; // 0.0–0.05
uniform float sway_freq     : hint_range(0.1, 4.0)   = 0.8;    // waves per sprite
uniform float sway_speed    : hint_range(0.0, 3.0)   = 0.25;

/* ---------- Glimmer band (soft moving highlight) ---------- */
uniform float glimmer_amp   : hint_range(0.0, 0.4)   = 0.10;   // brightness add
uniform float glimmer_width : hint_range(0.02, 0.5)  = 0.20;   // band softness
uniform float glimmer_speed : hint_range(0.0, 3.0)   = 0.35;
uniform float glimmer_angle_deg = 35.0;                         // band direction (°)

/* ---------- Micro-sparkle (very subtle shimmer) ---------- */
uniform bool  sparkle_enable = true;
uniform float sparkle_amp    : hint_range(0.0, 0.2)  = 0.04;   // 0 to disable effect
uniform float sparkle_scale  : hint_range(2.0, 40.0) = 14.0;   // granularity
uniform float sparkle_speed  : hint_range(0.0, 5.0)  = 0.60;

/* ---------- Overall controls ---------- */
uniform float master_intensity : hint_range(0.0, 1.0) = 1.0;   // fade whole effect

/* tiny hash noise (cheap) */
float hash21(vec2 p){
    p = fract(p * vec2(123.34, 345.45));
    p += dot(p, p + 34.345);
    return fract(p.x * p.y);
}

void fragment(){
    // Normalized UV and centered coords
    vec2 uv = UV;
    vec2 center = vec2(0.5);

    // --------- Sway (UV distortion before sampling) ---------
    float t = TIME * sway_speed;
    // two-axis sine warp; very small amplitude to keep it subtle
    vec2 sway = vec2(
        sin((uv.y + t) * 6.2831 * sway_freq),
        cos((uv.x - t*0.85) * 6.2831 * (sway_freq * 0.9))
    ) * sway_amp;

    vec2 uv_sway = uv + sway;

    // Avoid sampling outside (if your texture tiles, you can use fract())
    uv_sway = clamp(uv_sway, 0.001, 0.999);

    vec4 col = texture(TEXTURE, uv_sway);

    // --------- Glimmer band (soft diagonal sweep) ----------
    float ang = radians(glimmer_angle_deg);
    vec2 n = normalize(vec2(cos(ang), sin(ang)));
    // Signed distance along the band direction, animated
    float band = dot(uv - center, n) - glimmer_speed * TIME;
    // Wrap into [-0.5, 0.5] so the band cycles
    band = fract(band + 0.5) - 0.5;
    float glow = smoothstep(glimmer_width, 0.0, abs(band)); // peak at band center
    float glimmer = glow * glimmer_amp;

    // --------- Micro sparkle (noise-based twinkle) ----------
    float sparkle = 0.0;
    if (sparkle_enable && sparkle_amp > 0.0){
        // scrolling hash UV to avoid static grain
        vec2 suv = uv * sparkle_scale + vec2(TIME * 0.17, TIME * sparkle_speed);
        float n1 = hash21(suv);
        // keep it very infrequent and soft
        float s = smoothstep(0.98, 1.0, n1); // thresholded highlight
        sparkle = s * sparkle_amp;
    }

    // --------- Compose result ----------
    float boost = (glimmer + sparkle) * master_intensity;
    col.rgb += boost;                         // additive sheen looks nicer on colorful bgs

    COLOR = col;
}
