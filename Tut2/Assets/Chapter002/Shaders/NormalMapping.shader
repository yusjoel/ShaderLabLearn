Shader "CookbookShaders/Chapter002/NormalMapping"
{
    Properties
    {
        _DiffuseColor ("Diffuse Color", Color) = (1, 1, 1, 1)
        _NormalMap ("Normal Map", 2D) = "bump" { }
        _NormalX ("Normal X", float) = 1
        _NormalY ("Normal Y", float) = 1
        _NormalZ ("Normal Z", float) = 1
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200
        
        CGPROGRAM
        
        #pragma surface surf Lambert

        float4 _DiffuseColor;
        sampler2D _NormalMap;
        float _NormalX;
        float _NormalY;
        float _NormalZ;

        struct Input
        {
            float2 uv_NormalMap;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed3 n = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
            o.Normal = float3(n.x * _NormalX, n.y * _NormalY, n.z * _NormalZ);
            o.Albedo = _DiffuseColor.rgb;
            o.Alpha = _DiffuseColor.a;
        }
        ENDCG
        
    }

    FallBack "Diffuse"
}
