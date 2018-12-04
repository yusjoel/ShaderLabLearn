Shader "CookbookShaders/Chapter003/PhongMask"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo (RGB)", 2D) = "white" { }
        _SpecColor ("Specular Color", Color) = (1, 1, 1, 1)
        _SpecPower ("Specular Power", float) = 32
        _SpecMask ("Specular Mask", 2D) = "white" { }
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200
        
        CGPROGRAM
        
        #pragma surface surf Phong

        float4 _Color;
        sampler2D _MainTex;
        float _SpecPower;
        sampler2D _SpecMask;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_SpecMask;
        };

        struct SurfaceCustomOutput
        {
            fixed3 Albedo;
            fixed3 Normal;
            fixed3 Emission;
            fixed3 SpecularColor;
            half SpecularMask;
            fixed Gloss;
            fixed Alpha;
        };

        void surf(Input IN, inout SurfaceCustomOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;

            c = tex2D(_SpecMask, IN.uv_SpecMask);
            o.SpecularColor = c.rgb;
            o.SpecularMask = c.a;
        }

        inline fixed4 LightingPhong(SurfaceCustomOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
        {
            float diff = dot(s.Normal, lightDir);

            float3 refl = normalize(reflect(-lightDir, s.Normal));
            float spec = pow(max(0, dot(refl, viewDir)), _SpecPower) * s.SpecularMask;
            float3 finalSpec = s.SpecularColor * _SpecColor.rgb * spec;

            fixed4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff) + (_LightColor0.rgb * finalSpec);
            c.a = 1;
            return c;
        }
        
        ENDCG
        
    }

    FallBack "Diffuse"
}
