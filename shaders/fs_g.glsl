precision highp float;
 
varying vec3 fsPosition;            // Position vector received from VS
varying vec3 fsNormal;              // Normal vector received from VS
varying vec2 fsLMapUV;              // UV Position vector for diffuse texture received from VS
varying vec2 fsDiffUV;
 
uniform vec3 eyePosition;           // Position of the camera in the space coordinates system chosen
 
        // Material
uniform vec4 mDiffColor;            // Material's diffuse color
uniform vec4 mSpecColor;            // Material's specular color;
uniform float mSpecPower;           // Material's specular color power factor
 
        // Lights
uniform vec4 lightColor;            // Color of the lights
uniform vec3 lightPosition;         // Lights source position vector
uniform vec3 spotLightDirection;    // Constant incident spot light ray direction  
uniform float spotLightCosin;       // Spot light cos-in parameter
uniform float spotLightCosout;      // Spot light cos-out parameter
 
        // Textures
uniform sampler2D lMapTexture;     	   // Light Map texture
uniform float hasLightMap;             // Light Map texture intensity: 0---->non present , 1---->effective
 
void main(void)
{
    vec3 nNormal = normalize(fsNormal);                 // Normalized normal
    vec3 nEyeDirection = normalize(eyePosition - fsPosition);
    vec4 lightMapInfluence = texture2D(lMapTexture, fsDiffUV) * hasLightMap + mDiffColor * (1.0 - hasLightMap);

			 
    // Light model
	vec4 diffuse, specular;           
    vec3 nLightDirection;
	for(int i = 0; i < 3; i++){
		float spotLightCosin = 0.7;
		float spotLightCosout = 0.5;
	
		nLightDirection = normalize(lightPosition - fsPosition);   // Direction of the light source wrt the current position, normalized
		float lightDecay;
		float lightCone = - dot(nLightDirection, normalize(spotLightDirection));
		if(lightCone < spotLightCosout){
			lightDecay = 0.0;}
		else if (lightCone > spotLightCosin){
			lightDecay = 1.0;}
		else{
			lightDecay = (lightCone - spotLightCosout) / (spotLightCosin - spotLightCosout);}
	 
		// Diffuse component
		diffuse += lightMapInfluence * lightColor * lightDecay * (max(dot(nNormal, - normalize(spotLightDirection)), 0.0));
	 
		// Specular component         
		vec3 refl = - reflect(-normalize(spotLightDirection), nNormal); // Reflection vector
		specular += mSpecColor * lightColor * lightDecay * pow(max(dot(refl, nEyeDirection), 0.0), mSpecPower);
	}
 
    gl_FragColor = min(diffuse + specular, vec4(1,1,1,1));
}