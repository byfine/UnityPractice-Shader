Shader "Surface Shaders Examples/10 Normal Extrusion" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
        _Amount ("Extrusion Amount", Range(-1,1)) = 0.5
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// 使用Lambert光照模型，并使用顶点函数
		#pragma surface surf Lambert vertex:vert
		#pragma target 3.0
        

		struct Input {
			// 输入主贴图的纹理坐标
			float2 uv_MainTex;
		};

		sampler2D _MainTex;
        float _Amount;
            
        
        void vert (inout appdata_full v) {
            // 沿法线移动顶点
            v.vertex.xyz += v.normal * _Amount;
        }
        
		void surf (Input IN, inout SurfaceOutput o) {
			// tex2D根据贴图和纹理坐标计算出贴图颜色，再与为颜色参数相乘	
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
