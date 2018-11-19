Shader "CookbookShaders/Chapter002/SpriteSheet"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SpriteCount ("Sprite Count", float) = 2
		_Speed ("Speed", Range(0.01, 32)) = 12
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		fixed _SpriteCount;
		fixed _Speed;

		struct Input
        {
            float2 uv_MainTex;
        };

		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed2 uv = IN.uv_MainTex;
			float spriteWidth = 1 / _SpriteCount;
			float timeVal = fmod(_Time.y * _Speed, _SpriteCount);
			timeVal = floor(timeVal);

			float xValue = (uv.x + timeVal) * spriteWidth;
			half4 c = tex2D(_MainTex, fixed2(xValue, uv.y));
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
			
		ENDCG
	}
}
