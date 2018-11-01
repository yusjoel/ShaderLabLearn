Shader "3D Graphics with XNA Games Studio 4.0/Chapter 8/02.GaussianBlur"
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
			float4 Offsets[15];
			float Weights[15];

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
  				float4 output = float4(0, 0, 0, 1);
  
				for (int i = 0; i < 15; i++)
					output += tex2D(_MainTex, input.UV + Offsets[i]) * Weights[i];
					
				return output;
			}
			ENDCG
		}
	}
}
