Shader "CookbookShaders/Chapter002/LevelEffect"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo (RGB)", 2D) = "white" { }
        _inBlack ("Input Black", Range(0, 255)) = 0
        _inGamma ("Input Gamma", Range(0, 2)) = 1.61
        _inWhite ("Input White", Range(0, 255)) = 255
        _outWhite ("Output White", Range(0, 255)) = 255
        _outBlack ("Output Black", Range(0, 255)) = 0
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200
        
        CGPROGRAM

        #pragma surface surf Lambert

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;
        float _inBlack;
        float _inGamma;
        float _inWhite;
        float _outBlack;
        float _outWhite;

        float GetPixelLevel(float color)
        {
            float result = color * 255.0;
            result = max(0, result - _inBlack);
            result = saturate(pow(result / (_inWhite - _inBlack), _inGamma));
            result = (result * (_outWhite - _outBlack) + _outBlack) / 255.0;
            return result;
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            float r = GetPixelLevel(c.r);
            float g = GetPixelLevel(c.g);
            float b = GetPixelLevel(c.b);
            o.Albedo = float3(r, g, b);
            o.Alpha = c.a;
        }
        ENDCG
        
    }
    FallBack "Diffuse"
}
