Shader "Custom/Vertex/10 blinn-phong" {

	properties{
		_SpecularColor("Specular Color", color) = (1, 1, 1, 1)
		_Shininess("Shininess", range(1, 64)) = 16
	}

	SubShader {
		pass{
			tags{ "LightMode" = "ForwardBase"}
			
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag 
			#include "unitycg.cginc"
			#include "lighting.cginc"

			fixed4 _SpecularColor;
			float _Shininess;

			struct v2f {
				float4 pos : POSITION;
				fixed4 color : COLOR;
			};

			v2f vert(appdata_base v){				
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

				float3 N = UnityObjectToWorldNormal(v.normal);		// 法线世界方向
				float3 L = normalize(WorldSpaceLightDir(v.vertex));	// 光线方向
				float3 V = normalize(WorldSpaceViewDir(v.vertex));	// 视线方向

				// Ambient color
				o.color = UNITY_LIGHTMODEL_AMBIENT;

				// Diffuse color
				float ndotl = saturate(dot(N, L));			
				o.color += _LightColor0 * ndotl;

				// specular color
				float3 H = normalize(L + V);	//半角向量
				float specularScale = pow(saturate(dot(H, N)), _Shininess);	// 高光系数
				o.color += _SpecularColor * specularScale;	// 高光颜色

				return o;
			}

			fixed4 frag(v2f IN):COLOR{
				return IN.color;
			}

			ENDCG
		}
	}
}
