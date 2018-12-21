Shader "CookbookShaders/Chapter006/Transparency"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" { }
        _TransparencyValue ("Transparency Value", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Tags { "Queue" = "Transparent" }
        LOD 200
        
        CGPROGRAM
        
        #pragma surface surf Lambert alpha

        sampler2D _MainTex;
        float _TransparencyValue;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.r * _TransparencyValue;
        }
        
        ENDCG
        
    }

    FallBack "Diffuse"
}
