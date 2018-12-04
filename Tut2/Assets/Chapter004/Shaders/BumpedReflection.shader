Shader "CookbookShaders/Chapter004/BumpedReflection"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo (RGB)", 2D) = "white" { }
        _NormalMap ("Normal Map", 2D) = "bump" { }
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
        sampler2D _NormalMap;
        samplerCUBE _Cubemap;
        float _ReflAmount;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
            float3 worldRefl;
            INTERNAL_DATA
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;

            float3 normals = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap)).rgb;
            o.Normal = normals;
            o.Emission = texCUBE(_Cubemap, WorldReflectionVector(IN, o.Normal)).rgb * _ReflAmount;
        }
        ENDCG
        
    }
    FallBack "Diffuse"
}
