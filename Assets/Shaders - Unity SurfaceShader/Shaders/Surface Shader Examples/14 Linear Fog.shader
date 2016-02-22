Shader "Surface Shaders Examples/14 Linear Fog" {
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}  
    }
    
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
            
        // 使用Lambert光照模型，并使用finalcolor函数 和 顶点函数
        #pragma surface surf Lambert finalcolor:mycolor vertex:myvert
        #pragma multi_compile_fog

        struct Input {
            float2 uv_MainTex;
            // 自定义变量
            half fog;
        };

        sampler2D _MainTex;
        // 使用RenderSettings设置这两个值 
        uniform half4 unity_FogStart;
        uniform half4 unity_FogEnd;
        
        // 顶点函数，根据顶点坐标计算fog值
        void myvert (inout appdata_full v, out Input data) {
            // 转换输出o为Input类型
            UNITY_INITIALIZE_OUTPUT(Input,data);
            // model、view矩阵乘以顶点位置，没有乘以投影矩阵，
            // 即直接求出在空间位置中的向量模长，根据这个值求线性fog值。
            float pos = length(mul (UNITY_MATRIX_MV, v.vertex).xyz);
            float diff = unity_FogEnd.x - unity_FogStart.x;
            float invDiff = 1.0f / diff;
            // pos距离越远，fog值越小
            data.fog = clamp ((unity_FogEnd.x - pos) * invDiff, 0.0, 1.0);
        }
        
        
        void mycolor (Input IN, SurfaceOutput o, inout fixed4 color) {
            #ifdef UNITY_PASS_FORWARDADD
                UNITY_APPLY_FOG_COLOR(IN.fog, color, float4(0,0,0,0));
            #else
            UNITY_APPLY_FOG_COLOR(IN.fog, color, unity_FogColor);
            #endif
        }

        void surf (Input IN, inout SurfaceOutput o) {
            half4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    } 
    FallBack "Diffuse"
}