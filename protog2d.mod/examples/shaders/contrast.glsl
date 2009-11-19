//@fragment
//uniform float alpha;		// 0.2
//uniform float lum;		// 0.1

const float alpha = 0.0;
const float lum = 0.1;

void main() {
	vec4 color = texture2DRect(p2d_rendertexture, gl_TexCoord[0].st);
	//color = mix(lum, color, alpha);
	gl_FragColor = lum * (1.0 - alpha) + color;
}