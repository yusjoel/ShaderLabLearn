﻿Shader "3D Graphics with XNA Games Studio 4.0/Chapter 5/02.NormalMapping"
{
	Properties
	{
		_BasicTexture ("Texture", 2D) = "white" {}
		_DiffuseColor ("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_AmbientColor ("Ambient Color", Color) = (0.1, 0.1, 0.1, 1)
		_LightDirection ("Light Direction", Vector) = (1, 1, 1)
		_LightColor ("Light Color", Color) = (0.9, 0.9, 0.9, 1.0)
		_SpecularPower ("Specular Power", Float) = 32
		_SpecularColor ("Specular Color", Color) = (1, 1, 1)
		_CameraPosition ("Camera Position", Vector) = (1, 1, 1)
		_NormalMap("Normal Map", 2D) = "white" {}
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex VertexShaderFunction
			#pragma fragment PixelShaderFunction
			
			#include "UnityCG.cginc"
			
			sampler2D _BasicTexture;
			float4 _BasicTexture_ST;
			float4 _DiffuseColor;
			float4 _AmbientColor;
			float3 _LightDirection;
			float4 _LightColor;
			float _SpecularPower;
			float4 _SpecularColor;
			float3 _CameraPosition;
			sampler2D _NormalMap;
			float4 _NormalMap_ST;
			
			struct VertexShaderInput
			{
			  float4 Position : POSITION;
			  float2 UV : TEXCOORD0;
			};
			
			struct VertexShaderOutput
			{
			  float4 Position : SV_POSITION;
			  float4 UV : TEXCOORD0;
			  float3 ViewDirection : TEXCOORD1;
			};
			
			VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
			{
				VertexShaderOutput output;
				output.Position = UnityObjectToClipPos(input.Position);
				output.UV.xy = TRANSFORM_TEX(input.UV, _BasicTexture);
				output.UV.zw = TRANSFORM_TEX(input.UV, _NormalMap);
				float3 worldPosition = mul(unity_ObjectToWorld, input.Position).xyz;
				output.ViewDirection = worldPosition - _CameraPosition;
				return output;
			}

			float4 PixelShaderFunction(VertexShaderOutput input) : SV_Target
			{
				float4 color = _DiffuseColor;
				color *= tex2D(_BasicTexture, input.UV.xy);
				
				float4 lighting = _AmbientColor;
				float3 lightDir = normalize(_LightDirection);
				float3 normal = tex2D(_NormalMap, input.UV.zw).rgb;
				normal = normal * 2 - 1; // Move from [0, 1] to [-1, 1] range
				
				// Add lambertian lighting
				lighting += saturate(dot(lightDir, normal)) * _LightColor;

				float3 refl = reflect(lightDir, normal);
				float3 view = normalize(input.ViewDirection);

				// Add specular highlights
				lighting += pow(saturate(dot(refl, view)), _SpecularPower) * _SpecularColor;

				// Calculate final color
				float4 output = saturate(lighting) * color;
				
				return output;
			}
			ENDCG
		}
	}
}
