Shader "Debug/HalfLightView"
{
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200
        
        CGPROGRAM
        
        #pragma surface surf Custom

        struct Input
        {
            float3 worldNormal;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
        }

        inline fixed4 LightingCustom(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
        {
            fixed3 h = normalize(lightDir + viewDir);
            fixed3 nh = saturate(dot(s.Normal, h));
            return fixed4(nh, 1);
        }


        ENDCG
        
    }
    FallBack "Diffuse"
}
