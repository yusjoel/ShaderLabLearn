Shader "CookbookShaders/Chapter004/FresnelReflection"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo (RGB)", 2D) = "white" { }
        _Cubemap ("Cubemap", CUBE) = "Skybox" { }
        _ReflAmount ("Reflection Amount", Range(0.01, 1)) = 0.5
        _RimPower ("Fresnel Falloff", Range(0.1, 3)) = 2
        _SpecColor ("Specular Color", Color) = (1, 1, 1, 1)
        _SpecPower ("Specular Power", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200
        
        CGPROGRAM
        
        #pragma surface surf BlinnPhong

        fixed4 _Color;
        sampler2D _MainTex;
        samplerCUBE _Cubemap;
        float _ReflAmount;
        float _RimPower;
        float _SpecPower;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldRefl;
            float3 viewDir;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;

            float rim = 1 - saturate(dot(o.Normal, normalize(IN.viewDir)));
            rim = pow(rim, _RimPower);
            o.Emission = texCUBE(_Cubemap, IN.worldRefl).rgb * _ReflAmount * rim;

            o.Specular = _SpecPower;
            o.Gloss = 1;
        }
        ENDCG
        
    }
    FallBack "Diffuse"
}
