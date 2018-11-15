Shader "CookbookShaders/Emissive"
{
    Properties
    {
        _EmissiveColor ("Emissive Color", Color) = (1, 0, 0, 0.5)
        _Power ("Power", Range(0, 10)) = 2.5
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200
        
        CGPROGRAM
        
        #pragma surface surf Lambert

        float4 _EmissiveColor;
        float _Power;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = pow(_EmissiveColor, _Power);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
        
    }
    
    FallBack "Diffuse"
}
