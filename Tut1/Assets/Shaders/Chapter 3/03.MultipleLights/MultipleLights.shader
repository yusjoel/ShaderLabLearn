Shader "3D Graphics with XNA Games Studio 4.0/Chapter 3/03.MultipleLights"
{
	Properties
	{
		_BasicTexture ("Texture", 2D) = "white" {}
		_DiffuseColor ("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_AmbientColor ("Ambient Color", Color) = (0.1, 0.1, 0.1, 1)
		_Light1Direction ("Light 1 Direction", Vector) = (1, 1, 1)
		_Light1Color ("Light 1 Color", Color) = (0.9, 0.9, 0.9, 1.0)
		_Light2Direction ("Light 2 Direction", Vector) = (1, 1, 1)
		_Light2Color ("Light 2 Color", Color) = (0.9, 0.9, 0.9, 1.0)
		_Light3Direction ("Light 3 Direction", Vector) = (1, 1, 1)
		_Light3Color ("Light 3 Color", Color) = (0.9, 0.9, 0.9, 1.0)
		_SpecularPower ("Specular Power", Float) = 32
		_SpecularColor ("Specular Color", Color) = (1, 1, 1)
		_CameraPosition ("Camera Position", Vector) = (1, 1, 1)
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

			#define NUMLIGHTS 3
			
			sampler2D _BasicTexture;
			float4 _BasicTexture_ST;
			float4 _DiffuseColor;
			float4 _AmbientColor;
			float3 _Light1Direction;
			float4 _Light1Color;
			float3 _Light2Direction;
			float4 _Light2Color;
			float3 _Light3Direction;
			float4 _Light3Color;
			float _SpecularPower;
			float4 _SpecularColor;
			float3 _CameraPosition;
			
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
			  float3 ViewDirection : TEXCOORD2;
			};
			
			VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
			{
				VertexShaderOutput output;
				output.Position = UnityObjectToClipPos(input.Position);
				output.UV = TRANSFORM_TEX(input.UV, _BasicTexture);
				output.Normal = mul(input.Normal, (float3x3)unity_WorldToObject);
				float3 worldPosition = mul(unity_ObjectToWorld, input.Position).xyz;
				output.ViewDirection = worldPosition - _CameraPosition;
				return output;
			}


			float4 PixelShaderFunction(VertexShaderOutput input) : SV_Target
			{
				float4 color = _DiffuseColor;
				color *= tex2D(_BasicTexture, input.UV);
				
				float4 lighting = _AmbientColor;
				
				float3 normal = normalize(input.Normal);
				float3 view = normalize(input.ViewDirection);

				float3 LightDirections[NUMLIGHTS] = {_Light1Direction, _Light2Direction, _Light3Direction};
				float4 LightColors[NUMLIGHTS] = {_Light1Color, _Light2Color, _Light3Color};
				
				for(int i = 0; i < NUMLIGHTS; i++)
				{
					float3 lightDir = normalize(LightDirections[i]);
					// Add lambertian lighting
					lighting += saturate(dot(lightDir, normal)) * LightColors[i];

					float3 refl = reflect(lightDir, normal);
					// Add specular highlights
					lighting += pow(saturate(dot(refl, view)), _SpecularPower) * _SpecularColor;
				}


				// Calculate final color
				float4 output = saturate(lighting) * color;
				
				return output;
			}
			ENDCG
		}
	}
}
