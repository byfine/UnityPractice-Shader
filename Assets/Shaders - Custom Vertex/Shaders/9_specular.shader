Shader "Custom/Vertex/9 specular" {

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

				// Ambient color
				o.color = UNITY_LIGHTMODEL_AMBIENT;

				// Diffuse color
				float3 N = UnityObjectToWorldNormal(v.normal);	// 法线世界坐标
				float3 L = normalize(WorldSpaceLightDir(v.vertex));	 // 灯光方向
				float ndotl = saturate(dot(N, L));			
				o.color += _LightColor0 * ndotl;

				// specular color
				float3 I = -WorldSpaceLightDir(v.vertex);	// 光到顶点方向
				float3 R = reflect(I, N);	// 反射向量
				float3 V = WorldSpaceViewDir(v.vertex);	// 视线方向
				R = normalize(R);
				V = normalize(V);

				float specularScale = pow(saturate(dot(R, V)), _Shininess);	// 高光系数
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
