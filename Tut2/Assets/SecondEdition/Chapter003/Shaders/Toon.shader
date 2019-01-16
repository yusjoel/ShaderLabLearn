Shader "CookbookShaders(2nd Edition)/Chapter003/Toon"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        [IntRange]_CelShadingLevels ("Celluloid Shading Levels", Range(2, 10)) = 5
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200
        
        CGPROGRAM
        
        #pragma surface surf Toon
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;
        float _CelShadingLevels;

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Color.rgb;
            o.Alpha = _Color.a;
        }

        half4 LightingToon(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
        {
            half NdotL = dot(s.Normal, lightDir);
            half cel = floor(NdotL * _CelShadingLevels) / (_CelShadingLevels - 0.5); // Snap
            half4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * cel * atten;
            c.a = s.Alpha;
            return c;
        }
        ENDCG
        
    }
    FallBack "Diffuse"
}
