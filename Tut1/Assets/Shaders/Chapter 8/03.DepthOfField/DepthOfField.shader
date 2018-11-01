Shader "3D Graphics with XNA Games Studio 4.0/Chapter 8/03.DepthOfField"
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
			sampler2D _CameraDepthTexture;

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
				// Determine depth
				float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, input.UV);
				float linearDepth = LinearEyeDepth(depth);
				// Get blurred and unblurred render of scene
				float4 unblurred = tex2D(_MainTex, input.UV);
				float4 blurred = tex2D(_BlurredTexture, input.UV);
				// Determine blur amount (similar to fog calculation)
				float _BlurStart = 0;
				float _BlurEnd = 4;
				float blurAmt = clamp((linearDepth - _BlurStart) / (_BlurEnd - _BlurStart), 0, 1);
				// Blend between unblurred and blurred images
				float4 mix = lerp(unblurred, blurred, blurAmt);

				return mix;
			}
			ENDCG
		}
	}
}
