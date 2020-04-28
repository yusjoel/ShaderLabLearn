Shader "Debug/UV0"
{
	Properties
	{
		_MainTex ("MainTex", 2D) = "white" {}
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			sampler2D _MainTex;

			struct appdata
			{
				float4 vertex : POSITION;
				float4 uv_MainTex : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 color : TEXCOORD0;
			};
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.uv_MainTex;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return fixed4(i.color.x * 0.5 + 0.5, i.color.y * 0.5 + 0.5, 0, 0);
			}

			ENDCG
		}
	}
}
