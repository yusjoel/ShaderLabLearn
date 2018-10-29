Shader "3D Graphics with XNA Games Studio 4.0/Chapter 2/02.TextureMapping"
{
	Properties
	{
		_BasicTexture ("Texture", 2D) = "white" {}
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
				VertexShaderOutput output;
				output.Position = UnityObjectToClipPos(input.Position);
				output.UV = TRANSFORM_TEX(input.UV, _BasicTexture);
				return output;
			}
			
			fixed4 PixelShaderFunction(VertexShaderOutput input) : SV_Target
			{
				fixed4 output = tex2D(_BasicTexture, input.UV);
				return output;
			}
			ENDCG
		}
	}
}
