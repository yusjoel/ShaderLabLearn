Shader "3D Graphics with XNA Games Studio 4.0/Chapter 2/05.AmbientLighting"
{
	Properties
	{
		_DiffuseColor ("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_AmbientColor ("Ambient Color", Color) = (0.1, 0.1, 0.1, 1)
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
			fixed4 _AmbientColor;
			
			VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
			{
				VertexShaderOutput output;
				output.Position = UnityObjectToClipPos(input.Position);
				return output;
			}

			float4 PixelShaderFunction() : SV_Target
			{
				return _AmbientColor + _DiffuseColor;
			}
			ENDCG
		}
	}
}
