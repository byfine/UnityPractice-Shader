Shader "Custom/Frag/3 shadow cast" {
	properties{
		_MainColor("Main Color", color) = (1,1,1,1)
		_SpecularColor("Specular Color", color) = (1, 1, 1, 1)
		_Shininess("Shininess", range(1, 64)) = 16
	}

	SubShader {

//		pass{
//			tags{ "LightMode" = "shadowcaster" }
//		}

		pass{
			tags{ "LightMode" = "ForwardBase" }
			
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "unitycg.cginc"
			#include "lighting.cginc"

			fixed4 _MainColor;
			fixed4 _SpecularColor;
			float _Shininess;

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
				col += _MainColor * _LightColor0 * diffuseScale;

				// Specular color
				float3 V = normalize(WorldSpaceViewDir(IN.vertex));

				float3 R = 2 * dot(N, L) * N - L;
				float specularScale = saturate(dot(R, V));

				col += _SpecularColor * pow(specularScale, _Shininess);

				float3 worldPos = mul(_World2Object, IN.vertex);

				// 计算4个点光源颜色
				col.rbg += Shade4PointLights(
								unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
								unity_LightColor[0].rbg, unity_LightColor[1].rbg, 
								unity_LightColor[2].rbg, unity_LightColor[3].rbg,
								unity_4LightAtten0,
								worldPos, N);

				return col;
			}

			ENDCG
		}
	}

	fallback "Diffuse"
}
