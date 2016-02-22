Shader "Custom/Frag/4 Rim Outline" {
	properties{
		_Color("Color", color) = (1, 1, 1, 1)
		_RimColor("RimColor", color) = (1, 1, 1, 1)
		_Scale("Scale", range(1, 8)) = 2
	}
	
	SubShader {
		tags { "quene" = "transparent" }

		pass{	
			
			blend SrcAlpha OneMinusSrcAlpha 

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "unitycg.cginc"

			float _Scale;
			fixed4 _Color;
			fixed4 _RimColor;

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

				float3 N = UnityObjectToWorldNormal(IN.normal);
				float3 V = normalize(WorldSpaceViewDir(IN.vertex));

				fixed4 col;

				// 当点越趋近于边缘，该点法线与视线方向夹角越区域90度（即点乘0），从而使其最亮
				float brightRim = 1 - saturate(dot(N, V));
				// 控制衰减速度
				brightRim = pow(brightRim, _Scale);

				// 内部亮度
				float brightInside = 1 - brightRim;

				_Color *= brightInside;
				_RimColor *= brightRim;
				return _Color + _RimColor;
			}

			ENDCG
		}
	}
}
