Shader "CookbookShaders/Chapter003/CookTorrance"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo (RGB)", 2D) = "white" { }
        _SpecColor ("Specular Color", Color) = (1, 1, 1, 1)
        _SpecPower ("Specular Power", float) = 32
		_RoughnessTex ("roughness Texture", 2D) = "" { }
		_Roughness ("Roughness", Range(0, 1)) = 0.5
		_Fresnel ("Fresnel", Range(0, 1)) = 0.05
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200
        
        CGPROGRAM
        
        #pragma surface surf CookTorrance
		#pragma target 3.0

        float4 _Color;
        sampler2D _MainTex;
        float _SpecPower;
		sampler2D _RoughnessTex;
		float _Roughness;
		float _Fresnel;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_RoughnessTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

        inline fixed4 LightingCookTorrance(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
        {
			float L = normalize(lightDir);
			float V = normalize(viewDir);
			float H = normalize(lightDir + viewDir);
			float N = s.Normal;

			float NL = dot(N, L);
			float NL01 = saturate(NL);
			float NH = dot(N, H);
			float NH01 = saturate(NH);
			float NV01 = saturate(dot(N, V));
			float HV01 = saturate(dot(H, V));

			// Micro facets distribution
			float geoEnum = 2 * NH01;
			float G1 = (geoEnum * NV01) / HV01;
			float G2 = (geoEnum * NL01) / HV01;
			float G = min(1, min(G1, G2));

			float roughness = tex2D(_RoughnessTex, float2(NH * 0.5 + 0.5, _Roughness)).r;

			float fresnel = pow(1 - HV01, 5) * (1 - _Fresnel) + _Fresnel;

			float spec = (fresnel * G * roughness) / (NV01 * NL01);
			float3 finalSpec = _SpecColor.rgb * spec;
			
			float4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * NL) + (_LightColor0.rgb * finalSpec * atten);
			c.a = s.Alpha;
			return c;
        }
        
        ENDCG
        
    }

    FallBack "Diffuse"
}
