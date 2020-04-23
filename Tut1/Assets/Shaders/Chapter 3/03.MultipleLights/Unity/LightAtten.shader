Shader "3D Graphics with XNA Games Studio 4.0/Chapter 3/Unity/LightAtten"
{
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			Tags { "LightMode" = "Vertex" }

			CGPROGRAM
			#pragma vertex VertexShaderFunction
			#pragma fragment PixelShaderFunction
			
			#include "UnityCG.cginc"
			
			struct VertexShaderInput
			{
			  float4 Position : POSITION;
			};
			
			struct VertexShaderOutput
			{
				float4 Position : SV_POSITION;
			};
			
			VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
			{
				VertexShaderOutput output;
				output.Position = UnityObjectToClipPos(input.Position);
				return output;
			}

			float4 PixelShaderFunction(VertexShaderOutput input) : SV_Target
			{
				float4 att = unity_LightAtten[0];
				return float4(att.z, att.w, 0, 1);
			}
			ENDCG
		}
	}
}
