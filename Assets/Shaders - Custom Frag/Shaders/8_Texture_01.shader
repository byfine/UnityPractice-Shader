Shader "Custom/Frag/8 Texture 01" {
	properties{
		_MainTex("MainTex", 2D) = ""{}
	}
	
	SubShader {
		pass{	

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "unitycg.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct v2f {
				float4 pos : POSITION;
				float2 uv: TEXCOORD0;
			};

			v2f vert(appdata_base v){
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				//o.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

				return o;
			}

			fixed4 frag(v2f IN):COLOR{
				fixed4 color = tex2D(_MainTex, IN.uv);
				return color;
			}

			ENDCG
		}
	}
}
