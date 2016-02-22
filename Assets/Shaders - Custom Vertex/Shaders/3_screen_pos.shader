Shader "Custom/Vertex/3 screen pos" {

	SubShader {
		pass{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "unitycg.cginc"

			float dis;
			float r;
			
			struct v2f {
				float4 pos : POSITION;
				fixed4 color : COLOR;
			};

			v2f vert(appdata_base v){
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				
				// 进行透视除法，获得屏幕坐标
				float x = o.pos.x / o.pos.w;
				
				// 简单对边界进行检测
				/*if (x <= -1) {
					o.color = fixed4(1, 0, 0, 1);
				}
				else if (x >= 1) {
					o.color = fixed4(0, 0, 1, 1);
				}
				else {
					float c = x / 2 + 0.5;
					o.color = fixed4(c, c, c, 1);
				}*/

				// 对一个范围带进行检测
				if (x > dis && x < dis + r)
				{
					o.color = fixed4(1, 0, 0, 1);
				}
				else {
					float c = x / 2 + 0.5;
					o.color = fixed4(c, c, c, 1);
				}

				return o;
			}

			fixed4 frag(v2f IN):COLOR{
				return IN.color;
			}

			ENDCG
		}
	}
}
