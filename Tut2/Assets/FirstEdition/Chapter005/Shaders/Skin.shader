Shader "CookbookShaders/Chapter005/Skin"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo (RGB)", 2D) = "white" { }
        _NormalMap ("Normal Map", 2D) = "" { }
        _CurveScale ("Curvature Scale", Range(0.001, 0.09)) = 0.01
        _CurveAmount ("Curvature Amount", Range(0, 1)) = 0.5
        _NormalBias ("Normal Map Blur", Range(0, 5)) = 2
        _Specular ("Specular", Range(0, 1)) = 0.2
        _Gloss ("Gloss", Range(0, 1)) = 0.4
        _BrdfTex ("BRDF Texture", 2D) = "" { }
        _FresnelVal ("Fresnel Amount", Range(0.01, 0.3)) = 0.05
        _RimPower ("Rim Falloff", Range(0, 5)) = 2
        _RimColor ("Rim Color", Color) = (1, 1, 1, 1)   
    }
    
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200
        
        CGPROGRAM
        
        #pragma surface surf Skin
        #pragma target 3.0
        //#pragma only_renderers d3d9

        fixed4 _Color;
        sampler2D _MainTex;
        sampler2D _NormalMap;
        fixed _CurveScale;
        fixed _CurveAmount;
        fixed _NormalBias;
        fixed _Specular;
        fixed _Gloss;
        sampler2D _BrdfTex;
        fixed _FresnelVal;
        fixed _RimPower;
        fixed4 _RimColor;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
            float3 worldNormal;
            INTERNAL_DATA
        };

        struct SurfaceOutputSkin
        {
            fixed3 Albedo;
            fixed3 Normal;
            fixed3 Emission;
            fixed3 Specular;
            fixed Gloss;
            fixed Alpha;
            float Curvature;
            fixed3 BlurredNormals;
        };

        void surf(Input IN, inout SurfaceOutputSkin o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;

            fixed3 normals = UnpackNormal(tex2D(_NormalMap, IN.uv_MainTex));
            o.Normal = normals;

            fixed3 blurredNormals = UnpackNormal(tex2Dbias(_NormalMap, float4(IN.uv_MainTex, 0, _NormalBias)));
            o.BlurredNormals = blurredNormals;

            float curvature = length(fwidth(WorldNormalVector(IN, blurredNormals))) / length(fwidth(IN.worldPos)) * _CurveScale;
            o.Curvature = curvature;

            o.Specular = _Specular;
            o.Gloss = _Gloss;
        }

        inline fixed4 LightingSkin(SurfaceOutputSkin s, fixed3 lightDir, half3 viewDir, fixed atten)
        {
            half3 h = normalize(lightDir + viewDir);
            fixed nl = dot(s.BlurredNormals, lightDir);

            // Create BRDf and Faked SSS(Sub-Surface Scattering?)
            half4 brdf = tex2D(_BrdfTex, float2((nl * 0.5 + 0.5) * atten, s.Curvature));

            // Create Fresnel and Rim lighting
            float fresnel = saturate(pow(1 - dot(viewDir, h), 5));
            fresnel = fresnel + (1 - fresnel) * _FresnelVal;
            float rim = saturate(pow(1 - dot(viewDir, s.BlurredNormals), _RimPower)) * fresnel;

            // Create Specular
            float nh = max(0, dot(s.Normal, h));
            float spec = pow(nh, s.Specular * 128) * s.Gloss;

            fixed4 c;
            fixed3 diff = s.Albedo * _LightColor0.rgb * brdf.rgb * atten;
            c.rgb = diff + spec + rim * _RimColor;
            c.a = 1;

            return c;
        }
        
        ENDCG
        
    }
    FallBack "Diffuse"
}
