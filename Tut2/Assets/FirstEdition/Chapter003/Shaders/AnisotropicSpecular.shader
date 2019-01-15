Shader "CookbookShaders/Chapter003/AnisotropicSpecular"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo (RGB)", 2D) = "white" { }
        _SpecColor ("Specular Color", Color) = (1, 1, 1, 1)
		_Specular ("Specular Amount", Range(0, 1)) = 0.5
        _SpecPower ("Specular Power", Range(0, 1)) = 0.5
		_AnisoDir ("Anisotropic Direction", 2D) = "" { }
		_AnisoOffset ("Anisotropic Offset", Range(-1, 1)) = -0.2
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200
        
        CGPROGRAM
        
        #pragma surface surf Anisotropic
        #pragma target 3.0

        float4 _Color;
        sampler2D _MainTex;
        float _Specular;
        float _SpecPower;
        sampler2D _AnisoDir;
        float _AnisoOffset;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_AnisoDir;
        };

        struct SurfaceAnisoOutput
        {
            fixed3 Albedo;
            fixed3 Normal;
            fixed3 Emission;
            fixed3 AnisoDirection;
            half Specular;
            fixed Gloss;
            fixed Alpha;
        };

        void surf(Input IN, inout SurfaceAnisoOutput o)
        {
            half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            float3 anisoTex = UnpackNormal(tex2D(_AnisoDir, IN.uv_AnisoDir));

            o.AnisoDirection = anisoTex;
            o.Specular = _Specular;
            o.Gloss = _SpecPower;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        inline fixed4 LightingAnisotropic(SurfaceAnisoOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
        {
            fixed3 h = normalize(normalize(lightDir) + normalize(viewDir));
            float nl = saturate(dot(s.Normal, lightDir));

            fixed nh = dot(normalize(s.Normal + s.AnisoDirection), h);
            float aniso = max(0, sin(radians((nh + _AnisoOffset) * 180)));

            float spec = saturate(pow(aniso, s.Gloss * 128) * s.Specular);

            fixed4 c;
            c.rgb = ((s.Albedo * _LightColor0.rgb * nl) + (_LightColor0.rgb * _SpecColor.rgb * spec)) * (atten * 2);
            c.a = 1;
            return c;

        }

        ENDCG
        
    }

    FallBack "Diffuse"
}
