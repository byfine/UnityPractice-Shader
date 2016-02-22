Shader "Custom/Vertex/5 vertex warp" {

	properties{
		_Angle("angle", range(-1, 1)) = 1
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

				// ---------- 旋转扭曲 -----------

				// 旋转角度为顶点距离中心的距离
				float angle = length(v.vertex) * _Angle;

				// 构造旋转矩阵
				// 注：使用矩阵消耗较大
				/*float4x4 m = {
					float4(cos(angle), 0, sin(angle), 1),
					float4(0, 1, 0, 0),
					float4(-sin(angle), 0, cos(angle), 1),
					float4(0, 0, 0, 1)
				};
				v.vertex = mul(m, v.vertex);*/

				// 优化方法，直接展开矩阵乘法
				float x = cos(angle) * v.vertex.x + sin(angle) * v.vertex.z;
				float z = -sin(angle) * v.vertex.x + cos(angle) * v.vertex.z;
				v.vertex.x = x;
				v.vertex.z = z;

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
