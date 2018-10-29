Shader "3D Graphics with XNA Games Studio 4.0/Chapter 2/04.DiffuseColor"
{
	Properties
	{
		_DiffuseColor ("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
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
			
			struct VertexShaderInput
			{
				float4 Position : POSITION;
			};

			struct VertexShaderOutput
			{
				float4 Position : SV_POSITION;
			};
			
			fixed4 _DiffuseColor;
			
			VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
			{
				VertexShaderOutput output;
				output.Position = UnityObjectToClipPos(input.Position);
				return output;
			}


			float4 PixelShaderFunction() : SV_Target
			{
				return _DiffuseColor;
			}
			ENDCG
		}
	}
}
