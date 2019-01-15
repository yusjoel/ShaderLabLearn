Shader "CookbookShaders/Chapter009/Luminance"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}    
        _DesatValue ("Desaturate", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Tags 
        { 
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
        }
        LOD 200
        
        CGPROGRAM
        
        //#define HALF_LAMBERT
        #include "Lambert.cginc"
        #pragma surface surf CustomLambert

        sampler2D _MainTex;
        fixed _DesatValue;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            half4 c = tex2D(_MainTex, IN.uv_MainTex);

            // 内置的函数Luminance
            c.rgb = lerp(c.rgb, Luminance(c.rgb), _DesatValue);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        
        ENDCG
        
    }

    FallBack "Diffuse"
}
