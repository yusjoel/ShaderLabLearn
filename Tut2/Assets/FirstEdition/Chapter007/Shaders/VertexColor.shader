﻿Shader "CookbookShaders/Chapter007/VertexColor"
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
            "Queue" = "Geometry"
        }
        LOD 200
        
        CGPROGRAM
        
        #pragma surface surf Lambert vertex:vert

        float4 _Color;

        struct Input
        {
            float2 uv_MainTex;
            float4 vertColor;
        };

        void vert(inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            o.vertColor = v.color;
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = IN.vertColor.rgb * _Color.rgb;
        }
        
        ENDCG
        
    }

    FallBack "Diffuse"
}
