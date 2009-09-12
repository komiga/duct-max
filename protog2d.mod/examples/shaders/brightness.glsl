//@fragment
//uniform float bright;

const float bright = 0.2;

void main() {
	gl_FragColor =  texture2DRect(p2d_rendertexture,gl_TexCoord[0].st) * bright;
}

