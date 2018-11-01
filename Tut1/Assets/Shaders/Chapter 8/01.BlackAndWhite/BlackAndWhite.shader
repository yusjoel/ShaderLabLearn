Shader "3D Graphics with XNA Games Studio 4.0/Chapter 8/01.BlackAndWhite"
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
				float4 color = tex2D(_MainTex, input.UV);
				float intensity = 0.3f * color.r + 0.59f * color.g + 0.11f * color.b;
				return float4(intensity, intensity, intensity, color.a);
			}
			ENDCG
		}
	}
}
