Shader "Custom/Vertex/8 diffuse" {

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
				fixed4 color : COLOR;
			};

			v2f vert(appdata_base v){				
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

				// 法线标准化
				float3 N = normalize(v.normal);
				// 平行光标准化
				float3 L = normalize(_WorldSpaceLightPos0);

				// 把物体空间的法向量变换到世界坐标系
				// 对于非等比例缩放，需要用物体到世界矩阵的逆矩阵的转置矩阵乘以向量
				// 于是等效于下面的计算
				N = mul(float4(N, 0), _World2Object).xyz;

				// 求点积并限制在0-1范围
				float ndotl = saturate(dot(N, L));

				// 计算平行光颜色
				o.color = _LightColor0 * ndotl;

				// 顶点世界坐标
				float3 worldPos = mul(_Object2World, v.vertex).xyz;

				// 计算其他4个点光源颜色
				o.color.rbg += Shade4PointLights(unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
												unity_LightColor[0].rbg, unity_LightColor[1].rbg, 
												unity_LightColor[2].rbg, unity_LightColor[3].rbg,
												unity_4LightAtten0,
												worldPos, N);

				return o;
			}

			fixed4 frag(v2f IN):COLOR{
				return IN.color + UNITY_LIGHTMODEL_AMBIENT;
			}

			ENDCG
		}
	}
}
