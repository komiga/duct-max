//@vertex

// Note: Not used
void main()
{
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
	//gl_Position = gl_Vertex;
}

