Shader "3D Graphics with XNA Games Studio 4.0/Chapter 3/Unity/03.MultipleLightsVertexLit"
{
	Properties
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_BasicTexture ("Texture", 2D) = "white" {}
		_SpecularPower ("Specular Power", Float) = 32
		_SpecularColor ("Specular Color", Color) = (1, 1, 1)
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			Tags { "LightMode" = "Vertex" }

			CGPROGRAM
			#pragma vertex VertexShaderFunction
			#pragma fragment PixelShaderFunction
			
			#include "UnityCG.cginc"

			float4 _Color;
			sampler2D _BasicTexture;
			float4 _BasicTexture_ST;
			float _SpecularPower;
			float4 _SpecularColor;
			
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
				// 模型空间的法线方向
			  	float3 normal : TEXCOORD1;
				// 模型空间的顶点位置
				float3 vertex : TEXCOORD2;
			};
			
			VertexShaderOutput VertexShaderFunction(VertexShaderInput input)
			{
				VertexShaderOutput output;
				output.Position = UnityObjectToClipPos(input.Position);
				output.UV = TRANSFORM_TEX(input.UV, _BasicTexture);
				output.normal = input.Normal;
				output.vertex = input.Position;
				return output;
			}

			// ShadeVertexLightsFull
			// Used in Vertex pass: Calculates diffuse lighting from lightCount lights. Specifying true to spotLight is more expensive
			// to calculate but lights are treated as spot lights otherwise they are treated as point lights.
			float3 CalculateLights (float3 vertex, float3 normal, float3 view, int lightCount, bool spotLight)
			{
				float3 viewpos = UnityObjectToViewPos (vertex);
				float3 viewN = normalize (mul ((float3x3)UNITY_MATRIX_IT_MV, normal));

				float3 lightColor = UNITY_LIGHTMODEL_AMBIENT.xyz;
				for (int i = 0; i < lightCount; i++) {
					float3 toLight = unity_LightPosition[i].xyz - viewpos.xyz * unity_LightPosition[i].w;
					float lengthSq = dot(toLight, toLight);

					// don't produce NaNs if some vertex position overlaps with the light
					lengthSq = max(lengthSq, 0.000001);

					toLight *= rsqrt(lengthSq);

					float atten = 1.0 / (1.0 + lengthSq * unity_LightAtten[i].z);
					if (spotLight)
					{
						float rho = max (0, dot(toLight, unity_SpotDirection[i].xyz));
						float spotAtt = (rho - unity_LightAtten[i].x) * unity_LightAtten[i].y;
						atten *= saturate(spotAtt);
					}

					float diff = max (0, dot (viewN, toLight));
					lightColor += unity_LightColor[i].rgb * (diff * atten);

					float3 refl = reflect(toLight, viewN);
					float3 spec = pow(saturate(dot(refl, view)), _SpecularPower) * _SpecularColor * unity_LightColor[i].a;
					lightColor += spec;

				}
				return lightColor;
			}

			float4 PixelShaderFunction(VertexShaderOutput input) : SV_Target
			{
				float4 color = _Color * tex2D(_BasicTexture, input.UV);
				float3 view = normalize(UnityObjectToViewPos(input.vertex));
				float3 lightColor = CalculateLights(input.vertex, input.normal, view, 8, true);
				return float4(saturate(lightColor) * color, 1);
			}
			ENDCG
		}
	}
}
