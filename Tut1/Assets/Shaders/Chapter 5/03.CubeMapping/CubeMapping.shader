Shader "3D Graphics with XNA Games Studio 4.0/Chapter 5/03.CubeMapping"
{
	Properties
	{
		_CubeMap ("Cube Map", Cube) = "white" {}
	}

	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex VertexShaderFunction
			#pragma fragment PixelShaderFunction

			samplerCUBE _CubeMap;

			struct VertexShaderInput
			{
				float4 Position : POSITION;
			};

			struct VertexShaderOutput
			{
				float4 Position : SV_POSITION;
				float3 WorldPosition : TEXCOORD0;
			};
			
			VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
			{
				VertexShaderOutput output;
				output.Position = UnityObjectToClipPos(input.Position);
				output.WorldPosition = mul(unity_ObjectToWorld, input.Position);
				return output;
			}

			float4 PixelShaderFunction(VertexShaderOutput input) : SV_Target
			{
				float3 viewDirection = normalize(input.WorldPosition - _WorldSpaceCameraPos);
				return texCUBE(_CubeMap, viewDirection);
			}
			ENDCG
		}
	}
}
