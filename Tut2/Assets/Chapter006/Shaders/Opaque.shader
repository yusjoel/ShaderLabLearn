Shader "CookbookShaders/Chapter006/Opaque"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" { }
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
        
        #pragma surface surf Lambert

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
            o.Alpha = 0;
        }
        
        ENDCG
        
    }

    FallBack "Diffuse"
}
