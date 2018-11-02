Shader "3D Graphics with XNA Games Studio 4.0/Chapter 6/Tree (Billboard Cylindrical)"
{
	Properties
	{
		_BasicTexture ("Texture", 2D) = "white" {}
	}

	SubShader
	{
		Tags 
		{ 
			"Queue" = "AlphaTest"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
			"DisableBatching" = "True"
		}
		LOD 100

		Pass
		{
			Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM
			#pragma vertex VertexShaderFunction
			#pragma fragment PixelShaderFunction
			
			#include "UnityCG.cginc"

			struct VertexShaderInput
			{
				float4 Position : POSITION;
				float2 UV : TEXCOORD0;
			};

			struct VertexShaderOutput
			{
				float4 Position : SV_POSITION;
				float2 UV : TEXCOORD0;
			};

			sampler2D _BasicTexture;
			float4 _BasicTexture_ST;
			
			VertexShaderOutput VertexShaderFunction (VertexShaderInput input)
			{
				float2 Size = float2(1, 1);
				float3 forward = UNITY_MATRIX_IT_MV[2].xyz;
				float3 Up = float3(0, 1, 0);
				float3 Side = normalize(cross(forward, Up));

				VertexShaderOutput output;
				float4 worldSpaceOrigin = mul(unity_ObjectToWorld, float4(0, 0, 0, 1));
				float3 position = worldSpaceOrigin.xyz;
				// Determine which corner of the rectangle this vertex
				// represents
				float2 offset = float2((input.UV.x - 0.5f) * 2.0f, (input.UV.y - 0.5f) * 2.0f);
				// Move the vertex along the camera's 'plane' to its corner
				position += offset.x * Size.x * Side + offset.y * Size.y * Up;
				// Transform the position by view and projection
				output.Position = mul(UNITY_MATRIX_VP, float4(position, 1));

				output.UV = TRANSFORM_TEX(input.UV, _BasicTexture);
				return output;
			}
			
			fixed4 PixelShaderFunction(VertexShaderOutput input) : SV_Target
			{
				fixed4 output = tex2D(_BasicTexture, input.UV);
				clip(output.a - 0.5);
				return output;
			}
			ENDCG
		}
	}
}
