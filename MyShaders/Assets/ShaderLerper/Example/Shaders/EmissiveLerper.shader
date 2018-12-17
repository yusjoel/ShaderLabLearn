Shader "Custom/Emissive (Lerper)"
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

		#include "Lerp Helper.cginc"
        
        #pragma surface surf Lambert

        float4 _EmissiveColor;
        float4 _EmissiveColorLerpTo;
        float _Power;
        float _PowerLerpTo;

        struct Input
        {
            float2 uv_MainTex;
			float3 worldPos;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
			INIT_LERP;
            fixed4 c = pow(LERP_PROP(_EmissiveColor), LERP_PROP(_Power));
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
        
    }
    
    FallBack "Diffuse"
}
