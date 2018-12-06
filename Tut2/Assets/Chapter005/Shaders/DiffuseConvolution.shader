Shader "CookbookShaders/Chapter005/DiffuseConvolution"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _NormalMap ("Normal Map", 2D) = "" { }
        _AmbientOcclusionMap ("Ambient Occlution Map", 2D) = "" { }
        _CubeMap ("Diffuse Convolution Cubemap", CUBE) = "" { }
        _Gloss ("Specular Gloss", Range(0, 1)) = 0.4
        _Specular ("Specular Power", Range(0, 1)) = 0.2
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200
        
        CGPROGRAM
        
        #pragma surface surf DiffuseConvolution
        #pragma target 3.0

        fixed4 _Color;
        sampler2D _NormalMap;
        sampler2D _AmbientOcclusionMap;
        samplerCUBE _CubeMap;
        float _Gloss;
        float _Specular;

        struct Input
        {
            float2 uv_AmbientOcclusionMap;
            float3 worldNormal;
            INTERNAL_DATA
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            half4 c = tex2D(_AmbientOcclusionMap, IN.uv_AmbientOcclusionMap);
            float3 normals = UnpackNormal(tex2D(_NormalMap, IN.uv_AmbientOcclusionMap)).rgb;
            o.Normal = normals;

            float3 diffuseVal = texCUBE(_CubeMap, WorldNormalVector(IN, o.Normal)).rgb;

            o.Albedo = (c.rgb * diffuseVal) * _Color;
            o.Specular = _Specular;
            o.Gloss = _Gloss * c.rgb;
            o.Alpha = c.a;
        }

        inline fixed4 LightingDiffuseConvolution(SurfaceOutput s, fixed3 lightDir, fixed3 viewDir, fixed atten)
        {
            fixed3 v = normalize(viewDir);
            fixed3 l = normalize(lightDir);
            fixed3 n = normalize(s.Normal);

            float nl = dot(n, l);
            float3 h = normalize(l + v);

            float spec = pow(dot(n, h), s.Specular * 128) * s.Gloss;

            fixed4 c;
            c.rgb = spec;
            c.a = 1;
            return c;
        }
        
        ENDCG
        
    }
    FallBack "Diffuse"
}
