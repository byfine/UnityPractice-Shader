Shader "Custom/Vertex/1 mvp" {

	SubShader {
		pass{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "unitycg.cginc"
            
            float4x4 mvp; //mvp矩阵
            float4x4 rotMatrix; //旋转矩阵
            float4x4 scaleMatrix; //缩放矩阵

			float4x4 m;

			struct v2f {
				float4 pos:POSITION;
			};

			v2f vert(appdata_base v){
				v2f o;

				// 使用系统提供的mvp矩阵
				float4x4 mvpMatrix = UNITY_MATRIX_MVP;
				// 使用自定义的mvp矩阵，在C#脚本中传入
				//float4x4 mvpMatrix = mvp;
                
				// 应用旋转矩阵
				m = mul(mvpMatrix, rotMatrix);	
				// 应用缩放矩阵
				m = mul(m, scaleMatrix);

                o.pos = mul(m, v.vertex);

				return o;
			}

			fixed4 frag():COLOR{
				return fixed4(1, 1, 1, 1);
			}

			ENDCG
		}
	}
}
