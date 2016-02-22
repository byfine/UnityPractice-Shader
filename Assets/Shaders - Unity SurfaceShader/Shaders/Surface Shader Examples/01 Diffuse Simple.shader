Shader "Surface Shaders Examples/01 Diffuse Simple" {

	Properties{
		_Color("Color", Color) = (1, 1, 1, 1)
	}

	SubShader {
		Tags { "RenderType"="Opaque" }

		CGPROGRAM
		// 使用Lambert光照模型
		#pragma surface surf Lambert
		#pragma target 3.0
	
		struct Input {
			//输入顶点颜色
			float4  color : COLOR;
		};

        float4 _Color;
		
		void surf (Input IN, inout SurfaceOutput o) {		
			o.Albedo = _Color;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
