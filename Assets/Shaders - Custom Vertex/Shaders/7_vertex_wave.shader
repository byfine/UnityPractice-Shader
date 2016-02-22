Shader "Custom/Vertex/7 vertex wave" {

	properties{
		_Type("type", int) = 0
		_Height("height", range(0, 1)) = 0.5
		_Height2("height2", range(0, 1)) = 0.5
		_Freq("freq", range(-3, 3)) = 2
	}

	SubShader {
		pass{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "unitycg.cginc"

			float _Height;
			float _Height2;
			float _Freq;
			float _Type;

			struct v2f {
				float4 pos : POSITION;
				fixed4 color : COLOR;
			};

			v2f vert(appdata_base v){				
				// 简谐运动公式： A * sin(wt + φ)

				if (_Type == 0)
				{
					// 在x轴运动
					v.vertex.y += _Height * sin(v.vertex.x * _Freq + _Time.y);
				}
				else if (_Type == 1)
				{
					// 在z轴运动
					v.vertex.y += _Height * sin(v.vertex.z * _Freq + _Time.y);
				}
				else if (_Type == 2)
				{
					// xy同时
					v.vertex.y += _Height * sin((v.vertex.x + v.vertex.z) * _Freq + _Time.y);
				}
				else if (_Type == 3)
				{
					// 圆形波，根据点到圆心距离判断
					v.vertex.y += _Height * sin(length(v.vertex.xz) * _Freq + _Time.y);
				}		
				else if (_Type == 4)
				{
					// 两个正弦波
					v.vertex.y += _Height * sin((v.vertex.x + v.vertex.z) * _Freq + _Time.y);
					v.vertex.y += _Height2 * sin((v.vertex.x - v.vertex.z) * _Freq + _Time.w);
				}

				v2f o;				
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.color = fixed4(v.vertex.y, v.vertex.y, v.vertex.y, 1);
				return o;
			}

			fixed4 frag(v2f IN):COLOR{
				return IN.color;
			}

			ENDCG
		}
	}
}
