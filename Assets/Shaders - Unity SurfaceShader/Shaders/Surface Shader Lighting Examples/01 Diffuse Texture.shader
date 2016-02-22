Shader "Surface Shader Lighting Examples/01 Diffuse Texture" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// 使用自定义的光照模型
		#pragma surface surf SimpleLambert
		#pragma target 3.0

        // 自定义光照函数，以Lighting开头，名称为SimpleLambert。用于forward path，不依赖viewDir
        half4 LightingSimpleLambert (SurfaceOutput s, half3 lightDir, half atten) {
            // 计算光线与法线的夹角，求漫反射颜色
            half NdotL = dot (s.Normal, lightDir);
            half4 c;
            // atten是光照的衰减值
            c.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten);
            c.a = s.Alpha;
            return c;
        }
        
		struct Input {
			float2 uv_MainTex;
		};
        sampler2D _MainTex;        

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
