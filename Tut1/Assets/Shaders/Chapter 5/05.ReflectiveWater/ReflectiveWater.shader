Shader "3D Graphics with XNA Games Studio 4.0/Chapter 5/05.ReflectiveWater"
{
	Properties
	{
		_ReflectionMap ("Reflection Map", 2D) = "white" {}
		_BaseColor ("Water Color", Color) = (.2, .2, .8)
		_BaseColorAmount ("Water Color Amount", Float) = .3
		_WaterNormapMap ("Water Normal Map", 2D) = "gray" {}
		_WaveLength ("Wave Length", Float) = .6
		_WaveHeight ("Wave Height", Float) = .2
		_WaveSpeed ("Wave Speed", Float) = .04
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
			
			sampler2D _ReflectionMap;
			float4x4 _ReflectedMvpMatrix;
			float3 _BaseColor;
			float _BaseColorAmount;
			sampler2D _WaterNormapMap;
			float _WaveLength;
			float _WaveHeight;
			float _WaveSpeed;
			
			struct VertexShaderInput
			{
			  float4 Position : POSITION;
			  float2 UV : TEXCOORD0;
			};
			
			struct VertexShaderOutput
			{
			  float4 Position : SV_POSITION;
			  float4 ReflectionPosition : TEXCOORD0;
			  float2 NormalMapPosition : TEXCOORD1;
			};
			
			VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
			{
				VertexShaderOutput output;
				output.Position = UnityObjectToClipPos(input.Position);
				output.ReflectionPosition = mul(_ReflectedMvpMatrix, input.Position);
				output.NormalMapPosition = input.UV/_WaveLength;
				output.NormalMapPosition.y -= _Time * _WaveSpeed;
				return output;
			}

			// Calculate the 2D screenposition of a position vector
			float2 postProjToScreen(float4 position)
			{
				float2 screenPos = position.xy / position.w;
				return 0.5f * (float2(screenPos.x, -screenPos.y) + 1);
			}

			// Calculate the size of one half of a pixel, to convert
			// between texels and pixels
			float2 halfPixel()
			{
				return 0.5f / float2(_ScreenParams.x, _ScreenParams.y);
			}

			float4 PixelShaderFunction(VertexShaderOutput input) : SV_Target
			{
				float2 reflectionUV = postProjToScreen(input.ReflectionPosition) + halfPixel();
				float4 normal = tex2D(_WaterNormapMap, input.NormalMapPosition) * 2 - 1;
				float2 UVOffset = _WaveHeight * normal.rg;
				float3 reflection = tex2D(_ReflectionMap, reflectionUV + UVOffset);
				return float4(lerp(reflection, _BaseColor, _BaseColorAmount), 1);
			}
			ENDCG
		}
	}
}
