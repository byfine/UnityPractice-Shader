Shader "Surface Shaders Examples/07 WorldRelf" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex("Texture", 2D) = "white" {}
		_Cube("Cubemap", CUBE) = "" {}
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// 使用Lambert光照模型
		#pragma surface surf Lambert
		#pragma target 3.0
        

		struct Input {
			// 输入主贴图的纹理坐标
			float2 uv_MainTex;
            // 输入世界反射坐标
			float3 worldRefl;
		};

		fixed4 _Color;
		sampler2D _MainTex;
        samplerCUBE _Cube;

		void surf (Input IN, inout SurfaceOutput o) {
			// tex2D根据贴图和纹理坐标计算出贴图颜色，再与为颜色参数相乘	
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex) * _Color;

            o.Emission = texCUBE(_Cube, IN.worldRefl).rgb;     
		}
		ENDCG
	}
	FallBack "Diffuse"
}
