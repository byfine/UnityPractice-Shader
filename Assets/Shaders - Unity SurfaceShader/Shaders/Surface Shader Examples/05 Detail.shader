Shader "Surface Shaders Examples/05 Detail Texture" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex("Texture", 2D) = "white" {}
		_BumpMap("Bumpmap", 2D) = "bump" {}
		_DetailPower("Detail Power", Range(1.0, 3.0)) = 2.0
		_Detail("Detail", 2D) = "gray" {}
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// 使用Lambert光照模型
		#pragma surface surf Lambert
		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		struct Input {
			//输入主贴图的纹理坐标
			float2 uv_MainTex;
			//输入法线贴图的纹理坐标
			float2 uv_BumpMap;
			//输入细节贴图的纹理坐标
			float2 uv_Detail;
		};

		float4 _Color;
		sampler2D _MainTex;
		sampler2D _BumpMap;
		float _DetailPower;
		sampler2D _Detail;

		void surf (Input IN, inout SurfaceOutput o) {
			// tex2D根据贴图和纹理坐标计算出贴图颜色，再与为颜色参数相乘	
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex) * _Color;

			// 再计算细节贴图
			o.Albedo *= tex2D(_Detail, IN.uv_Detail).rgb * _DetailPower;

			// UnpackNormal接受一个fixed4的输入，然后计算出法线值。输入的是法线贴图采样的值。
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));			
		}
		ENDCG
	}
	FallBack "Diffuse"
}
