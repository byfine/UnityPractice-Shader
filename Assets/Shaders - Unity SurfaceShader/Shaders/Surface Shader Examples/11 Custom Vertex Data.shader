Shader "Surface Shaders Examples/11 Custom Vertex Data" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
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
            // 自定义的颜色变量
            float3 customColor;
		};

		sampler2D _MainTex;
        
        // 输出一个Input类型的变量 o
        void vert (inout appdata_full v, out Input o) {
            // #define UNITY_INITIALIZE_OUTPUT(type,name) name = (type)0;
            // UNITY_INITIALIZE_OUTPUT: 将o清空并转成Input类型。因为o目前是我们自定义的，所以需要强制转换。
            UNITY_INITIALIZE_OUTPUT(Input, o);
            o.customColor = abs(v.normal);
        }
        
		void surf (Input IN, inout SurfaceOutput o) {
			// tex2D根据贴图和纹理坐标计算出贴图颜色，再与为颜色参数相乘	
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
            o.Albedo *= IN.customColor;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
