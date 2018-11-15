Shader "CookbookShaders/CustomDiffuse"
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
        
        #pragma surface surf CustomDiffuse

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

        inline float4 LightingCustomDiffuse(SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            float difLight = max(0, dot(s.Normal, lightDir));
            float4 col;
            col.rgb = s.Albedo * _LightColor0.rgb * (difLight * atten * 2);
            col.a = s.Alpha;
            return col;
        }

        ENDCG
        
    }
    
    FallBack "Diffuse"
}
