Shader "3D Graphics with XNA Games Studio 4.0/Chapter 8/04.Glow"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}

	SubShader
	{
		Pass
		{
			ZTest Always
			Cull Off
			ZWrite Off

			CGPROGRAM
			#pragma vertex VertexShaderFunction
			#pragma fragment PixelShaderFunction

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _BlurredTexture;

			struct VertexShaderOutput
			{
				float4 Position : SV_POSITION;
				half2 UV : TEXCOORD0;
			};

			VertexShaderOutput VertexShaderFunction(appdata_img input)
			{
				VertexShaderOutput output;
				output.Position = UnityObjectToClipPos(input.vertex);
				output.UV = input.texcoord;
				return output;
			}

			float4 PixelShaderFunction(VertexShaderOutput input) : SV_Target
			{
				float4 unblurred = tex2D(_MainTex, input.UV);
				float4 blurred = tex2D(_BlurredTexture, input.UV);
				float4 additive = saturate(unblurred + blurred);

				return additive;
			}
			ENDCG
		}
	}
}
