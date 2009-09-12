//@fragment
uniform vec3 hue;

void main(void)
{
	gl_FragColor.rgb = texture2DRect(p2d_rendertexture, gl_TexCoord[0].st).rgb;
	//gl_FragColor.rgb = texture2DRect(tex, texcoord0).rgb;
	gl_FragColor.rgb += hue;
	gl_FragColor.a = 1.0;
}

