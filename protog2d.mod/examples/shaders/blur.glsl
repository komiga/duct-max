//@fragment
vec2 blurscale = vec2(2.0, 2.0);

//float blurfactors[15] = float[15](0.0044, 0.0115, 0.0257, 0.0488, 0.0799, 0.1133, 0.1394, 0.1494, 0.1394, 0.1133, 0.0799, 0.0488, 0.0257, 0.0115, 0.0044);
float blurfactors[15] = float[15]
	(0.0044, 0.0115,
	0.0257, 0.0488,
	0.0799, 0.1133,
	0.1394,
	0.1494,			// Center
	0.1394,
	0.1133, 0.0799,
	0.0488, 0.0257,
	0.0115, 0.0044);

void main() {
	vec4 color = vec4(0.0);
	for(int i = 0; i < 15; ++i) {
		vec2 tc = min(gl_TexCoord[0].st + blurscale * float(i - 7), p2d_viewportsize);
		color += texture2DRect(p2d_rendertexture, tc) * blurfactors[i];
	}
	
	gl_FragColor = color;
}