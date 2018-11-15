Shader "CookbookShaders/Chapter001/BRDFDiffuse"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" { }
        _RampTex ("Ramp" ,2D) = "white" { }
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200
        
        CGPROGRAM
        
        #pragma surface surf BRDFDiffuse

        sampler2D _MainTex;
        sampler2D _RampTex;

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

        inline float4 LightingBRDFDiffuse(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
        {
            float difLight = dot(s.Normal, lightDir);
            float hLambert = difLight * 0.5 + 0.5;
            float rimLight = dot(s.Normal, viewDir);
            float3 ramp = tex2D(_RampTex, float2(hLambert, rimLight)).rgb;

            float4 col;
            col.rgb = s.Albedo * _LightColor0.rgb * ramp;
            col.a = s.Alpha;
            return col;
        }

        ENDCG
        
    }
    
    FallBack "Diffuse"
}
