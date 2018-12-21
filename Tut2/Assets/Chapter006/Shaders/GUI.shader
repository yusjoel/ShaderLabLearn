Shader "CookbookShaders/Chapter006/GUI"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo (RGB)", 2D) = "white" { }
        _TransparencyValue ("Transparency Value", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Tags 
        { 
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
        }
        LOD 200
        
        CGPROGRAM
        
        #pragma surface surf GUI alpha novertexlights

        float4 _Color;
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
            o.Alpha = c.a * _TransparencyValue;
        }

        inline fixed4 LightingGUI(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
        {
            fixed4 c;
            c.rgb = s.Albedo;
            c.a = s.Alpha;
            return c;
        }
        
        ENDCG
        
    }

    FallBack "Diffuse"
}
