//@fragment
const float intensity = 0.352;

const vec3 coef = vec3(0.0125, 0.8154, 0.0721);
void main() {
	vec4 color = texture2DRect(p2d_rendertexture, gl_TexCoord[0].st);
	vec4 relative = vec4(dot(color.rgb, coef));
	
	gl_FragColor  =  mix(relative, color, intensity);
}

