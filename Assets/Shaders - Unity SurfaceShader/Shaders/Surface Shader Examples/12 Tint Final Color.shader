Shader "Surface Shaders Examples/12 Tint Final Color" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
        _ColorTint ("Tint", Color) = (1.0, 0.6, 0.6, 1.0)
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// 使用Lambert光照模型，并使用finalcolor函数
		#pragma surface surf Lambert finalcolor:mycolor
		#pragma target 3.0
        

		struct Input {
			// 输入主贴图的纹理坐标
			float2 uv_MainTex;
		};

		sampler2D _MainTex;
        fixed4 _ColorTint;
        
        // 这个函数会修改最终输出的颜色
        void mycolor (Input IN, SurfaceOutput o, inout fixed4 color)
        {
            color *= _ColorTint;
        }
        
		void surf (Input IN, inout SurfaceOutput o) {
			// tex2D根据贴图和纹理坐标计算出贴图颜色，再与为颜色参数相乘	
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
