Shader "Surface Shaders Examples/04 Rim" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex("Texture", 2D) = "white" {}
		_BumpMap("Bumpmap", 2D) = "bump" {}
		_RimColor("Rim Color", Color) = (0.2, 0.2, 0.2, 0.0)
		_RimPower("Rim Power", Range(0.5,8.0)) = 3.0
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
			//输入法线贴图纹理坐标
			float2 uv_BumpMap;
			//输入观察向量
			float3 viewDir;
		};

		float4 _Color;
		sampler2D _MainTex;
		sampler2D _BumpMap;
		float4 _RimColor;
		float _RimPower;

		void surf (Input IN, inout SurfaceOutput o) {
			// tex2D根据贴图和纹理坐标计算出贴图颜色，再与为颜色参数相乘	
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			// UnpackNormal接受一个fixed4的输入，然后计算出法线值。输入的是法线贴图采样的值。
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));

			// 计算出观察方向与顶点法线的角度(Cos值)，将其限制在0 - 1范围。
			half angle = saturate(dot(normalize(IN.viewDir), o.Normal));
			// 视角与法线夹角越小，边缘光越暗。而cos值与角度大小成反比，所以用1减。
			half rim = 1.0 - angle;
			// 将rim值求RimPower次幂，然后赋值给自发光输出变量Emission
			// 注意，rim是小于1的，所以RimPower值越大，边缘光的范围越小，反之亦然。
			o.Emission = _RimColor.rgb * pow(rim, _RimPower);
		}
		ENDCG
	}
	FallBack "Diffuse"
}
