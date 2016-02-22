Shader "Custom/Vertex/2 vertex color" {

	SubShader {
		pass{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "unitycg.cginc"

			struct v2f {
				float4 pos : POSITION;
				fixed4 color : COLOR;
			};

			v2f vert(appdata_base v){
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				
				// 判断物体自身坐标
				/*if (v.vertex.x > 0) {
					o.color = fixed4(1, 0, 0, 1);
				}
				else {
					o.color = fixed4(0, 0, 1, 1);
				}*/				
				

				// 获取物体世界坐标
				float4 worldPos = mul(_Object2World, v.vertex);
				// 根据物体世界坐标判断
				if (worldPos.x > 0) {
					o.color = fixed4(_SinTime.w / 2 + 0.5, _CosTime.w / 2 + 0.5, _SinTime.y / 2 + 0.5, 1);
				}
				else {
					o.color = fixed4(0, 0, 1, 1);
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
