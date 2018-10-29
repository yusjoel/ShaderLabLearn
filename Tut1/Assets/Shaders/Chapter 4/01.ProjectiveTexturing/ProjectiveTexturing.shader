Shader "3D Graphics with XNA Games Studio 4.0/Chapter 4/01.ProjectiveTexturing"
{
	Properties
	{
		_BasicTexture ("Texture", 2D) = "white" {}
		_DiffuseColor ("Diffuse Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_AmbientColor ("Ambient Color", Color) = (0.1, 0.1, 0.1, 1)
		_LightDirection ("Light Direction", Vector) = (1, 1, 1)
		_LightColor ("Light Color", Color) = (0.9, 0.9, 0.9, 1.0)
		_ProjectedTexture ("Projected Texture", 2D) = "white" {}
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
			
			sampler2D _BasicTexture;
			float4 _BasicTexture_ST;
			float4 _DiffuseColor;
			float4 _AmbientColor;
			float3 _LightDirection;
			float4 _LightColor;
			sampler2D _ProjectedTexture;
			float4 _ProjectedTexture_ST;
			float4x4 _ProjectorViewProjection;
			
			struct VertexShaderInput
			{
			  float4 Position : POSITION;
			  float2 UV : TEXCOORD0;
			  float3 Normal : NORMAL;
			};
			
			struct VertexShaderOutput
			{
			  float4 Position : SV_POSITION;
			  float2 UV : TEXCOORD0;
			  float3 Normal : TEXCOORD1;
  			  float4 ProjectorScreenPosition : TEXCOORD2;
			};
			
			VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
			{
				VertexShaderOutput output;
				output.Position = UnityObjectToClipPos(input.Position);
				output.UV = TRANSFORM_TEX(input.UV, _BasicTexture);
				output.Normal = mul(input.Normal, (float3x3)unity_WorldToObject);
				float4 worldPosition = mul(unity_ObjectToWorld, input.Position);
				output.ProjectorScreenPosition = mul(_ProjectorViewProjection, worldPosition);
				return output;
			}

			// Calculate the 2D screenposition of a position vector
			float2 postProjToScreen(float4 position)
			{
				float2 screenPos = position.xy / position.w;
				return 0.5f * (float2(screenPos.x, -screenPos.y) + 1);
			}

			// Calculate the size of one half of a pixel, to convert
			// between texels and pixels
			float2 halfPixel()
			{
				return 0.5f / float2(_ScreenParams.x, _ScreenParams.y);
			}

			float4 sampleProjector(float2 UV)
			{
				if (UV.x < 0 || UV.x > 1 || UV.y < 0 || UV.y > 1)
					return float4(0, 0, 0, 0);
				return tex2D(_ProjectedTexture, UV);
			}

			float4 PixelShaderFunction(VertexShaderOutput input) : SV_Target
			{
				float4 color = _DiffuseColor;
				color *= tex2D(_BasicTexture, input.UV);
				
				float4 lighting = _AmbientColor;
				float3 lightDir = normalize(_LightDirection);
				float3 normal = normalize(input.Normal);
				
				lighting += saturate(dot(lightDir, normal)) * _LightColor;
				float4 output = saturate(lighting) * color;

				float4 projection = sampleProjector(postProjToScreen(input.ProjectorScreenPosition) + halfPixel());
				output += projection;

				return output;
			}
			ENDCG
		}
	}
}
