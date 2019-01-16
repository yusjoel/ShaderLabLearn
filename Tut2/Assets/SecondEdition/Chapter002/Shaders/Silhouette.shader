Shader "CookbookShaders(2nd Edition)/Chapter002/Silhouette"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo (RGB)", 2D) = "white" { }
        _RimEffect ("Rim Effect", Range(-1, 1)) = 0.25
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
        
        CGPROGRAM
        
        #pragma surface	surf NoLighting alpha:fade noforwardadd

        sampler2D _MainTex;
        fixed4 _Color;
        float _RimEffect;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldNormal;
            float3 viewDir;
        };


        void surf(Input IN, inout SurfaceOutput o)
        {
            float4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;

            float border = 1 - abs(dot(IN.viewDir, IN.worldNormal));
            float alpha = border * (1 - _RimEffect) + _RimEffect;
            o.Alpha = c.a * alpha;
        }

        fixed4 LightingNoLighting(SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            fixed4 c;
            c.rgb = s.Albedo;
            c.a = s.Alpha;
            return c;
        }
        ENDCG
        
    }
    FallBack "Diffuse"
}