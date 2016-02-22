Shader "Custom/Frag/7_FragColor_Surface" {
	Properties {
		_MainColor("MainColor", color) = (1, 1, 1, 1)
		_SecondColor("SecondColor", color) = (1, 1, 1, 1)
		_Center("Center", range(-1, 1)) = 0
		_R("R", range(0, 0.5)) = 0.2

		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows vertex:vert
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float y;
		};

		fixed4 _MainColor;
		fixed4 _SecondColor;
		float _Center;
		float _R;

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		void vert (inout appdata_full v, out Input o){
			UNITY_INITIALIZE_OUTPUT(Input, o);
            o.y = v.vertex.y;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;

			float d = IN.y - _Center;
			float f = d / _R;		
			f = saturate(f / 2 + 0.5);
			o.Albedo *=  lerp(_MainColor, _SecondColor, f);
		}
		ENDCG
	}
	FallBack "Diffuse"
}
