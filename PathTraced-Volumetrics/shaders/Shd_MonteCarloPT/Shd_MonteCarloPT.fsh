varying vec2 in_TexelCoord;
uniform sampler2D emissivity;
uniform sampler2D absorption;
uniform sampler2D noise;
uniform vec2 worldExt;
uniform float rayCount;

#define LINEAR(c) vec4(pow(c.rgb, vec3(2.2)), c.a)
#define SRGB(c) vec4(pow(c.rgb, vec3(1.0 / 2.2)), 1.0)
#define RADIANS(n) ((n) * 6.283185)

vec4 trace(vec2 rxy, vec2 dxy, vec2 adxy) {
	const float stepSize = 2.0;
	vec3 radiance = vec3(0.0), transmit = vec3(1.0);
	vec2 delta = dxy / mix(adxy.x, adxy.y, step(adxy.x, adxy.y));
	for(float ii = 0.0; ii < max(worldExt.x, worldExt.y); ii += stepSize) {
		vec2 ray = (rxy + (delta * ii)) / worldExt;
		if (floor(ray) != vec2(0.0)) break;
		vec3 emiss = texture2D(emissivity, ray).rgb;
		vec3 absrp = texture2D(absorption, ray).rgb;
		radiance += transmit * emiss * stepSize;
		transmit *= exp(-absrp * stepSize);
	}
	return vec4(radiance, 1.0);
}

void main() {
	for(float i = 0.0; i < rayCount; i += 1.0) {
	    float bluenoise = texture2D(noise, in_TexelCoord).r;
		float theta = RADIANS((i + bluenoise) / rayCount);
		vec2 delta = vec2(cos(theta), -sin(theta)) * length(worldExt);
		vec2 origin = in_TexelCoord * worldExt;
		gl_FragColor += LINEAR(trace(origin, delta, abs(delta)));
	}
	gl_FragColor = SRGB(vec4(gl_FragColor / rayCount));
}

/*
	Emissivity:
		Additive Color Blending
	
	Absorption:
		Subtractive Color Blending
*/
