Shader "Surface Shaders Examples/08 WorldRelf Normalmap" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex("Texture", 2D) = "white" {}
        _BumpMap ("Bumpmap", 2D) = "bump" {}
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
            // 法线贴图的纹理坐标
            float2 uv_BumpMap;
            // 输入世界反射坐标
			float3 worldRefl;
            // 内部数据，可以获得经过法线贴图修改后的法线信息
            INTERNAL_DATA
		};

		fixed4 _Color;
		sampler2D _MainTex;
        sampler2D _BumpMap;
        samplerCUBE _Cube;

		void surf (Input IN, inout SurfaceOutput o) {
			// tex2D根据贴图和纹理坐标计算出贴图颜色，再与为颜色参数相乘	
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex) * _Color * 0.5;
            // UnpackNormal接受一个fixed4的输入，然后计算出法线值。输入的是法线贴图采样的值。
            o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
            
            // 使用WorldReflectionVector 获得修改后的反射向量
            o.Emission = texCUBE (_Cube, WorldReflectionVector (IN, o.Normal)).rgb; 
		}
		ENDCG
	}
	FallBack "Diffuse"
}
