Shader "CookbookShaders/Chapter001/HalfLambert"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" { }
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200
        
        CGPROGRAM
        
        #pragma surface surf HalfLambert

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        inline float4 LightingHalfLambert(SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            float difLight = dot(s.Normal, lightDir);
            float hLambert = difLight * 0.5 + 0.5;

            float4 col;
            col.rgb = s.Albedo * _LightColor0.rgb * (hLambert * atten);
            col.a = s.Alpha;
            return col;
        }

        ENDCG
        
    }
    
    FallBack "Diffuse"
}
