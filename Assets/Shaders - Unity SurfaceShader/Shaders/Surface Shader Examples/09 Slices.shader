Shader "Surface Shaders Examples/09 Slices" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
        _BumpMap ("Bumpmap", 2D) = "bump" {}
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
            // 法线贴图的纹理坐标
            float2 uv_BumpMap;
            // 输入世界坐标
			float3 worldPos;
		};

		sampler2D _MainTex;
        sampler2D _BumpMap;
            
		void surf (Input IN, inout SurfaceOutput o) {
            // clip(x) 函数，如果x的值小于0，则抛弃当前像素
            // frac(x) 函数，取x的小数部分            
            clip (frac((IN.worldPos.y + IN.worldPos.z * 0.1) * 2) - 0.5);
            
            
			// tex2D根据贴图和纹理坐标计算出贴图颜色，再与为颜色参数相乘	
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
            // UnpackNormal接受一个fixed4的输入，然后计算出法线值。输入的是法线贴图采样的值。
            o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
		}
		ENDCG
	}
	FallBack "Diffuse"
}
