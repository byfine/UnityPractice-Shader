Shader "Custom/Frag/6 Frag Color" {
	properties{
		_MainColor("MainColor", color) = (1, 1, 1, 1)
		_SecondColor("SecondColor", color) = (1, 1, 1, 1)
		_Center("Center", range(-1, 1)) = 0
		_R("R", range(0, 0.5)) = 0.2
	}
	
	SubShader {
		pass{	

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "unitycg.cginc"

			fixed4 _MainColor;
			fixed4 _SecondColor;
			float _Center;
			float _R;

			struct v2f {
				float4 pos : POSITION;
				float y : POSITION1;
			};

			v2f vert(appdata_base v){
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.y = v.vertex.y;
				return o;
			}

			fixed4 frag(v2f IN):COLOR{


//				if(IN.y > _Center + _R){
//					return _MainColor;
//				}
//				else if(IN.y > _Center && IN.y < _Center + _R){
//					// 在 _Center + _R 位置，d 为 0
//					// 在 _Center 位置， d 为 0.5
//
//					float d = IN.y - _Center;
//					d = (1 - d / _R) - 0.5;
//					d = saturate(d);
//
//					// 根据d制造过渡效果
//					return lerp(_MainColor, _SecondColor, d);
//				}
//				else if(IN.y > _Center - _R && IN.y < _Center){
//					// 在 _Center 位置，d 为 0.5
//					// 在 _Center - _R 位置， d 为 0
//
//					float d = IN.y - _Center;
//					d = d / _R + 0.5;
//					d = saturate(d);
//
//					// 根据d制造过渡效果
//					return lerp(_SecondColor, _MainColor, d);
//				}
//				else{
//					return _SecondColor;
//				}
//			

				// 与中心的距离
				float d = IN.y - _Center;

				// 到中心的距离 与 融合半径的比率
				float f = d / _R;
							
				// f值为 0 到 1
				f = saturate(f / 2 + 0.5);

				return lerp(_MainColor, _SecondColor, f);
			}

			ENDCG
		}
	}
}
