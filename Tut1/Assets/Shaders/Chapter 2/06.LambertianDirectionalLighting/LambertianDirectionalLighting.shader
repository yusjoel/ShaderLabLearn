﻿Shader "3D Graphics with XNA Games Studio 4.0/Chapter 2/06.LambertianDirectionalLighting"
{
	Properties
	{
		_BasicTexture ("Texture", 2D) = "white" {}
		_DiffuseColor ("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_AmbientColor ("Ambient Color", Color) = (0.1, 0.1, 0.1, 1)
		_LightDirection ("Light Direction", Vector) = (1, 1, 1)
		_LightColor ("Light Color", Color) = (0.9, 0.9, 0.9, 1.0)
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
			
			struct VertexShaderInput
			{
			  float4 Position : POSITION;
			  float2 UV : TEXCOORD0;
			  float3 Normal : NORMAL;
			};
			
			struct VertexShaderOutput
			{
			  float4 Position : SV_POSITION;
			  float2 UV : TEXCOORD0;
			  float3 Normal : TEXCOORD1;
			};
			
			VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
			{
				VertexShaderOutput output;
				output.Position = UnityObjectToClipPos(input.Position);
				output.UV = TRANSFORM_TEX(input.UV, _BasicTexture);
				output.Normal = mul(input.Normal, (float3x3)unity_WorldToObject);
				return output;
			}


			float4 PixelShaderFunction(VertexShaderOutput input) : SV_Target
			{
				float4 color = _DiffuseColor;
				color *= tex2D(_BasicTexture, input.UV);
				
				float4 lighting = _AmbientColor;
				float3 lightDir = normalize(_LightDirection);
				float3 normal = normalize(input.Normal);
				
				lighting += saturate(dot(lightDir, normal)) * _LightColor;
				float4 output = saturate(lighting) * color;
				
				return output;
			}
			ENDCG
		}
	}
}
