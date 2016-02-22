Shader "Surface Shaders Examples/13 Fog via Final Color" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _FogColor ("Fog Color", Color) = (0.3, 0.4, 0.7, 1.0)
    }

    SubShader {
        Tags { "RenderType" = "Opaque" }
        CGPROGRAM
        
        // 使用Lambert光照模型，并使用finalcolor函数 和 顶点函数
        #pragma surface surf Lambert finalcolor:mycolor vertex:myvert
        
        struct Input {
            float2 uv_MainTex;
            // 自定义变量
            half fog;
        };
        
        fixed4 _FogColor;
        sampler2D _MainTex;
        
        // 顶点函数，根据顶点坐标计算fog值
        void myvert (inout appdata_full v, out Input data)
        {
            // 转换输出o为Input类型
            UNITY_INITIALIZE_OUTPUT(Input,data);
            // UNITY_MATRIX_MVP是model、view、projection三个矩阵相乘得出的4x4矩阵
            // 这个矩阵再乘以顶点坐标，就是最终剪裁空间顶点坐标（剪裁后即屏幕空间坐标）
            float4 hpos = mul (UNITY_MATRIX_MVP, v.vertex);
            hpos.xy /= hpos.w;
            // 这里同一个向量点乘等于求平方，使其有扩散效果
            // hpos.xy值越大，约靠近屏幕边缘（xy除以w后是小于等于1的）
            data.fog = min (1, dot (hpos.xy, hpos.xy) * 0.5);
        }
                
        // 最终颜色修改
        void mycolor (Input IN, SurfaceOutput o, inout fixed4 color)
        {
            fixed3 fogColor = _FogColor.rgb;
            #ifdef UNITY_PASS_FORWARDADD
                fogColor = 0;
            #endif
            // 根据fog值，在原来颜色和雾的颜色间插值
            color.rgb = lerp (color.rgb, fogColor, IN.fog);
        }
        
        
        void surf (Input IN, inout SurfaceOutput o) {
            o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG
    } 
    Fallback "Diffuse"
}