Shader "Surface Shader Lighting Examples/02 Diffuse Wrap" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// 使用自定义的光照模型
		#pragma surface surf WrapLambert
		#pragma target 3.0

        // 自定义光照函数，以Lighting开头，名称为WrapLambert。用于forward path，不依赖viewDir
        half4 LightingWrapLambert (SurfaceOutput s, half3 lightDir, half atten) {
            // 计算光线与法线的夹角余弦，求漫反射颜色。夹角越小，值越大。
            half NdotL = dot (s.Normal, lightDir);
            // 将结果都转换到[0,1]范围，可以保证光线和平面夹角大于90度（即余弦值小于0）时也可以有颜色。
            half diff = NdotL * 0.5 + 0.5;
            half4 c;
            // atten是光照的衰减值
            c.rgb = s.Albedo * _LightColor0.rgb * (diff * atten);
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
