Shader "Unlit/NewUnlitShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_XSpeed ("X Speed", Range(0, 10)) = 2
		_YSpeed ("Y Speed", Range(0, 10)) = 2
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		fixed _XSpeed;
		fixed _YSpeed;

		struct Input
        {
            float2 uv_MainTex;
        };

		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed2 uv = IN.uv_MainTex;
			fixed x = _XSpeed * _Time;
			fixed y = _YSpeed * _Time;
			uv += fixed2(x, y);

			half4 c = tex2D(_MainTex, uv);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
			
		ENDCG
	}
}
