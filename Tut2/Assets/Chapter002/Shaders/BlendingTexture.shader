Shader "CookbookShaders/Chapter002/BlendingTexture"
{
    Properties
    {
        _MainTint ("Diffuse Tint", Color) = (1, 1, 1, 1)
        _ColorA ("Terrain Color A", Color) = (1, 1, 1, 1)
        _ColorB ("Terrain Color B", Color) = (1, 1, 1, 1)
        _RTexture ("Red Channel Texture", 2D) = "" {}
        _GTexture ("Green Channel Texture", 2D) = "" {}
        _BTexture ("Blue Channel Texture", 2D) = "" {}
        _ATexture ("Alpha Channel Texture", 2D) = "" {}
        _BlendTexture ("Blend Texture", 2D) = "" {}
    }
    
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200
        
        CGPROGRAM
        
        #pragma surface surf Lambert

        float4 _MainTint;
        float4 _ColorA;
        float4 _ColorB;
        sampler2D _RTexture;
        sampler2D _GTexture;
        sampler2D _BTexture;
        sampler2D _ATexture;
        sampler2D _BlendTexture;

        struct Input
        {
            float2 uv_BlendTexture;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            float4 blendData = tex2D(_BlendTexture, IN.uv_BlendTexture);
            float4 rColor = tex2D(_RTexture, IN.uv_BlendTexture);
            float4 gColor = tex2D(_GTexture, IN.uv_BlendTexture);
            float4 bColor = tex2D(_BTexture, IN.uv_BlendTexture);
            float4 aColor = tex2D(_ATexture, IN.uv_BlendTexture);

            float4 finalColor = lerp(rColor, gColor, blendData.g);
            finalColor = lerp(finalColor, bColor, blendData.b);
            finalColor = lerp(finalColor, aColor, blendData.a);
            finalColor.a = 1;

            float4 terrainColor = lerp(_ColorA, _ColorB, blendData.r);
            finalColor = saturate(finalColor * terrainColor);

            o.Albedo = finalColor.rgb * _MainTint.rgb;
            o.Alpha = finalColor.a;
        }
        ENDCG
        
    }
    FallBack "Diffuse"
}
