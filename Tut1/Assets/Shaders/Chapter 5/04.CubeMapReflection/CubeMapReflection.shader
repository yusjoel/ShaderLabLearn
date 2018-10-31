Shader "3D Graphics with XNA Games Studio 4.0/Chapter 5/04.CubeMapReflection"
{
	Properties
	{
		_CubeMap("Cube Map", Cube) = "white" {}
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
			
			samplerCUBE _CubeMap;
			
			struct VertexShaderInput
			{
			  float4 Position : POSITION;
			  float3 Normal : NORMAL;
			};
			
			struct VertexShaderOutput
			{
			  float4 Position : SV_POSITION;
			  float3 WorldPosition : TEXCOORD0;
			  float3 Normal : TEXCOORD1;
			};
			
			VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
			{
				VertexShaderOutput output;
				output.Position = UnityObjectToClipPos(input.Position);
				output.Normal = mul(input.Normal, (float3x3)unity_WorldToObject);
				output.WorldPosition = mul(unity_ObjectToWorld, input.Position).xyz;
				return output;
			}

			float4 PixelShaderFunction(VertexShaderOutput input) : SV_Target
			{
				//if (ClipPlaneEnabled)
				//	clip(dot(float4(input.WorldPosition, 1), ClipPlane));

				float3 viewDirection = normalize(input.WorldPosition - _WorldSpaceCameraPos);
				float3 normal = normalize(input.Normal);
				// Reflect around normal
				float3 reflection = reflect(viewDirection, normal);
				return texCUBE(_CubeMap, reflection);
			}
			ENDCG
		}
	}
}
