Shader "Custom/Frag/5 Rim Outline 2" {
	properties{
		_Color("Color", color) = (1, 1, 1, 1)
		_Scale("Scale", range(1, 8)) = 2
		_Outer("Outer", range(0, 1)) = 0.2
	}
	
	SubShader {
		tags { "quene" = "transparent" }

		//=============== pass 1 : 渲染由内到外的发光的效果 ==================
		pass{	
			
			blend SrcAlpha OneMinusSrcAlpha 
			zwrite off

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "unitycg.cginc"

			fixed4 _Color;
			float _Scale;
			float _Outer;

			struct v2f {
				float4 pos : POSITION;
				float4 vertex : POSITION1;
				float3 normal : NORMAL;
			};

			v2f vert(appdata_base v){
				//在法线方向扩展
				v.vertex.xyz += v.normal * _Outer;
						
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.vertex = v.vertex;
				o.normal = v.normal;

				return o;
			}

			fixed4 frag(v2f IN):COLOR{

				float3 N = UnityObjectToWorldNormal(IN.normal);
				float3 V = normalize(WorldSpaceViewDir(IN.vertex));

				float bright = saturate(dot(N, V));
				bright = pow(bright, _Scale);

				_Color.a *= bright;
				return _Color;
			}

			ENDCG
		}
		// ==================== pass 2: 减去物体轮廓 ======================
		pass{	
			blendop RevSub
			blend DstAlpha One 
			zwrite off

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "unitycg.cginc"

			struct v2f {
				float4 pos : POSITION;
			};

			v2f vert(appdata_base v){
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

				return o;
			}

			fixed4 frag(v2f IN):COLOR{
				return fixed4(1,1,1,1);
			}

			ENDCG
		}


		// ====================pass3: 绘制内部由外到内的发光==========================
		pass{	
			blend SrcAlpha OneMinusSrcAlpha 
			zwrite off

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "unitycg.cginc"

			fixed4 _Color;
			float _Scale;

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

				float bright = 1.0 - saturate(dot(N, V));
				bright = pow(bright, _Scale);

				return _Color * bright;
			}

			ENDCG
		}
	}
}
