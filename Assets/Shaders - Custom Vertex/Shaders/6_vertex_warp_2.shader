Shader "Custom/Vertex/6 vertex warp 2" {

	properties{
		_Angle("angle", range(2, 16)) = 8
	}

	SubShader {
		pass{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "unitycg.cginc"

			float _Angle;

			struct v2f {
				float4 pos : POSITION;
				fixed4 color : COLOR;
			};

			v2f vert(appdata_base v){				

				// ----------- 缩放扭曲 -------------

				float angle = v.vertex.z + _Time.y;

				// 构造x轴缩放矩阵
				/*float4x4 m = {
					float4(sin(angle) / 8 + 0.5, 0, 0, 0),
					float4(0, 1, 0, 0),
					float4(0, 0, 1, 0),
					float4(0, 0, 0, 1)
				};
				v.vertex = mul(m, v.vertex);*/

				// 优化方法，展开矩阵乘法
				float x = (sin(angle) / _Angle + 0.5) * v.vertex.x;
				v.vertex.x = x;

				v2f o;				
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.color = fixed4(0, 1, 1, 1);
				return o;
			}

			fixed4 frag(v2f IN):COLOR{
				return IN.color;
			}

			ENDCG
		}
	}
}
