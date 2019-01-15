Shader "CookbookShaders/Chapter003/CustomBlinnPhong"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo (RGB)", 2D) = "white" { }
        _SpecColor ("Specular Color", Color) = (1, 1, 1, 1)
        _SpecPower ("Specular Power", float) = 32
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200
        
        CGPROGRAM
        
        #pragma surface surf CustomBlinnPhong

        float4 _Color;
        sampler2D _MainTex;
        float _SpecPower;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        inline fixed4 LightingCustomBlinnPhong(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
        {
            float diff = dot(s.Normal, lightDir);

            float3 h = normalize(lightDir + viewDir);
			float nh = saturate(dot(s.Normal, h));
            float spec = pow(nh, _SpecPower);
            float3 finalSpec = _SpecColor.rgb * spec;

            fixed4 c;
            c.rgb = (s.Albedo * _LightColor0.rgb * diff) + (_LightColor0.rgb * finalSpec * atten);
            c.a = 1;
            return c;
        }
        
        ENDCG
        
    }

    FallBack "Diffuse"
}
