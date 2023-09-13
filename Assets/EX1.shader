Shader "Unlit/EX1"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			GLSLPROGRAM
			#include "UnityCG.glslinc"
			uniform vec4 _LightColor0;
			#ifdef VERTEX
				varying vec2 vUv;
				varying vec3 normal;
				varying vec4 color;
				varying vec4 vPosition;
			void main() {
				// cor da luz da unity _LightColor0
				// vetor da luz da unity _WorldSpaceLightPos0
				// projeção da camera gl_ProjectionMatrix
				// projeção do modelo gl_ModelViewMatrix

				float mov = sin(3.0 * _Time.w + gl_Vertex.z * 1.0) * .5;
				gl_Position = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
				normal = gl_Normal;
				vUv = gl_MultiTexCoord0.xy;
				color = gl_Color;
				gl_Position.y += mov;
			}

			#endif

			#ifdef FRAGMENT
				uniform sampler2D _MainTex;
				varying vec2 vUv;
				varying vec3 normal;
				varying vec4 color;
				varying vec4 vPosition;
			void main() {

				vec3 wnormal = normalize(
					vec3(vec4(normal, 0.0) * unity_WorldToObject));

				vec3 lightpos = normalize(
					vec3(_WorldSpaceLightPos0));

				float finalcolor = dot(wnormal, lightpos);

				if (vUv.y <= .3) {
					gl_FragColor = texture2D(_MainTex, vUv) * finalcolor * vec4(0.9, 0.5, 0, 1);
				}
				else if (vUv.y > .3 && vUv.y <= .6) {
					gl_FragColor = texture2D(_MainTex, vUv) * finalcolor * vec4(1, 1, 1, 1);
				}
				else {
					gl_FragColor = texture2D(_MainTex, vUv) * finalcolor * vec4(0.2, 0.7, 0.5, 1);
				}

			}
			#endif
			ENDGLSL
		}
	}
	
}