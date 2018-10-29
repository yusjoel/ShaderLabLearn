﻿Shader "3D Graphics with XNA Games Studio 4.0/Chapter 3/02.SpotLight"
{
	Properties
	{
		_BasicTexture ("Texture", 2D) = "white" {}
		_DiffuseColor ("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_AmbientColor ("Ambient Color", Color) = (0.1, 0.1, 0.1, 1)
		_LightPosition ("Light Position", Vector) = (1, 1, 1)
		_LightColor ("Light Color", Color) = (0.9, 0.9, 0.9, 1.0)
		_LightDirection ("Light Direction", Vector) = (1, 1, 1)
		_ConeAngle ("Cone Angle", Float) = 30
		_LightFalloff ("Light Falloff", Float) = 20
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
			float3 _LightPosition;
			float4 _LightColor;
			float3 _LightDirection;
			float _ConeAngle;
			float _LightFalloff;
			
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
			  float4 WorldPosition : TEXCOORD2;
			};
			
			VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
			{
				VertexShaderOutput output;

				output.Position = UnityObjectToClipPos(input.Position);
				output.UV = TRANSFORM_TEX(input.UV, _BasicTexture);
				output.Normal = mul(input.Normal, (float3x3)unity_WorldToObject);
				output.WorldPosition = mul(unity_ObjectToWorld, input.Position);

				return output;
			}

			float4 PixelShaderFunction(VertexShaderOutput input) : SV_Target
			{
				float4 diffuseColor = _DiffuseColor;
				diffuseColor *= tex2D(_BasicTexture, input.UV);
				
				float4 totalLight = _AmbientColor;
				float3 lightDir = normalize(_LightPosition - input.WorldPosition);
				float diffuse = saturate(dot(lightDir, normalize(input.Normal)));

				// (dot(p - lp, ld) / cos(a))^f
				float d = dot(-lightDir, normalize(_LightDirection));
				float a = cos(_ConeAngle);
				float att = 0;
				
				if (a < d)
					att = 1 - pow(clamp(a / d, 0, 1), _LightFalloff);
				
				totalLight += diffuse * att * _LightColor;
				float4 output = totalLight * diffuseColor;
				
				return output;
			}
			ENDCG
		}
	}
}