Shader "3D Graphics with XNA Games Studio 4.0/Chapter 2/01.SimpleEffect"
{
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex VertexShaderFunction
			#pragma fragment PixelShaderFunction

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


			float4 PixelShaderFunction() : SV_Target
			{
				return float4(0.5, 0.5, 0.5, 1);
			}
			ENDCG
		}
	}
}
