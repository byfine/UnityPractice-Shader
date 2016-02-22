Shader "Custom/Vertex/4 vertex move" {
	properties{
		_R("R", range(0, 5)) = 3
		_Height("Height", range(0, 3)) = 1
		_CenterX("Center X", range(-5, 5)) = 0
		_CenterZ("Center Z", range(-5, 5)) = 0
	}

	SubShader {
		pass{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "unitycg.cginc"

			float _R;
			float _Height;
			float _CenterX;
			float _CenterZ;

			struct v2f {
				float4 pos : POSITION;
				fixed4 color : COLOR;
			};

			v2f vert(appdata_base v){
				// 获取世界坐标
				float4 worldPos = mul(_Object2World, v.vertex);

				// 获取顶点在xz平面坐标
				float2 xy = worldPos.xz;
				// 中心点坐标
				float2 center = float2(_CenterX, _CenterZ);

				// 计算顶点到中心点的距离
				float d = length(xy - center);
				d = _R - d;
				d = d < 0 ? 0 : d;

				// 根据距离中心的位置抬升顶点
				float4 upPos = float4(v.vertex.x, _Height * d, v.vertex.z, v.vertex.w);

				v2f o;
				//应用移动后的顶点
				o.pos = mul(UNITY_MATRIX_MVP, upPos);

				o.color = fixed4(upPos.y, upPos.y, upPos.y, 1);
				return o;
			}

			fixed4 frag(v2f IN):COLOR{
				return IN.color;
			}

			ENDCG
		}
	}
}
