Shader "CookbookShaders/Chapter003/CubemapReflection"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo (RGB)", 2D) = "white" { }
        _Cubemap ("Cubemap", CUBE) = "Skybox" { }
        _ReflAmount ("Reflection Amount", Range(0.01, 1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200
        
        CGPROGRAM
        
        #pragma surface surf Lambert

        fixed4 _Color;
        sampler2D _MainTex;
        samplerCUBE _Cubemap;
        float _ReflAmount;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldRefl;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
            o.Emission = texCUBE(_Cubemap, IN.worldRefl).rgb * _ReflAmount;
        }
        ENDCG
        
    }
    FallBack "Diffuse"
}
