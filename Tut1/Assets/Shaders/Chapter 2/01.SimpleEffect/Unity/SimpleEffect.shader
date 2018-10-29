Shader "3D Graphics with XNA Games Studio 4.0/Chapter 2/Unity/01.SimpleEffect"
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

			float4x4 _ModelMatrix;
			float4x4 _ViewMatrix;
			float4x4 _ProjectionMatrix;

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
				// 标准做法
				//output.Position = UnityObjectToClipPos(input.Position);

				// 将MVP拆开来
				//float4 position = mul(unity_ObjectToWorld, input.Position);
				//position = mul(UNITY_MATRIX_V, position);
				//position = mul(UNITY_MATRIX_P, position);

				// unity_ObjectToWorld = Target.transform.localToWorldMatrix
				float4 position = mul(_ModelMatrix, input.Position);
				// UNITY_MATRIX_V = Camera.worldToCameraMatrix
				position = mul(_ViewMatrix, position);
				// UNITY_MATRIX_P = GL.GetGPUProjectionMatrix(Camera.projectionMatrix, true);
				position = mul(_ProjectionMatrix, position);

				output.Position = position;
				return output;
			}

			float4 PixelShaderFunction() : SV_Target
			{
				return float4(1, 0.5, 0.5, 1);
			}
			ENDCG
		}
	}
}
