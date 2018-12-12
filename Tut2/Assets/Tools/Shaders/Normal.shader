Shader "Debug/Normal"
{
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

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float3 normal : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = mul(v.normal, unity_ObjectToWorld);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return fixed4(i.normal * 0.5 + 0.5, 1);
			}

			ENDCG
		}
	}
}
