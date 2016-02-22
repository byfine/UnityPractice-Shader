Shader "Surface Shader Lighting Examples/04 Simple Specular" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
	}
    
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// 使用自定义的光照模型
		#pragma surface surf SimpleSpecular
		#pragma target 3.0

        
        // 自定义光照函数，以Lighting开头，名称为SimpleSpecular。用于forward path，依赖viewDir
        half4 LightingSimpleSpecular  (SurfaceOutput s, half3 lightDir, half3 viewDir, half atten) {
     
            // 求光线和法线余弦，计算漫反射
            half diff = max (0, dot (s.Normal, lightDir));
       
            // 求出halfwayDir，即视角与光线中间的方向，叫做半程向量
            half3 h = normalize (lightDir + viewDir);
            // 求半程向量和法线余弦
            float nh = max (0, dot (s.Normal, h));
            // 根据发光值求次幂
            float spec = pow (nh, 48.0);

            half4 c;
            // 漫反射颜色加反射颜色即最终颜色
            c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * spec) * atten;
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
