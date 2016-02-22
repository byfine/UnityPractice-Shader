Shader "Surface Shaders Examples/06 Detail ScreenPos" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex("Texture", 2D) = "white" {}
		_DetailRatioX("_Detail Ratio X", Float) = 16
		_DetailRatioY("_Detail Ratio Y", Float) = 9
		_Detail("Detail", 2D) = "gray" {}
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// 使用Lambert光照模型
		#pragma surface surf Lambert
		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		struct Input {
			// 输入主贴图的纹理坐标
			float2 uv_MainTex;
			// 输入屏幕空间坐标，来计算细节贴图的纹理坐标
			float4 screenPos;
		};

		float4 _Color;
		sampler2D _MainTex;
		sampler2D _Detail;
		float _DetailRatioX;
		float _DetailRatioY;

		void surf (Input IN, inout SurfaceOutput o) {
			// tex2D根据贴图和纹理坐标计算出贴图颜色，再与为颜色参数相乘	
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex) * _Color;

			// 根据屏幕坐标计算细节贴图纹理坐标
			float2 screenUV = IN.screenPos.xy / IN.screenPos.w;
			screenUV *= float2(_DetailRatioX, _DetailRatioY);
			
			// 应用纹理贴图
			o.Albedo *= tex2D(_Detail, screenUV).rgb * 2;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
