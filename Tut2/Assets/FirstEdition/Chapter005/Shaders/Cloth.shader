Shader "Custom/Cloth"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _BumpMap ("Normal Map", 2D) = "bump" { }
        _DetailBump ("Detail Normal Map", 2D) = "bump" { }
        _DetailTex ("Fabric Weave", 2D) = "white" { }
        _FresnelColor ("Fresnel Color", Color) = (1, 1, 1, 1)
        _FresnelPower ("Fresnel Power", Range(0, 12)) = 3
        _RimPower ("Rim Falloff", Range(0, 12)) = 3
        _Specular ("Specular", Range(0, 1)) = 0.2
        _Gloss ("Gloss", Range(0, 1)) = 0.2
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200
        
        CGPROGRAM
        
        #pragma surface surf Velvet
        #pragma target 3.0

        float4 _Color;
        sampler2D _BumpMap;
        sampler2D _DetailBump;
        sampler2D _DetailTex;
        float4 _FresnelColor;
        float _FresnelPower;
        float _RimPower;
        float _Specular;
        float _Gloss;

        struct Input
        {
            float2 uv_BumpMap;
            float2 uv_DetailBump;
            float2 uv_DetailTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            half4 c = tex2D(_DetailTex, IN.uv_DetailTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;

            fixed3 normals = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap)).rgb;
            fixed3 detailNormals = UnpackNormal(tex2D(_DetailBump, IN.uv_DetailBump)).rgb;
            fixed3 finalNormals = normals + detailNormals;
            o.Normal = normalize(finalNormals);

            o.Specular = _Specular;
            o.Gloss = _Gloss;
        }

        inline fixed4 LightingVelvet(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
        {
            half3 h = normalize(lightDir + viewDir);
            fixed nl = max(0, dot(s.Normal, lightDir));

            // Specular
            float nh = max(0, dot(s.Normal, h));
            float spec = pow(nh, s.Specular * 128) * s.Gloss;

            // Fresnel
            float hv = pow(1 - max(0, dot(h, viewDir)), _FresnelPower);
            float nv = pow(1 - max(0, dot(s.Normal, viewDir)), _RimPower);
            float finalSpecMask = nv * hv;

            // Final Color
            fixed4 c;
            fixed3 diffColor = s.Albedo * nl * _LightColor0.rgb;
            fixed3 specColor = spec * (finalSpecMask * _FresnelColor) * atten;
            c.rgb = diffColor + specColor;
            c.a = 1;
            return c;
        }
        
        ENDCG
        
    }

    FallBack "Diffuse"
}
