attribute vec3 inPosition;          // Position vector received
attribute vec3 inNormal;            // Normal vector received
attribute vec2 inDiffUV;            // UV Position vector for diffuse texture received
 
varying vec3 fsPosition;        // Position vector for FS
varying vec3 fsNormal;          // Normal vector for FS
varying vec2 fsLMapUV;          // UV Position vector for light map texture for FS
varying vec2 fsDiffUV;
 
uniform mat4 wvpMatrix;     // World,View,Project Matrix for the vertices
uniform mat4 wMatrix;       // World matrix to transform vertices in world space
uniform mat3 nwMatrix;      // Matrix to transform normal vectors in world space
 
 
void main(void)
{
    //fsPosition = (wMatrix * vec4(inPosition, 1.0)).xyz;
    //fsNormal = nwMatrix * inNormal;
	fsNormal = inNormal; 
	fsPosition = inPosition;
    fsDiffUV = inDiffUV;        
 
    //gl_Position = wvpMatrix * vec4(inPosition, 1.0);
	gl_Position = wvpMatrix * vec4(inPosition, 1.0);
}