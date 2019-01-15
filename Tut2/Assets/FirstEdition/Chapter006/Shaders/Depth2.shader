Shader "CookbookShaders/Chapter006/Depth2"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
    }

    SubShader
    {
        Tags 
        { 
            "RenderType" = "Opaque"
            "Queue" = "Geometry+2"
        }
        LOD 200
        ZWrite Off
        
        CGPROGRAM
        
        #pragma surface surf Lambert

        float4 _Color;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Color.rgb;
            o.Alpha = 0;
        }
        
        ENDCG
        
    }

    FallBack "Diffuse"
}
