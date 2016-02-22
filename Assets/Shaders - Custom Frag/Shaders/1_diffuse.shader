Shader "Custom/Frag/1 diffuse" {

	SubShader {
		pass{
			tags{ "LightMode" = "ForwardBase"}
			
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "unitycg.cginc"
			#include "lighting.cginc"

			struct v2f {
				float4 pos : POSITION;
				float4 vertex : POSITION1;
				float3 normal : NORMAL;
			};

			v2f vert(appdata_base v){				
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.vertex = v.vertex;
				o.normal = v.normal;	

				return o;
			}

			fixed4 frag(v2f IN):COLOR{
				// Ambient color
				fixed4 col = UNITY_LIGHTMODEL_AMBIENT;

				// Diffuse color
				float3 N = UnityObjectToWorldNormal(IN.normal);
				float3 L = normalize(WorldSpaceLightDir(IN.vertex));

				float diffuseScale = saturate(dot(N, L));
				col += _LightColor0 * diffuseScale;

				  
				return col;
			}

			ENDCG
		}
	}
}
